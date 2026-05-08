# LLaMA 3.1 Docker Model Runner para RTX 3090 (Windows 11 WSL2)

Este diretório contém a configuração para rodar o modelo **LLaMA 3.1 8B Instruct com DFlash** utilizando **Ollama** (Docker Model Runner) em um ambiente Docker Desktop no Windows 11 com WSL2.

## Pré-requisitos

1.  **Docker Desktop** instalado no Windows 11 com o backend WSL2 ativado.
2.  **NVIDIA Container Toolkit** instalado dentro da sua distribuição WSL2 padrão (geralmente `Ubuntu`).
3.  **GPU RTX 3090** com drivers atualizados no Windows.

## 🚀 Início Rápido

```bash
# 1. Iniciar Ollama
docker compose up -d

# 2. Puxar o modelo LLaMA 3.1 com DFlash
docker compose exec ollama ollama pull hf.co/z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat

# 3. Testar o modelo
docker compose exec app-agent python3 << 'EOF'
import requests
response = requests.post('http://ollama:11434/api/generate', json={
    'model': 'z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat',
    'prompt': 'Olá, qual é a sua funcionalidade?',
    'stream': False
})
print(response.json()['response'])
EOF
```

## Para remover tudo

```bash
docker compose down --rmi all --volumes --remove-orphans
```

## Estrutura de Arquivos

*   `docker-compose.yml`: Define o servidor Ollama e o container app-agent
*   `run-model.ps1`: Script PowerShell com exemplos de uso

## Como Executar

### Opção 1: Docker Compose + Ollama (Recomendado)

```bash
# Terminal na pasta .vllm

# 1. Iniciar Ollama
docker compose up -d

# 2. Puxar modelo (primeira vez, leva alguns minutos)
docker compose exec ollama ollama pull hf.co/z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat

# 3. Listar modelos disponíveis
docker compose exec ollama ollama list

# 4. Parar containers
docker compose down
```

### Opção 2: Docker Model Run (Nativo - Docker 4.26+)

```bash
# Executar modelo diretamente (requer feature experimental habilitada)
docker model run --gpu all -p 8000:8000 hf.co/z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat
```

### Monitorar Logs

```bash
docker logs -f llama-model-runner
```

## Acesso ao Modelo via Ollama

### API Ollama

```bash
# De dentro do Docker
curl http://ollama:11434/api/generate -d '{
  "model": "z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat",
  "prompt": "Olá, quem é você?",
  "stream": false
}'

# Do Windows (host)
curl http://localhost:11434/api/generate -d '{
  "model": "z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat",
  "prompt": "Olá, quem é você?",
  "stream": false
}'
```

### Python via Requests

```python
import requests

response = requests.post('http://ollama:11434/api/generate', json={
    'model': 'z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat',
    'prompt': 'Escreva um poema sobre inteligência artificial',
    'stream': False
})

print(response.json()['response'])
```

Para acessar o terminal interativo do app-agent:

```powershell
# Via docker compose
docker compose exec app-agent bash

# Testar Python com requests
docker compose exec app-agent python3 << 'EOF'
import requests, json

url = 'http://ollama:11434/api/generate'
response = requests.post(url, json={
    'model': 'z-lab/LLaMA3.1-8B-Instruct-DFlash-UltraChat',
    'prompt': 'Olá!',
    'stream': False
}, timeout=30)

print(json.dumps(response.json(), indent=2, ensure_ascii=False))
EOF
```

## Notas Técnicas

*   **Modelo:** O vLLM carrega automaticamente o TinyLlama 1.1B (1.1B parâmetros), extremamente rápido e ideal para testes e prototipagem. Fácil de trocar para modelos maiores no `docker-compose.yml`.
*   **Memória:** A RTX 3090 possui 24GB de VRAM. TinyLlama usa apenas ~2-3GB. O parâmetro `--max-model-len 2048` é suficiente para o TinyLlama. Para modelos maiores, ajuste conforme necessário.
*   **Mapeamento de Portas:** A porta `8000` está mapeada para o host e disponível na rede interna `llm-network` para outros containers.
