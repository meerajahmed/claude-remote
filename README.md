# Claude Code + Remote Ollama via LiteLLM

This project provides a guide and configuration for running the Claude Code CLI locally while using a model hosted on a remote Ollama server. This setup uses **LiteLLM** as a proxy to translate the Anthropic Messages API (used by Claude Code) into the Ollama API.

## Architecture
`Claude Code` → `LiteLLM (Local Proxy)` → `SSH Tunnel` → `Remote Ollama Server`

## Prerequisites
- **Local Machine**: macOS (or Linux) with Node.js ≥ 18 and Python 3 installed.
- **Remote Server**: An Ollama instance running with the desired model already pulled.
- **SSH Access**: Ability to SSH into your remote server.

## Setup Instructions

### 1. Install Claude Code
Install the official Claude Code CLI globally:
```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Install LiteLLM
Install LiteLLM with the proxy support.
*Note: Avoid versions 1.82.7 and 1.82.8 due to known security issues.*
```bash
pip3 install "litellm[proxy]!=1.82.7,!=1.82.8" --break-system-packages
```

### 3. Configure LiteLLM
Create a file named `litellm_config.yaml` (see the example provided in this repo) and update it with your specific details:
- `model_name`: This **must** match the model ID Claude Code expects (you can check this by running `claude` and then `/status` inside the session).
- `api_base`: The local port where your SSH tunnel is mapped.
- `model`: The Ollama model path on your remote server.

### 4. Running the Setup
Every time you want to use the system, you need three terminal tabs:

#### Tab 1: SSH Tunnel
Map the remote Ollama port (usually 11434) to your local machine:
```bash
ssh -N -L 11434:localhost:11434 <your_user>@<remote_ip>
```

#### Tab 2: LiteLLM Proxy
Start the proxy using your configuration:
```bash
litellm --config litellm_config.yaml --port 4000
```

#### Tab 3: Claude Code
Export the necessary environment variables and start the CLI:
```bash
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_AUTH_TOKEN=sk-local-dev-key
claude
```

## Troubleshooting

| Symptom | Cause | Fix |
| :--- | :--- | :--- |
| Claude Code shows a login screen | Env vars not set in the current shell | Re-run the `export` lines in the same tab |
| "Model not found" error | `model_name` in config doesn't match request | Check `/status` in Claude Code; update `litellm_config.yaml` or set `export ANTHROPIC_MODEL=<name>` |
| Connection refused on `localhost:4000` | LiteLLM proxy not running | Ensure Tab 2 is alive |
| Connection refused on `localhost:11434` | SSH tunnel dropped | Ensure Tab 1 is alive and reconnect if needed |
| Responses cut off mid-sentence | `max_tokens` too low | Add `max_tokens: 4096` to `litellm_params` in `litellm_config.yaml` and restart proxy |
