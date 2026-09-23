#!/usr/bin/env bash

set -e

echo "[*] Updating system..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    sudo apt update
    PKG_INSTALL="sudo apt install -y"
    DOCKER_PACKAGE="docker.io"
elif command -v dnf >/dev/null 2>&1; then
    PKG_INSTALL="sudo dnf install -y"
    DOCKER_PACKAGE="docker"
elif command -v pacman >/dev/null 2>&1; then
    PKG_INSTALL="sudo pacman -Sy --noconfirm"
    DOCKER_PACKAGE="docker"
else
    echo "[!] Unsupported package manager. Install dependencies manually."
    exit 1
fi

echo "[*] Installing dependencies..."
$PKG_INSTALL git python3 python3-pip golang tor torsocks curl

if ! command -v docker >/dev/null 2>&1; then
    echo "[*] Docker not found. Installing Docker..."
    $PKG_INSTALL "$DOCKER_PACKAGE"
fi

if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable docker || true
    sudo systemctl start docker || true
fi

python3 -m pip install --upgrade pip

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

# 5. OnionScan
if [ ! -d "onionscan" ]; then
    git clone https://github.com/s-rah/onionscan.git onionscan
    cd onionscan
    go build -o onionscan .
    sudo install -m 0755 onionscan /usr/local/bin/onionscan
    cd ..
fi

# 6. Scrapy
pip3 install scrapy

# 7. gallery-dl
pip3 install gallery-dl

# 8. Docker Onion Nmap
echo "[*] Pulling Docker Onion Nmap image..."
sudo docker pull milesrichardson/onion-nmap:latest

# 9. Robin
# AI-powered Dark Web OSINT tool. The image is pulled here; Robin requires
# Tor and an API key/configuration when it is actually run.
echo "[*] Pulling Robin Docker image..."
sudo docker pull apurvsg/robin:latest

echo "[*] Starting Tor service..."
sudo systemctl enable tor || true
sudo systemctl start tor || true

echo ""
echo "[✓] Installation complete!"
echo "Tools installed in: $WORKDIR"
echo ""
echo "Docker images installed:"
echo "  - milesrichardson/onion-nmap:latest"
echo "  - apurvsg/robin:latest"
echo ""
echo "Tip: Use 'torsocks <tool>' to route traffic through Tor"
echo "Tip: Onion Nmap example:"
echo "  sudo docker run --rm -it milesrichardson/onion-nmap -p 80,443 example.onion"
echo "Tip: Robin example:"
echo "  sudo docker run --rm -v \"\$(pwd)/.env:/app/.env\" --add-host=host.docker.internal:host-gateway -p 8501:8501 apurvsg/robin:latest"
