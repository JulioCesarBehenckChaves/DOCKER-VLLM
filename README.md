
# Subindo modelo MTP no docker 

O docker models ainda não está operativo para o MTP 
docker model run hf.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M

Vemos o erro:
```log
Model pulled successfully
> background model preload failed: preload failed: status=500 body=unable to load runner: error waiting for runner to be ready: llama.cpp terminated unexpectedly: llama.cpp failed: failed to load model

Verbose output:
llama_model_load: error loading model: missing tensor 'blk.64.ssm_conv1d.weight'
llama_model_load_from_file_impl: failed to load model
common_init_from_params: failed to load model 'C:\Users\julio.chaves\.docker\models\bundles\sha256\d30369427477c78f18ed3738a3b75e52a799623ca861d16d7f7e862723418e37\model\model.gguf'
srv    load_model: failed to load model, 'C:\Users\julio.chaves\.docker\models\bundles\sha256\d30369427477c78f18ed3738a3b75e52a799623ca861d16d7f7e862723418e37\model\model.gguf'
srv   operator (): operator (): cleaning up before exit...
main: exiting due to model loading error
nfo: EOG token             = 248044 '<|endoftext|>'
print_info: EOG token             = 248046 '<|im_end|>'
print_info: EOG token             = 248063 '<|fim_pad|>'
print_info: EOG token             = 248064 '<|repo_name|>'
print_info: EOG token             = 248065 '<|file_sep|>'
print_info: max token length      = 256
load_tensors: loading model tensors, this can take a while... (mmap = true, direct_io = false)
Quero usar o modelo MTP
```

Vamos criar um Dockerfile e um docker-compose.yml para subir o modelo MTP no docker usando o unsloth.ai.

curl -fsSL https://unsloth.ai/install.sh | sh

llama-server -hf unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_M