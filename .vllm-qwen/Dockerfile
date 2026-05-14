FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Set environment variables for GPU/CUDA
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV CUDA_VISIBLE_DEVICES=0
ENV PATH="/root/.unsloth/bin:$PATH"
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Install system dependencies (sem nvidia-utils que não existe)
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install PyTorch with CUDA 12.1 explicitly
RUN python3 -m pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install unsloth.ai with PyTorch/CUDA already in place
RUN curl -fsSL https://unsloth.ai/install.sh | sh

# Create cache directory for models
RUN mkdir -p /root/.cache/huggingface/hub

# Set working directory
WORKDIR /workspace

# Expose port for llama-server (default 8080)
EXPOSE 8080

# Default command: run llama-server with Qwen3.6-35B-A3B-MTP-GGUF
ENTRYPOINT ["llama-server"]
CMD ["-hf", "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M"]
