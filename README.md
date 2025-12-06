# ComfyUI Launcher 🚀

<div align="center">

```
  _______ _______ ___ ___ _______ ___ ___     ___     _______ ___ ___ ______  _______ ___ ___ 
 |   _   |   _   |   Y   |   _   |   Y   |   |   |   |   _   |   Y   |   _  \|   _   |   Y   |
 |.  1___|.  |   |.      |.  1___|   1   |   |.  |   |.  1   |.  |   |.  |   |.  1___|.  1   |
 |.  |___|.  |   |. \_/  |.  __)  \_   _/    |.  |___|.  _   |.  |   |.  |   |.  |___|.  _   |
 |:  1   |:  1   |:  |   |:  |     |:  |     |:  1   |:  |   |:  1   |:  |   |:  1   |:  |   |
 |::.. . |::.. . |::.|:. |::.|     |::.|     |::.. . |::.|:. |::.. . |::.|   |::.. . |::.|:. |
 `-------`-------`--- ---`---'     `---'     `-------`--- ---`-------`--- ---`-------`--- ---`
```

**A Linux Launcher & Management Script For ComfyUI**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.5.1-green.svg)](CHANGELOG.md)
[![Bash](https://img.shields.io/badge/bash-5.0+-orange.svg)](https://www.gnu.org/software/bash/)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Configuration](#%EF%B8%8F-configuration) • [Support](#-support)

</div>

---

## 🎯 What is This?

ComfyUI Launcher is a beautiful, feature-rich terminal interface for managing [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - the powerful node-based image generation GUI. It provides an intuitive menu system, making it easy to launch, update, and manage your ComfyUI installation.

### Why Use This Launcher?

- 🎨 **Beautiful UI** - Gorgeous terminal interface with animations and colors
- ⚡ **Fast Workflow** - Launch server, update repos, manage nodes in seconds
- 🔧 **Custom Nodes Manager** - Update, enable/disable, and delete custom nodes
- 🌐 **Built-in Tunnels** - Share your server with the web with Cloudflare or Pinggy tunnels
- 💾 **Config Persistence** - Remembers your settings across sessions
- 🚀 **CLI Support** - Automate tasks with command-line arguments
- ⚙️ **Settings Menu** - Configure browser, file manager, and auto-open options
- 🛡️ **Error Handling** - Graceful error handling and helpful messages

---

## ✨ Features

### Interactive Menu System
- **Launch ComfyUI** - Start server with custom arguments and real-time log monitoring
- **Update ComfyUI** - One-click updates via git pull
- **Manage Custom Nodes** - Comprehensive node management interface
- **Kill Server** - Safely stop running server by port detection
- **Edit Launch Arguments** - Interactive editor with comprehensive argument reference
- **Cloudflare Tunnel** - Expose server publicly with no time limit
- **Pinggy Tunnel** - Quick sharing with 60-minute free tier
- **Open Folder** - Launch file manager to ComfyUI or output directory
- **Settings Menu** - Configure application preferences
- **Set Paths** - Configure ComfyUI root and venv paths
- **Help System** - Comprehensive help with full color support

### Server Launch Features
- Real-time log display with scrolling output
- Interactive footer with keyboard controls:
  - **T** - Start Cloudflare tunnel
  - **P** - Start Pinggy tunnel
  - **K** - Kill server
  - **S** - Save logs to file
  - **M** - Return to menu (server keeps running)
  - **E** - Exit launcher (server keeps running)
- Auto-detect server URL and port
- Optional auto-open browser on server start
- Process ID (PID) display for monitoring

### Custom Nodes Manager
- Lists all installed custom nodes with rich metadata
- Displays node information from pyproject.toml:
  - Display name and project name
  - Version number
  - Description
  - Publisher ID
  - Repository URL
  - Icon (if available, displays with Kitty rendering or Ascii)
- **Update** individual nodes via git pull
- **Toggle** nodes on/off (.disabled extension)
- **Install Dependencies** from requirements.txt
- **Delete** nodes with confirmation
- Update all active nodes at once
- Update ComfyUI from nodes menu
- Graceful error handling for git operations
- Beautiful organized display with status indicators

### Tunnel Features
- **Cloudflare Tunnel** (Recommended):
  - No time limit
  - Fast and reliable
  - Auto-installs cloudflared on apt systems
  - Optional auto-open browser
- **Pinggy Tunnel**:
  - No installation needed (uses SSH)
  - 60-minute free tier
  - Good for quick sharing
- Interactive tunnel interface with:
  - Real-time log display
  - URL display when ready
  - **N** - Start new tunnel
  - **S** - Save tunnel logs
  - **M** - Return to menu
  - **Q** - Quit
- Automatic port detection from launch args
- Server status check before starting

### Settings Menu
- **System Information Display**:
  - CPU model
  - GPU detection (NVIDIA/AMD)
  - Hostname and IP address
  - RAM usage (used/total)
- **ComfyUI Information**:
  - Custom nodes count
  - Python version
  - Venv path
- **Application Settings**:
  - Web browser selection
  - File manager selection (auto/nemo/dolphin/nautilus/custom)
  - Auto-open browser on server start (toggle)
  - Auto-open browser on tunnel start (toggle)

### Command-Line Interface
```bash
comfy_launch.sh                # Interactive menu (default)
comfy_launch.sh start          # Launch server immediately
comfy_launch.sh update         # Update ComfyUI
comfy_launch.sh nodes          # Manage custom nodes (interactive)
comfy_launch.sh update-nodes   # Update all nodes at once
comfy_launch.sh kill           # Stop running server
comfy_launch.sh tunnel cf      # Start Cloudflare tunnel
comfy_launch.sh tunnel pinggy  # Start Pinggy tunnel
comfy_launch.sh path [/dir]    # Set ComfyUI path
comfy_launch.sh venv [/dir]    # Set venv path
comfy_launch.sh folder         # Open ComfyUI folder
comfy_launch.sh settings       # Open settings menu
comfy_launch.sh help           # Show comprehensive help
```

## 📦 Installation

### Prerequisites

**Required:**
- Bash 5.0+
- Git
- Python 3.8+
- ComfyUI installed with venv

**Optional:**
- `cloudflared` - For Cloudflare tunnels (auto-installed on apt systems)
- `lsof` - For better port detection (usually pre-installed)
- File manager: `nemo`, `dolphin`, `nautilus`, or custom

### Quick Install

1. **Download the script:**
```bash
wget https://raw.githubusercontent.com/CLOUDWERX-DEV/comfy_launch/master/comfy_launch.sh
chmod +x comfy_launch.sh
```

2. **(Optional) Install globally:**
```bash
sudo mv comfy_launch.sh /usr/local/bin/comfy_launch
```

3. **Run it:**
```bash
./comfy_launch.sh
# or if installed globally:
comfy_launch
```

### First-Time Setup

1. Launch the script
2. Select option **9** to set your ComfyUI path
3. Enter the **root folder** containing the `ComfyUI/` directory

**Important:** The path can be your ComfyUI folder or the parent containing that folder.

---

## 🚀 Usage

### Interactive Mode

Simply run the script without arguments:
```bash
./comfy_launch.sh
```

You'll see a beautiful menu with all options:
- **1** - 🚀 Launch ComfyUI (with interactive controls)
- **2** - 🔄 Update ComfyUI
- **3** - 📦 Manage Custom Nodes
- **4** - ⏹  Kill Server (if running)
- **5** - ✏️  Edit Launch Args
- **6** - ☁️  Cloudflare Tunnel
- **7** - 🌐 Pinggy Tunnel (60min free)
- **8** - 📁 Open Folder
- **O** - 📸 Open Output Folder
- **9** - ⚙️  Set ComfyUI Path
- **V** - 🐍 Set Venv Path
- **S** - ⚙️  Settings
- **H** - ❓ Help & Links
- **0** - 👋 Exit (with cool animation!)

### Server Launch

When you launch the server (option 1), you get:
- Real-time log display with scrolling
- Interactive footer with controls
- Auto-detection of server URL
- Optional auto-open browser
- Process monitoring

**Keyboard Controls:**
- **T** - Start Cloudflare tunnel (while server running)
- **P** - Start Pinggy tunnel (while server running)
- **K** - Kill server and exit
- **S** - Save logs to timestamped file
- **M** - Return to menu (server keeps running)
- **E** - Exit launcher (server keeps running)

### Custom Nodes Management

Access via menu option **3** or `./comfy_launch.sh nodes`

**Features:**
- View all installed nodes with metadata
- See version, description, and repository info
- Update individual nodes by number
- **A** - Update all active nodes
- **U** - Update ComfyUI
- **0** - Back to main menu

**Per-Node Actions:**
- **U** - Update node (git pull)
- **T** - Toggle on/off (enable/disable)
- **I** - Install dependencies (requirements.txt)
- **D** - Delete node (with confirmation)

### Launch Arguments Editor

Edit via menu option **5** for comprehensive argument reference.

**Network:**
- `--listen 0.0.0.0` - Listen on all interfaces (default: 127.0.0.1)
- `--port 8188` - Set port number (default: 8188)
- `--enable-cors-header` - Enable CORS for API access

**VRAM Modes** (mutually exclusive):
- `--gpu-only` - Keep everything on GPU (fastest, needs most VRAM)
- `--highvram` - Keep models in GPU (24GB+ VRAM)
- `--normalvram` - Normal VRAM usage (8-16GB VRAM)
- `--lowvram` - Split unet for less VRAM (4-6GB VRAM)
- `--novram` - Minimal VRAM mode (2-4GB VRAM)
- `--cpu` - CPU only mode (slow, no GPU needed)

**Attention** (mutually exclusive):
- `--use-split-cross-attention` - Split cross attention (saves VRAM)
- `--use-quad-cross-attention` - Sub-quadratic attention (recommended, balanced)
- `--use-pytorch-cross-attention` - PyTorch 2.0 attention (fast, needs VRAM)
- `--use-sage-attention` - Sage attention (experimental)
- `--use-flash-attention` - Flash attention (fastest, needs compatible GPU)

**Precision - UNet** (mutually exclusive):
- `--fp16-unet` - FP16 diffusion model (faster, less VRAM)
- `--bf16-unet` - BF16 diffusion model (better quality)
- `--fp8_e4m3fn-unet` - FP8 E4M3FN weights (experimental, saves VRAM)
- `--fp8_e5m2-unet` - FP8 E5M2 weights (experimental)

**Precision - VAE** (mutually exclusive):
- `--fp16-vae` - FP16 VAE (faster, may cause black images)
- `--fp32-vae` - FP32 VAE (full precision, default)
- `--bf16-vae` - BF16 VAE (balanced)
- `--cpu-vae` - Run VAE on CPU (saves VRAM)

**Precision - Text Encoder** (mutually exclusive):
- `--fp8_e4m3fn-text-enc` - FP8 E4M3FN text encoder
- `--fp8_e5m2-text-enc` - FP8 E5M2 text encoder
- `--fp16-text-enc` - FP16 text encoder

**Memory Management:**
- `--cuda-malloc` - Enable cudaMallocAsync (better memory handling)
- `--disable-smart-memory` - Aggressive RAM offload (saves VRAM)
- `--reserve-vram 2` - Reserve VRAM in GB for OS/other apps

**Cache** (mutually exclusive):
- `--cache-classic` - Aggressive caching (faster repeated gens)
- `--cache-lru 10` - LRU cache with N results

**Other Options:**
- `--preview-method auto` - Preview method: auto/latent2rgb/taesd/none
- `--auto-launch` - Open browser automatically
- `--multi-user` - Enable per-user storage
- `--verbose DEBUG` - Set logging level (DEBUG/INFO/WARNING/ERROR)

**Example:**
```bash
--listen 0.0.0.0 --port 6057 --highvram --fp16-vae --cuda-malloc
```

### Tunnels

Share your ComfyUI instance publicly (server must be running first):

**Cloudflare Tunnel** (Recommended):
```bash
./comfy_launch.sh tunnel cf
```
- No time limit
- Fast and reliable
- Auto-installs cloudflared on apt systems
- Optional auto-open browser

**Pinggy Tunnel**:
```bash
./comfy_launch.sh tunnel pinggy
```
- No installation needed (uses SSH)
- Free tier: 60 minutes
- Good for quick sharing

**Interactive Controls:**
- **N** - Start new tunnel
- **S** - Save tunnel logs to file
- **M** - Return to menu (tunnel stops)
- **Q** - Quit launcher (tunnel stops)

### Settings Menu

Access via menu option **S** or `./comfy_launch.sh settings`

**Configure:**
1. **Web Browser** - Set browser command (e.g., google-chrome, firefox, chromium)
2. **File Manager** - Choose auto-detect, nemo, dolphin, nautilus, or custom
3. **Auto-open Browser (Server)** - Toggle browser opening on server start
4. **Auto-open Browser (Tunnel)** - Toggle browser opening on tunnel start

**View System Info:**
- CPU model
- GPU (NVIDIA/AMD detection)
- Hostname and IP address
- RAM usage
- Custom nodes count
- Python version
- Venv path

---

## ⚙️ Configuration

Config is stored in `~/.config/comfy_launch/config.sh`

**Manually edit:**
```bash
nano ~/.config/comfy_launch/config.sh
```

**Example config:**
```bash
COMFY_PATH="/home/user/Desktop/Servers/comfy"
VENV_PATH="/home/user/Desktop/Servers/comfy/venv"
LAUNCH_ARGS="--listen 0.0.0.0 --port 6057 --highvram --fp16-vae"
BROWSER="google-chrome"
FILE_MANAGER="auto"
AUTO_OPEN_BROWSER_SERVER="true"
AUTO_OPEN_BROWSER_TUNNEL="false"
```

### Path Configuration

**ComfyUI Path:**
- The root folder containing your `ComfyUI/` directory
- Example: `/home/user/comfy` (contains `ComfyUI/` and `venv/`)
- Auto-detects if you select the ComfyUI folder itself

**Virtual Environment (venv):**
- Python isolated environment for ComfyUI
- Default location: `COMFY_PATH/venv`
- Can be customized to any location
- Contains all Python packages and dependencies

---

## 🐛 Troubleshooting

### Port Already in Use
```bash
./comfy_launch.sh kill
# or manually:
lsof -ti:PORT | xargs kill
```

### No venv Found
Create one:
```bash
cd ComfyUI && python -m venv venv
```
Then install:
```bash
source venv/bin/activate && pip install -r requirements.txt
```

### Server Won't Start
- Check if Python/venv is correct
- Verify path exists: `COMFY_PATH/ComfyUI`
- Check logs in: `/tmp/comfy_launch_output.log`
- Verify dependencies: `pip install -r requirements.txt`

### Tunnel Not Working
- Ensure server is running first (option 1)
- For Cloudflare: Install cloudflared (auto-installed on apt systems)
- For Pinggy: Requires ssh (usually pre-installed)
- Check firewall settings

### Browser Not Opening
- Check Settings menu (option S)
- Verify browser command is correct
- Toggle auto-open settings if needed
- Test browser command manually

### Custom Node Won't Update
- Node might have local changes
- Go to node folder and run: `git status`
- Reset if needed: `git reset --hard && git pull`
- Check for merge conflicts

### How to Change Port
- Edit Launch Args (option 5)
- Add or modify: `--port YOUR_PORT`
- Restart server for changes to take effect

### Out of VRAM Errors
- Edit Launch Args (option 5)
- Try: `--lowvram` or `--novram` or `--cpu`
- Consider: `--fp16-vae` or `--fp16-unet`
- Use: `--disable-smart-memory` for aggressive offload

```

### Custom Venv Location
If your venv is elsewhere:
```bash
./comfy_launch.sh venv /path/to/your/venv
```

### Cloudflared Installation
```bash
# Ubuntu/Debian
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloudflare-main.gpg
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/ focal main' | sudo tee /etc/apt/sources.list.d/cloudflare-main.list
sudo apt update && sudo apt install cloudflared
```

---

## 🔗 Resources

### ComfyUI
- 📖 [Official Examples](https://comfyanonymous.github.io/ComfyUI_examples/) - Workflows and guides
- 📚 [Documentation](https://docs.comfy.org) - Official docs
- 🐙 [GitHub](https://github.com/comfyanonymous/ComfyUI) - Source code
- 🤗 [Hugging Face](https://huggingface.co/Comfy-Org) - Official models
- 🎨 [CivitAI](https://civitai.com) - Community models and LoRAs

### This Launcher
- 💻 [GitHub](https://github.com/CLOUDWERX-DEV/comfy_launch) - Source code & issues
- 🏠 [Homepage](https://cloudwerx.dev) - Blog and projects
- 💬 [Discord](https://discord.gg/EQSBU5aK) - Get help and chat
- ☕ [Buy Me A Coffee](https://buymeacoffee.com/cloudwerxl3) - Support development
- 📧 [Email](mailto:mail@cloudwerx.dev) - Contact

---

## 💖 Support

If you find this launcher useful:

- ⭐ Star the repo on GitHub
- ☕ [Buy me a coffee](https://buymeacoffee.com/cloudwerxl3)
- 💬 Join the [Discord server](https://discord.gg/EQSBU5aK)
- 🐛 [Report bugs](https://github.com/CLOUDWERX-DEV/comfy_launch/issues)
- 🎉 Share with friends!

---

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

**Created by:** [CLOUDWERX LAB](https://cloudwerx.dev)  
**ComfyUI by:** [comfyanonymous](https://github.com/comfyanonymous)

---

<div align="center">

**⚡CLOUDWERX LAB̷ » Digital Food for the Analog Soul**

[cloudwerx.dev](https://cloudwerx.dev) | [GitHub](https://github.com/CLOUDWERX-DEV) | [Discord](https://discord.gg/EQSBU5aK)

</div>
