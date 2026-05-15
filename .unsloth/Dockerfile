FROM unsloth/unsloth:latest

# ===========================================================================
# Dockerfile para Unsloth - Fine-tuning LLMs com GPU
# Base oficial: unsloth/unsloth (imagem oficial mantida pela equipe Unsloth)
# Documentação: https://unsloth.ai/docs/get-started/install/docker
# ===========================================================================

# A imagem oficial já inclui:
#   - CUDA, PyTorch, Unsloth, Jupyter Lab
#   - Notebooks de exemplo em /workspace/unsloth-notebooks/
#   - Usuário não-root 'unsloth' (sudo com USER_PASSWORD)
#   - SSH server (porta 22)

# Labels para identificação
LABEL maintainer="Unsloth AI"
LABEL description="Unsloth Docker image for fine-tuning LLMs with GPU acceleration"
LABEL source="https://hub.docker.com/r/unsloth/unsloth"

# Variáveis de ambiente padrão (podem ser sobrescritas no docker-compose ou docker run)
ENV JUPYTER_PORT=8888
ENV JUPYTER_PASSWORD=unsloth
ENV USER_PASSWORD=unsloth

# Montagem recomendada: volume para preservar trabalhos entre execuções
#   - /workspace/work/    → Diretório de trabalho montado
#   - /workspace/unsloth-notebooks/ → Notebooks de exemplo
#   - /home/unsloth/      → Home do usuário

# Expose ports
EXPOSE 8888  # Jupyter Lab
EXPOSE 8000  # Jupyter Lab (alternativo)
EXPOSE 22    # SSH

# WORKDIR já definido na imagem base
WORKDIR /workspace

# O entrypoint padrão da imagem base já gerencia
# Jupyter Lab e SSH automaticamente
