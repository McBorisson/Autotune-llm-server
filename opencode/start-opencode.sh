#!/bin/bash

# 1. Sync the model from llm-server to opencode.json
"$(dirname "$(readlink -f "$0")")/sync-opencode-model.sh"

# 2. Start OpenCode
/home/mik/.local/bin/opencode "$@"