# vLLM Docker Setup para RTX 3090 (Windows 11 WSL2)

Este diretório contém a configuração para rodar o modelo **Qwen3-Coder-30B-A3B-Instruct-GGUF** utilizando o **vLLM** em um ambiente Docker Desktop no Windows 11 com WSL2.

## Pré-requisitos

1.  **Docker Desktop** instalado no Windows 11 com o backend WSL2 ativado.
2.  **NVIDIA Container Toolkit** instalado dentro da sua distribuição WSL2 padrão (geralmente `Ubuntu`).
3.  **GPU RTX 3090** com drivers atualizados no Windows.

## Estrutura de Arquivos

*   `docker-compose.yml`: Define os serviços `vllm` e um exemplo de agente `app-agent`.

## Como Executar

1.  Abra o terminal na pasta `.vllm`.
2.  Inicie os containers:
    ```bash
    docker compose up -d
    ```
3.  O vLLM começará a baixar o modelo do Hugging Face (isso pode demorar). Você pode acompanhar os logs com:
    ```bash
    docker logs -f vllm-qwen3
    ```

## Acesso ao Modelo

*   **De dentro da rede Docker:** Use o endereço `http://vllm:8000/v1`.
*   **Do Windows (Host):** Use `http://localhost:8000/v1`.

### Exemplo de Uso (API compatível com OpenAI)

O vLLM expõe uma API compatível com a OpenAI. Para testar a partir do Windows:

```powershell
Invoke-RestMethod -Uri "http://localhost:8000/v1/chat/completions" -Method Post -Headers @{"Content-Type"="application/json"} -Body '{
  "model": "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF",
  "messages": [{"role": "user", "content": "Olá, quem é você?"}]
}'
```

## Notas Técnicas

*   **Modelo GGUF:** O vLLM carrega o modelo GGUF automaticamente.
*   **Memória:** A RTX 3090 possui 24GB de VRAM. O parâmetro `--max-model-len 32768` foi definido para equilibrar o contexto e o uso de memória. Se ocorrer erro de memória (OOM), reduza este valor (ex: `16384` ou `8192`).
*   **Mapeamento de Portas:** A porta `8000` está mapeada para o host e disponível na rede interna `llm-network` para outros containers.
