#!/bin/bash
# Quick start script for Qwen MTP server

set -e

echo "🚀 Qwen3.6-35B-A3B-MTP Quick Start"
echo "=================================="

# Check if image exists
if docker image inspect vllm-qwen-qwen-mtp >/dev/null 2>&1; then
    echo "✅ Image encontrada"
else
    echo "📦 Building Docker image..."
    docker compose build
fi

echo ""
echo "🔧 Iniciando servidor..."
docker compose up -d

echo ""
echo "⏳ Aguardando servidor ficar pronto (pode levar alguns minutos na primeira vez)..."
sleep 10

# Check if server is responding
for i in {1..30}; do
    if curl -s http://localhost:8080/v1/models >/dev/null 2>&1; then
        echo "✅ Servidor pronto!"
        break
    fi
    echo "⏳ Tentativa $i/30..."
    sleep 5
done

echo ""
echo "📝 Testando API..."
python3 test-api.py

echo ""
echo "✅ Tudo pronto! Servidor rodando em http://localhost:8080/v1"
echo ""
echo "Comandos úteis:"
echo "  docker compose logs -f       # Ver logs"
echo "  docker compose stop          # Parar servidor"
echo "  docker compose down          # Parar e remover"
echo "  python3 test-api.py          # Testar API"
