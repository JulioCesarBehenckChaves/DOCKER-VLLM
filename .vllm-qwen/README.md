# Qwen3.6-35B-A3B-MTP com Unsloth.ai

## Problema Anterior
O Docker models native não era compatível com o formato MTP do Qwen. Erro ao tentar usar:
```
docker model run hf.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M
```

Erro: `missing tensor 'blk.64.ssm_conv1d.weight'` - llama.cpp não conseguia carregar o modelo.

## Solução: Unsloth.ai

Usando unsloth.ai com Docker para rodar o llama-server de forma compatível com o MTP.

### Uso Rápido

**Build da imagem:**
```bash
docker compose build
```

**Rodar o servidor:**
```bash
docker compose up
```

O servidor estará acessível em `http://localhost:8080/v1` (OpenAI compatible API).

**Executar em background:**
```bash
docker compose up -d
```

**Parar o servidor:**
```bash
docker compose down
```

**Ver logs:**
```bash
docker compose logs -f qwen-mtp
```

### Detalhes

- **Base image**: NVIDIA CUDA 12.4.1 + Ubuntu 24.04 (GPU acelerado)
- **Runtime**: unsloth.ai com llama-server
- **Modelo**: Qwen3.6-35B-A3B-MTP-GGUF (quantizado em Q4_K_M)
- **GPU**: RTX3090 (24GB VRAM) - detectada automaticamente
- **Porta**: 8080 (mapeado para localhost:8080)
- **Cache**: Volumes locais para modelos e cache do Hugging Face

### Performance Esperado

Com RTX3090:
- **Tamanho do modelo**: ~20GB (Q4_K_M)
- **VRAM utilizado**: ~22-23GB (modelo + cache)
- **Latência**: ~100-200ms para tokens iniciais (com GPU)
- **Throughput**: ~50-100 tokens/segundo (dependendo da quantização)

### Pré-requisitos

- Docker com suporte a NVIDIA GPU
- nvidia-docker ou Docker Desktop com NVIDIA container runtime
- Verificar instalação:
  ```bash
  nvidia-smi
  docker run --rm --gpus all nvidia/cuda:12.4.1-runtime-ubuntu24.04 nvidia-smi
  ```

### Testes

**Script de validação GPU:**
```bash
bash test-gpu.sh
```

Verifica nvidia-smi no host, testa Docker com GPU e inicia o servidor.

**Teste da API:**
```bash
# Terminal 1: Inicie o servidor
docker compose up

# Terminal 2: Teste a API
python3 test-api.py
```

O script testa completions e chat completions com a API OpenAI-compatível.

### Referências

- [Unsloth.ai](https://unsloth.ai)
- [Qwen3.6-35B no Hugging Face](https://huggingface.co/z-lab/Qwen3.6-35B-A3B-DFlash)
- [Modelo MTP no Hugging Face](https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF)