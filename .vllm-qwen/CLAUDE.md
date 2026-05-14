# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This directory is an experimental workspace for testing the Qwen 3.6-35B language model with different optimization approaches, particularly focusing on DFlash and Docker model integration. It's part of a larger Docker-based AI agent environment (see parent project at `../.vllm`).

## Implementation Status

**✅ Solved**: Docker/unsloth.ai integration with GPU acceleration implemented.

- **Base Image**: Ubuntu 22.04 (optimized for compatibility)
- **GPU Support**: RTX3090 (24GB VRAM) via docker --gpus or nvidia-docker
- **Model**: Qwen3.6-35B-A3B-MTP-GGUF (Q4_K_M quantization) via HuggingFace
- **API**: OpenAI-compatible endpoint at `http://localhost:8080/v1`
- **Performance**: Expected ~50-100 tokens/sec with RTX3090 acceleration
- **CUDA**: Installed dynamically by unsloth.ai on first run (cleaner builds)

## Previous Approach (Docker Models)

Docker's native model runtime failed with: missing tensor `blk.64.ssm_conv1d.weight`. Unsloth.ai was chosen as a workaround because it handles GGUF models correctly.

## Current Focus

1. **Performance Testing**: Measure inference latency and throughput with the MTP variant
2. **DFlash Exploration**: When ready, can test DFlash variant https://huggingface.co/z-lab/Qwen3.6-35B-A3B-DFlash for comparison
3. **Integration**: Connect this service to applications for production testing

## Repository Structure

```
.vllm-qwen/
├── README.md             # Project documentation and usage
├── CLAUDE.md             # This file
├── Dockerfile            # Build image with unsloth.ai
├── docker-compose.yml    # Service configuration
├── .gitignore            # Ignore models and cache directories
├── models/               # Downloaded model files (in .gitignore)
├── cache/                # HuggingFace cache (in .gitignore)
└── .claude/              # Claude Code configuration
```

## Related Documentation

- **Parent Project**: See `../.vllm/CLAUDE.md` for the complete Docker environment setup, which provides the runtime for testing models here
- **Main README**: `README.md` contains links to DFlash and model references being tested

## Development Notes

**Workspace Context:**
- Part of a larger Docker-based AI agent environment with Python 3.11, data science stack, and CLI agents
- Workspace mounted at `/workspaces` in the parent Docker setup
- Git repository is initialized in this directory; commits track experiments with specific model variants

**Current Experiments:**
- DFlash 6x performance improvement attempt
- Docker model runner compatibility (troubleshooting GGUF tensor loading issues)
- Qwen3.6-35B-A3B variant testing

**Key Challenge:**
The current blocker is that llama.cpp (used by Docker models) fails to load the Qwen MTP variant due to missing tensor definitions. This may require:
- Using a different quantization format (Q4_K_M vs default)
- Using unsloth.ai instead of Docker models
- Switching to a GGUF-compatible variant

## Next Steps

When continuing work in this directory:
1. Review the git log to see what approaches have been tried (`git log --oneline`)
2. Check the parent project's Docker setup for available runtime tools
3. Update `README.md` with findings and resolved blockers
4. Commit experimental results with clear messages in Portuguese (project standard) or English
