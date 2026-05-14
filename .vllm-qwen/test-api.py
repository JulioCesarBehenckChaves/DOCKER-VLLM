#!/usr/bin/env python3
"""
Test script for Qwen MTP llama-server API.
Requires the server to be running on http://localhost:8080
"""

import requests
import json
import time
import sys

BASE_URL = "http://localhost:8080/v1"
MODEL = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M"

def check_server():
    """Check if server is running"""
    try:
        response = requests.get(f"{BASE_URL}/models", timeout=5)
        response.raise_for_status()
        return True
    except requests.exceptions.RequestException as e:
        print(f"❌ Servidor não está acessível: {e}")
        return False

def test_completion():
    """Test basic completion"""
    prompt = "What is 2+2? Answer briefly."

    print(f"\n📝 Testando completion com prompt: '{prompt}'")

    try:
        response = requests.post(
            f"{BASE_URL}/completions",
            json={
                "model": MODEL,
                "prompt": prompt,
                "max_tokens": 50,
                "temperature": 0.7,
            },
            timeout=30
        )
        response.raise_for_status()

        result = response.json()
        completion = result["choices"][0]["text"]

        print(f"✅ Resposta: {completion}")
        print(f"   Tokens utilizados: {result['usage']['total_tokens']}")

        return True
    except Exception as e:
        print(f"❌ Erro na completion: {e}")
        return False

def test_chat():
    """Test chat completions (OpenAI-compatible)"""
    messages = [
        {"role": "user", "content": "Qual é a capital da França?"}
    ]

    print(f"\n💬 Testando chat completion...")

    try:
        response = requests.post(
            f"{BASE_URL}/chat/completions",
            json={
                "model": MODEL,
                "messages": messages,
                "max_tokens": 100,
                "temperature": 0.7,
            },
            timeout=30
        )
        response.raise_for_status()

        result = response.json()
        content = result["choices"][0]["message"]["content"]

        print(f"✅ Resposta: {content}")
        print(f"   Tokens utilizados: {result['usage']['total_tokens']}")

        return True
    except Exception as e:
        print(f"❌ Erro no chat: {e}")
        return False

def main():
    print("🚀 Testando Qwen3.6-35B-A3B-MTP com unsloth.ai")
    print(f"📍 URL: {BASE_URL}")

    print("\n⏳ Verificando se servidor está rodando...")

    if not check_server():
        print("\n💡 Inicie o servidor com: docker compose up")
        sys.exit(1)

    print("✅ Servidor está online!")

    # Run tests
    success = True

    if not test_completion():
        success = False

    if not test_chat():
        success = False

    if success:
        print("\n✅ Todos os testes passaram!")
    else:
        print("\n❌ Alguns testes falharam")
        sys.exit(1)

if __name__ == "__main__":
    main()
