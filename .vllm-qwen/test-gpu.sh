#!/bin/bash

echo "=== Verificando GPU Host ==="
nvidia-smi

echo ""
echo "=== Verificando Docker + NVIDIA Runtime ==="
docker run --rm --gpus all nvidia/cuda:12.4.1-runtime-ubuntu24.04 nvidia-smi

echo ""
echo "=== Build do Dockerfile ==="
docker compose build

echo ""
echo "=== Iniciando container com GPU ==="
docker compose up
