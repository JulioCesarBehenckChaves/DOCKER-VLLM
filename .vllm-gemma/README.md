
6x mais perf com dflash - testar

https://github.com/z-lab/dflash

https://huggingface.co/z-lab/gemma-4-31B-it-DFlash



**✅ Entendi o erro exato: 403 Forbidden no GHCR**

Mesmo após o `docker login` ter dado "Login Succeeded", o pull falha com **403**. Isso acontece porque o pacote `ghcr.io/z-lab/vllm-openai:gemma4-dflash-cu130` **não está público** (ou está com visibilidade privada/interna no GitHub Container Registry do time z-lab).

O README oficial deles ainda recomenda essa imagem (atualizado há 2 dias), mas na prática o Docker não consegue acessar — é um problema conhecido com builds temporárias deles. Sua conta não tem permissão (mesmo com token `read:packages`).

### O que fazer agora (soluções práticas no Windows)

#### Opção 1 — Mais rápida e recomendada: Use a imagem **oficial pública** do vLLM para Gemma 4
A vLLM já tem uma imagem oficial com suporte a Gemma-4 (pode até já ter o DFlash incluído ou quase).

```powershell
# 1. Baixe a imagem oficial (é pública, não precisa de login)
docker pull vllm/vllm-openai:gemma4-cu130

# 2. Rode o container (mesmo comando que você usou antes, só troca a imagem)

docker run --rm -it `
  --gpus all `
  --ipc=host `
  --shm-size=16g `
  -p 8000:8000 `
  -v "%USERPROFILE%\.cache\huggingface:/root/.cache/huggingface" `
  vllm/vllm-openai:gemma4-cu130 `
  google/gemma-4-31B-it `
  --host 0.0.0.0 `
  --port 8000 `
  --speculative-config '{"method": "dflash", "model": "z-lab/gemma-4-31B-it-DFlash", "num_speculative_tokens": 15, "attention_backend": "flash_attn"}' `
  --attention-backend triton_attn `
  --max-num-batched-tokens 32768 `
  --trust-remote-code
  
docker run --rm -it --gpus all --ipc=host --shm-size=16g -p 8000:8000 -v "%USERPROFILE%\.cache\huggingface:/root/.cache/huggingface" vllm/vllm-openai:gemma4-cu130 google/gemma-4-31B-it --host 0.0.0.0 --port 8000 --speculative-config "{\"method\": \"dflash\", \"model\": \"z-lab/gemma-4-31B-it-DFlash\", \"num_speculative_tokens\": 15, \"attention_backend\": \"flash_attn\"}" --attention-backend triton_attn --max-num-batched-tokens 128000 --trust-remote-code
```

**O que pode acontecer:**
- Se o DFlash já estiver suportado na imagem oficial → funciona perfeitamente (ganho de velocidade).
- Se ainda não tiver o patch do Gemma4 → vai dar erro no log (algo como "dflash not supported" ou "unknown method"). Nesse caso me cola o erro completo.

#### Opção 2 — Se a Opção 1 falhar com DFlash
Use a versão **sem** speculative decoding (só o modelo normal Gemma-4-31B-it). Ainda é muito bom:

Remova as linhas do `--speculative-config` e rode só com:

```powershell
docker run --rm -it `
  --gpus all `
  --ipc=host `
  --shm-size=16g `
  -p 8000:8000 `
  -v "%USERPROFILE%\.cache\huggingface:/root/.cache\huggingface" `
  vllm/vllm-openai:gemma4-cu130 `
  google/gemma-4-31B-it `
  --host 0.0.0.0 `
  --port 8000 `
  --attention-backend triton_attn `
  --max-num-batched-tokens 32768 `
  --trust-remote-code
```

### Dica extra para Windows
- Certifique-se de que o **Docker Desktop** tem GPU ativada (Settings → Resources → WSL integration).
- A primeira execução vai baixar ~60-70 GB do modelo (paciência + boa internet).
- Para parar: `Ctrl + C` ou `docker stop $(docker ps -q)`

Rode a **Opção 1** agora e me cola o resultado (ou o erro que aparecer no terminal).  
Se der certo com DFlash, ótimo! Se não, a gente parte para instalar via WSL2 (mais estável no Windows).

Qualquer erro novo, só colar aqui que resolvemos rapidinho! 🚀