# MCP Kali Server

## 🙏 Attribution

This project is based on the original work from [Wh0am123/MCP-Kali-Server](https://github.com/Wh0am123/MCP-Kali-Server). I've created this improved fork at [ViperBlackSkull/MCP-Kali-Server](https://github.com/ViperBlackSkull/MCP-Kali-Server) to add Docker support and enhance the documentation. I attempted to contribute these improvements back to the original repository through issues and requests, but unfortunately didn't receive a response from the original author.

**Key improvements in this fork:**
- 🐳 **Full Docker support** - Complete containerization with Docker Compose
- 📚 **Enhanced documentation** - Improved setup guides and clearer instructions
- 🛠️ **Better configuration tools** - Automated MCP client configuration scripts

---

**Kali MCP Server** is a lightweight API bridge that connects MCP Clients (e.g: Claude Desktop, [5ire](https://github.com/nanbingxyz/5ire)) to the API server which allows excuting commands on a Linux terminal.

This allows the MCP to run terminal commands like `nmap`, `nxc` or any other tool, interact with web applications using tools like `curl`, `wget`, `gobuster`. 
 And perform **AI-assisted penetration testing**, solving **CTF web challenge** in real time, helping in **solving machines from HTB or THM**.

## 🔍 Use Case

The goal is to enable AI-driven offensive security testing by:

- Letting the MCP interact with AI endpoints like OpenAI, Claude, DeepSeek, or any other models.
- Exposing an API to execute commands on a Kali machine.
- Using AI to suggest and run terminal commands to solve CTF challenges or automate recon/exploitation tasks.
- Allowing MCP apps to send custom requests (e.g., `curl`, `nmap`, `ffuf`, etc.) and receive structured outputs.

Here are some example for my testing (I used google's AI `gemini 2.0 flash`)

## Original Example from the Author

### Example solving my web CTF challenge in RamadanCTF
https://github.com/user-attachments/assets/dc93b71d-9a4a-4ad5-8079-2c26c04e5397

### Trying to solve machine "code" from HTB
https://github.com/user-attachments/assets/3ec06ff8-0bdf-4ad5-be71-2ec490b7ee27


---

## 🚀 Features

- 🧠 **AI Endpoint Integration**: Connect your kali to any MCP of your liking such as claude desktop or 5ier.
- 🖥️ **Command Execution API**: Exposes a controlled API to execute terminal commands on your Kali Linux machine.
- 🕸️ **Web Challenge Support**: AI can interact with websites and APIs, capture flags via `curl` and any other tool AI the needs.
- 🔐 **Designed for Offensive Security Professionals**: Ideal for red teamers, bug bounty hunters, or CTF players automating common tasks.

---

## 🛠️ Installation

### 🐳 Docker Installation (Recommended)

The easiest way to get started is using Docker:

```bash
git clone https://github.com/ViperBlackSkull/MCP-Kali-Server.git
cd MCP-Kali-Server

# Quick start with Docker Compose
docker-compose up -d
```


### 📦 Manual Installation

#### On your Linux Machine (Will act as MCP Server)
```bash
git clone https://github.com/ViperBlackSkull/MCP-Kali-Server.git
cd MCP-Kali-Server
pip3 install -r requirements.txt
python3 kali_server.py
```

### Example MCP Config file

```json
{
  "key": "Kali",
  "description": "Kali",
  "command": "python3",
  "args": [
    "/home/viper/Code/AI/self-hosted/kali/MCP-Kali-Server/mcp_server.py",
    "--server",
    "http://127.0.0.1:5000"
  ]
}

```


## 🔮 Other Possibilities

There are more possibilites than described since the AI model can now execute commands on the terminal. Here are some example:

- Memory forensics using Volatility
  - Automating memory analysis tasks such as process enumeration, DLL injection checks, and registry extraction from memory dumps.

- Disk forensics with SleuthKit
  - Automating analysis from disk images, timeline generation, file carving, and hash comparisons.


## ⚠️ Disclaimer:
This project is intended solely for educational and ethical testing purposes. Any misuse of the information or tools provided — including unauthorized access, exploitation, or malicious activity — is strictly prohibited.
The author assumes no responsibility for misuse.
