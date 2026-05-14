FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Set environment variables for GPU/CUDA
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV CUDA_VISIBLE_DEVICES=0
ENV PATH="/root/.unsloth/bin:$PATH"
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Install system dependencies + CUDA utils
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
    cuda-toolkit-12-1 \
    nvidia-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify CUDA installation
RUN echo "=== CUDA Info ===" && \
    which nvcc || echo "nvcc not found" && \
    which nvidia-smi && nvidia-smi || echo "nvidia-smi not found" && \
    ls -la /usr/local/cuda/bin/ | grep -E "(nvidia-smi|nvcc)" || echo "CUDA binaries not found"

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install PyTorch with CUDA explicitly
RUN python3 -m pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install unsloth.ai with CUDA already available
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
