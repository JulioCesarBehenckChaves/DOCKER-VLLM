FROM ubuntu:22.04

# Set environment variables for GPU/CUDA
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    cmake \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install unsloth.ai
RUN curl -fsSL https://unsloth.ai/install.sh | sh

# Set working directory
WORKDIR /workspace

# Expose port for llama-server (default 8080)
EXPOSE 8080

# Default command: run llama-server with Qwen3.6-35B-A3B-MTP-GGUF
# GPU acceleration will work with nvidia-docker or docker with --gpus flag
ENTRYPOINT ["llama-server"]
CMD ["-hf", "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M"]
