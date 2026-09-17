#!/bin/bash

# This script helps set up the environment for Claude Code with a remote Ollama server.
# It assumes you have already:
# 1. Installed Node.js and Python.
# 2. Installed Claude Code.
# 3. Installed LiteLLM.
# 4. Configured your litellm_config.yaml (copied from litellm_config.yaml.example).

# Set the proxy URL
export ANTHROPIC_BASE_URL=http://localhost:4000
# Set a dummy auth token (LiteLLM will use this for the proxy)
export ANTHROPIC_AUTH_TOKEN=sk-local-dev-key

echo "Environment variables have been set."
echo "Next steps:"
echo "1. Start your SSH tunnel in Tab 1."
echo "2. Start the LiteLLM proxy in Tab 2."
echo "3. Run 'claude' in this tab."
