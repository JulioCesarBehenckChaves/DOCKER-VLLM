#!/bin/bash

echo "🚀 Qwen MTP Setup - Escolha a abordagem:"
echo "========================================"
echo ""
echo "1) Unsloth.ai (recomendado, mais rápido)"
echo "2) Compilar llama.cpp do source (mais compatível)"
echo "3) Cancelar"
echo ""
read -p "Escolha [1-3]: " choice

case $choice in
    1)
        echo "✅ Usando Dockerfile com unsloth.ai"
        cp Dockerfile Dockerfile.bak
        echo "Usando: Dockerfile (unsloth.ai)"
        ;;
    2)
        echo "✅ Usando Dockerfile.simple (compilação)"
        cp Dockerfile Dockerfile.bak
        cp Dockerfile.simple Dockerfile
        echo "Atenção: Compilação levará ~30-60 minutos"
        ;;
    3)
        echo "Cancelado"
        exit 0
        ;;
    *)
        echo "Opção inválida"
        exit 1
        ;;
esac

echo ""
echo "📦 Building Docker image..."
docker compose build --no-cache

echo ""
echo "✅ Build concluído!"
echo ""
echo "🚀 Iniciando servidor..."
docker compose up -d

echo ""
echo "⏳ Aguardando servidor ficar pronto..."
sleep 10

echo ""
echo "✅ Servidor rodando em http://localhost:8080/v1"
echo ""
echo "Testes:"
echo "  docker compose logs -f"
echo "  python3 test-api.py"
