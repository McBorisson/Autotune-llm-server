#!/bin/bash
#
# install.sh — Robust installer for llm-server and downloader
# Installs to ~/.local/bin and ensures dependencies are met.
#

set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
MODEL_DIR="${HOME}/ai_models"
mkdir -p "$INSTALL_DIR"
mkdir -p "$MODEL_DIR"

echo "═══ llm-server Installer ═══"
echo "Target directory: $INSTALL_DIR"
echo ""

# List of files to copy from current directory to INSTALL_DIR
FILES=("llm-server" "llm-server-gui")

for f in "${FILES[@]}"; do
    if [[ -f "$f" ]]; then
        cp "$f" "$INSTALL_DIR/$f"
        chmod +x "$INSTALL_DIR/$f"
        echo "  ✓ Installed $f"
    else
        echo "  ⚠ Warning: $f not found in current directory, skipping."
    fi
done

# Install the downloader to the model dir (where llm-server looks for it)
if [[ -f "/home/mik/ai_models/download_any_gguf.py" ]]; then
    echo "  ✓ Downloader already exists in $MODEL_DIR"
else
    # Try to find it in the repo
    if [[ -f "download_any_gguf.py" ]]; then
        cp "download_any_gguf.py" "$MODEL_DIR/download_any_gguf.py"
        echo "  ✓ Installed download_any_gguf.py to $MODEL_DIR"
    fi
fi

echo ""
echo "── Checking Dependencies ──"

# Check for python dependencies
if command -v python3 >/dev/null 2>&1; then
    echo "  ✓ python3 found"
    if python3 -c "import huggingface_hub" >/dev/null 2>&1; then
        echo "  ✓ huggingface_hub found"
    else
        echo "  ⚠ Warning: python3 'huggingface_hub' package not found."
        echo "    Recommended: pip install huggingface_hub tqdm"
    fi
else
    echo "  ⚠ Error: python3 not found. Downloader will not work."
fi

# Check for nvidia-smi
if command -v nvidia-smi >/dev/null 2>&1; then
    echo "  ✓ nvidia-smi found (GPU acceleration enabled)"
else
    echo "  ⚠ Warning: nvidia-smi not found. Script will fallback to CPU-only if no GPUs detected."
fi

# Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    echo ""
    echo "  ⚠ WARNING: $INSTALL_DIR is not in your PATH."
    echo "    Add this to your ~/.bashrc:"
    echo "    export PATH=\"$INSTALL_DIR:\$PATH\""
fi

echo ""
echo "Done! You can now run:"
echo "  llm-server <model.gguf>      # Smart Launcher"
echo "  llm-server-gui               # Model Selector (TUI)"
echo "  llm-server <repo> --download # Smart Downloader"
