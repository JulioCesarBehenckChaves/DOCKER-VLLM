#!/bin/bash

# Monitor script - acompanha o progresso do setup Qwen MTP

echo "🚀 Monitor Qwen MTP Setup"
echo "========================"
echo ""

while true; do
    clear
    echo "📊 STATUS - $(date '+%H:%M:%S')"
    echo "=============================="
    echo ""

    # Check Docker image
    if docker image ls | grep -q qwen; then
        echo "✅ [1/4] Docker image compilada"
    else
        echo "⏳ [1/4] Compilando Docker image..."
        docker image ls | head -3 | tail -1 | awk '{print "         Size:", $2}'
    fi
    echo ""

    # Check container running
    if docker ps | grep -q qwen-mtp-server; then
        echo "✅ [2/4] Container rodando"
        CONTAINER_ID=$(docker ps | grep qwen-mtp-server | awk '{print $1}')
        echo "         Container: $CONTAINER_ID"
    elif docker ps -a | grep -q qwen-mtp-server; then
        echo "⏳ [2/4] Container parado"
    else
        echo "⏳ [2/4] Aguardando container..."
    fi
    echo ""

    # Check model download
    if [ -d ~/.cache/huggingface/hub ]; then
        MODEL_SIZE=$(du -sh ~/.cache/huggingface/hub 2>/dev/null | awk '{print $1}')
        echo "✅ [3/4] Modelo no cache: $MODEL_SIZE"
    else
        echo "⏳ [3/4] Aguardando download do modelo..."
    fi
    echo ""

    # Check server ready
    if curl -s http://localhost:8080/v1/models >/dev/null 2>&1; then
        echo "✅ [4/4] Servidor pronto!"
        echo ""
        echo "🎉 Sistema completo! Pronto para inference!"
        echo ""
        echo "🔗 Endpoint: http://localhost:8080/v1"
        echo ""
        echo "Teste rápido:"
        echo "  python3 test-api.py"
        echo ""
        break
    else
        echo "⏳ [4/4] Aguardando servidor ficar pronto..."
    fi

    echo ""
    echo "📝 Últimas linhas do log:"
    docker compose logs --tail=3 2>/dev/null | sed 's/^/   /'
    echo ""
    echo "---"
    echo "Próxima atualização em 10 segundos... (Ctrl+C para sair)"
    sleep 10
done
