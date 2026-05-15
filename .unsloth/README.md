# Unsloth Docker Setup

Fine-tuning de LLMs com Unsloth via Docker, com suporte a GPU.

## Pré-requisitos

- **Docker** instalado (Docker Desktop no Windows, docker.io no Linux)
- **NVIDIA GPU** com drivers CUDA
- **NVIDIA Container Toolkit** (no Linux) ou Docker Desktop com WSL2 + CUDA (no Windows)

### Instalar NVIDIA Container Toolkit (Linux)

```bash
export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1
sudo apt-get update && sudo apt-get install -y \
  nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}
```

No Windows, siga: https://docs.docker.com/desktop/features/gpu/

## Como usar

### 1. Criar diretório de trabalho

```bash
mkdir -p work
```

### 2. Subir o container

```bash
docker compose up -d
```

### 3. Acessar Jupyter Lab

Abra http://localhost:8888 no navegador.
Senha padrão: `unsloth`

### 4. Acessar via SSH

```bash
# Gerar chave SSH (se não tiver)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/unsloth_container

# Conectar
ssh -i ~/.ssh/unsloth_container -p 2222 unsloth@localhost
```

Senha sudo do usuário `unsloth`: `unsloth`

## Estrutura do container

| Diretório | Descrição |
|-----------|-----------|
| `/workspace/work/` | Seu diretório de trabalho (montado via volume) |
| `/workspace/unsloth-notebooks/` | Notebooks de exemplo do Unsloth |
| `/home/unsloth/` | Home do usuário |

## Personalização

Edite `docker-compose.yml` para alterar:

- **Senha do Jupyter**: variável `JUPYTER_PASSWORD`
- **Portas**: mapeamento `ports:`
- **Diretório de trabalho**: volume `./work:/workspace/work`
- **Chave SSH**: descomente `SSH_KEY` no `environment`

## Referência

- Documentação oficial: https://unsloth.ai/docs/get-started/install/docker
- Imagem Docker: https://hub.docker.com/r/unsloth/unsloth
