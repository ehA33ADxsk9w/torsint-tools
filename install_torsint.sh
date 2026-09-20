#!/usr/bin/env bash

set -e

echo "[*] Updating system..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    PKG_INSTALL="sudo apt update && sudo apt install -y"
elif command -v dnf >/dev/null 2>&1; then
    PKG_INSTALL="sudo dnf install -y"
elif command -v pacman >/dev/null 2>&1; then
    PKG_INSTALL="sudo pacman -Sy --noconfirm"
else
    echo "[!] Unsupported package manager. Install dependencies manually."
    exit 1
fi

# Install core dependencies
echo "[*] Installing dependencies..."
$PKG_INSTALL git python3 python3-pip tor torsocks curl

# Ensure pip is updated
python3 -m pip install --upgrade pip

# Create workspace
WORKDIR="$HOME/torsint-tools"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[*] Installing tools into $WORKDIR..."

# 1. Kalitorify
if [ ! -d "kalitorify" ]; then
    git clone https://github.com/brainfucksec/kalitorify.git
    cd kalitorify
    sudo make install
    cd ..
fi

# 2. TorCrawl
if [ ! -d "torcrawl" ]; then
    git clone https://github.com/MikeMeliz/TorCrawl.git torcrawl
    cd torcrawl
    pip3 install -r requirements.txt
    cd ..
fi

# 3. OnionSearch
pip3 install onionsearch

# 4. TorBot
if [ ! -d "torbot" ]; then
    git clone https://github.com/DedSecInside/TorBot.git torbot
    cd torbot
    pip3 install -r requirements.txt
    cd ..
fi

#5 OnionScan
if [ ! -d "OnionScan" ]; then
    git clone https://github.com/s-rah/onionscan.git
    cd onionscan
    go build -o onionscan .

# 6. Scrapy
pip3 install scrapy

# 7. gallery-dl
pip3 install gallery-dl

# Enable and start Tor service
echo "[*] Starting Tor service..."
sudo systemctl enable tor || true
sudo systemctl start tor || true

echo ""
echo "[✓] Installation complete!"
echo "Tools installed in: $WORKDIR"
echo ""
echo "Tip: Use 'torsocks <tool>' to route traffic through Tor"
