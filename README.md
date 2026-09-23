# TORSINT Toolkit

A simple bash installer for setting up a Tor-based OSINT environment. Credits to all the people who made these awesome tools.

## 📦 Tools

This script installs the following tools:

### 🔐 Tor Routing
- **Tor** – anonymizing network
- **torsocks** – forces supported apps through Tor
- **Kalitorify** – routes system traffic through Tor

### 🕵️ OSINT / Crawlers
- **TorCrawl** – dark web crawler
- **OnionSearch** – search engine scraper for `.onion` sites
- **TorBot** – OSINT tool for onion domains
- **OnionScan** – free and open-source tool for investigating the Dark Web
- **Scrapy** – web scraping framework
- **gallery-dl** – media scraper/downloader
- **Robin** – AI-powered Dark Web OSINT investigation tool

### 🔎 Onion Recon / Network Analysis
- **Onion Nmap** – Dockerized Nmap environment for scanning `.onion` services through Tor and proxychains
- **Nmap** – network scanner included inside the Onion Nmap container
- **proxychains** – used inside the Onion Nmap container to route supported traffic through Tor
- **dnsmasq** – used inside the Onion Nmap container for Tor DNS resolution

### 🐳 Docker-Based Tools
- **docker-onion-nmap** – Docker image containing Tor, dnsmasq, proxychains and Nmap for `.onion` service testing
- **Robin** – Dockerized AI-powered Dark Web OSINT environment

> **Note:** Docker-based tools are pulled as container images by `install_torsint.sh`. They are not copied into the TORSINT workspace as normal source repositories.

## ⚙️ Installation

```bash
git clone https://github.com/ehA33ADxsk9w/torsint-tools.git
cd torsint-tools
chmod +x install_torsint.sh
./install_torsint.sh
```

Or use curl:

```bash
curl -fsSL https://raw.githubusercontent.com/ehA33ADxsk9w/torsint-tools/refs/heads/main/install_torsint.sh | sudo bash
```

## 🐳 Docker Usage

### Onion Nmap

The installer pulls:

```bash
milesrichardson/onion-nmap:latest
```

Example:

```bash
sudo docker run --rm -it milesrichardson/onion-nmap -p 80,443 example.onion
```

The container starts Tor and dnsmasq and uses proxychains to route Nmap through Tor. The upstream project notes that UDP scanning is not available over Tor and that Tor can take some time to bootstrap. citeturn0view0

### Robin

The installer pulls:

```bash
apurvsg/robin:latest
```

Example:

```bash
sudo docker run --rm \
  -v "$(pwd)/.env:/app/.env" \
  --add-host=host.docker.internal:host-gateway \
  -p 8501:8501 \
  apurvsg/robin:latest
```

Then open:

```text
http://localhost:8501
```

Robin requires Tor and an API key/configuration for supported LLM providers when using those providers. The upstream project documents support for OpenAI, Anthropic, Google, Mistral, OpenRouter, Ollama and OpenAI-compatible APIs. citeturn0view1

## ⚠️ Legal / Responsible Use

Use these tools only for systems, services and investigations you are authorized to access. Dark Web content and network scanning can have legal and operational consequences depending on the target and jurisdiction.
