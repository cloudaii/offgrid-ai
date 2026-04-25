
#!/data/data/com.termux/files/usr/bin/bash

# --- UNLOCKED: OFF-GRID AI NODE INSTALLER ---
# Target: Android (Termux) | 2026 Edition
# Features: Ollama-Vulkan, Kiwix-RAG, PicoClaw Agent

echo -e "\e[34m[+] Starting Unlocked AI Node Installation...\e[0m"

# 1. Update and Base Dependencies
pkg update && pkg upgrade -y
pkg install -y python rust binutils libzim git wget clang make golang termux-api

# 2. Install GPU-Accelerated Ollama (Vulkan)
echo -e "\e[32m[+] Installing Ollama with Vulkan Support...\e[0m"
pkg install -y ollama-backend-vulkan
# Start Ollama in background so we can pull models
ollama serve > /dev/null 2>&1 &
sleep 5
ollama pull qwen2.5:0.5b # Smallest for testing, swap to 1.5b/3b later

# 3. Setup Python RAG Bridge for Kiwix
echo -e "\e[32m[+] Setting up Offline Knowledge Bridge...\e[0m"
pip install --upgrade pip
pip install llm llm-ollama llm-tools-kiwix --break-system-packages

# 4. Install PicoClaw Agent
echo -e "\e[32m[+] Compiling PicoClaw Agent (ARM64 Native)...\e[0m"
git clone https://github.com/sipeed/picoclaw.git
cd picoclaw
export GOTOOLCHAIN=local
make deps && make build
mv picoclaw ../ # Move binary to root for easier access
cd ..

# 5. Final Configuration
termux-setup-storage
mkdir -p ~/.picoclaw/workspace
./picoclaw onboard

echo -e "\e[34m------------------------------------------\e[0m"
echo -e "\e[93mINSTALLATION COMPLETE\e[0m"
echo -e "1. Place your .zim files in /sdcard/Download"
echo -e "2. Run: export KIWIX_HOME=/sdcard/Download"
echo -e "3. Ask: llm -m qwen2.5:0.5b --tool kiwix 'your question'"
echo -e "\e[34m------------------------------------------\e[0m"
