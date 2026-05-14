#!/bin/bash

# Entrypoint script - tries different server options

MODEL="${1:-unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M}"

echo "Starting Qwen MTP Server..."
echo "Model: $MODEL"
echo ""

# Try llama-server from unsloth
if command -v llama-server &> /dev/null; then
    echo "✅ Using llama-server (unsloth)"
    exec llama-server -hf "$MODEL"
fi

# Try llama.cpp prebuilt
if [ -f /root/.unsloth/llama.cpp/server ]; then
    echo "✅ Using llama.cpp prebuilt"
    exec /root/.unsloth/llama.cpp/server -hf "$MODEL"
fi

# Try python llama-cpp-python server
if python3 -c "import llama_cpp" 2>/dev/null; then
    echo "⚠️  Using python llama-cpp-python server (slower)"

    # Create a simple HTTP server using llama-cpp-python
    python3 << 'PYTHON_EOF'
import os
from llama_cpp import Llama
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import uvicorn
import json

app = FastAPI()
model_name = os.environ.get('MODEL_NAME', 'unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M')

# Load model
llm = Llama.from_pretrained(
    model_name=model_name,
    verbose=True,
    n_gpu_layers=-1  # Use GPU
)

@app.post("/v1/completions")
async def completions(request: dict):
    response = llm(
        request.get('prompt', ''),
        max_tokens=request.get('max_tokens', 128),
        temperature=request.get('temperature', 0.7)
    )
    return response

@app.post("/v1/chat/completions")
async def chat_completions(request: dict):
    # Simple implementation
    messages = request.get('messages', [])
    prompt = '\n'.join([f"{m['role']}: {m['content']}" for m in messages])

    response = llm(
        prompt,
        max_tokens=request.get('max_tokens', 128),
        temperature=request.get('temperature', 0.7)
    )
    return response

@app.get("/v1/models")
async def models():
    return {"object": "list", "data": [{"id": model_name, "object": "model"}]}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
PYTHON_EOF

    exit 0
fi

echo "❌ ERROR: No compatible server found!"
echo "Tried: llama-server, llama.cpp, llama-cpp-python"
exit 1
