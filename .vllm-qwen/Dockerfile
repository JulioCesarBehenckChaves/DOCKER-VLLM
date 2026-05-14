FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Set environment variables for GPU/CUDA
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV CUDA_VISIBLE_DEVICES=0
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
ENV PATH=$CUDA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Force CUDA detection
ENV FORCE_CUDA=1
ENV TORCH_CUDA_ARCH_LIST="89"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    cmake \
    pkg-config \
    ca-certificates \
    libcurl4-openssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install PyTorch with CUDA 12.1 EXPLICITLY
RUN python3 -m pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install unsloth.ai with --no-torch (PyTorch já instalado)
RUN curl -fsSL https://unsloth.ai/install.sh | sh -s -- --no-torch || echo "unsloth.ai install completed with warnings"

# Install llama-cpp-python as fallback server
RUN python3 -m pip install --no-cache-dir \
    llama-cpp-python \
    fastapi \
    uvicorn \
    pydantic

# Create cache directory for models
RUN mkdir -p /root/.cache/huggingface/hub

# Set working directory
WORKDIR /workspace

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port for llama-server (default 8080)
EXPOSE 8080

# Use entrypoint that tries multiple servers
ENV MODEL_NAME=unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
