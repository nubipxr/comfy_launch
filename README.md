# ComfyUI Launcher 🚀

<div align="center">

```
  _______ _______ ___ ___ _______ ___ ___     ___     _______ ___ ___ ______  _______ ___ ___ _______ _______ 
 |   _   |   _   |   Y   |   _   |   Y   |   |   |   |   _   |   Y   |   _  \|   _   |   Y   |   _   |   _   \
 |.  1___|.  |   |.      |.  1___|   1   |   |.  |   |.  1   |.  |   |.  |   |.  1___|.  1   |.  1___|.  l   /
 |.  |___|.  |   |. \_/  |.  __)  \_   _/    |.  |___|.  _   |.  |   |.  |   |.  |___|.  _   |.  __)_|.  _   1
 |:  1   |:  1   |:  |   |:  |     |:  |     |:  1   |:  |   |:  1   |:  |   |:  1   |:  |   |:  1   |:  |   |
 |::.. . |::.. . |::.|:. |::.|     |::.|     |::.. . |::.|:. |::.. . |::.|   |::.. . |::.|:. |::.. . |::.|:. |
 `-------`-------`--- ---`---'     `---'     `-------`--- ---`-------`--- ---`-------`--- ---`-------`--- ---'
```

**A BadAss Launcher Script For ComfyUI**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.1.0-green.svg)](CHANGELOG.md)
[![Bash](https://img.shields.io/badge/bash-5.0+-orange.svg)](https://www.gnu.org/software/bash/)

[Features](#features) • [Installation](#installation) • [Usage](#usage) • [Support](#support)

</div>

---

## 🎯 What is This?

ComfyUI Launcher is a beautiful, feature-rich terminal interface for managing [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - the powerful node-based Stable Diffusion GUI. It provides an intuitive menu system with Tokyo Night/Catppuccin theming, making it easy to launch, update, and manage your ComfyUI installation.

### Why Use This Launcher?

- 🎨 **Beautiful UI** - Gorgeous terminal interface with animations and colors
- ⚡ **Fast Workflow** - Launch server, update repos, manage nodes in seconds
- 🔧 **Custom Nodes Manager** - Update and manage all your custom nodes easily
- 🌐 **Built-in Tunnels** - Share your work with Cloudflare or Pinggy tunnels
- 💾 **Config Persistence** - Remembers your settings across sessions
- 🚀 **CLI Support** - Automate tasks with command-line arguments
- 🛡️ **Error Handling** - Graceful error handling and helpful messages

---

## ✨ Features

### Interactive Menu
- Launch ComfyUI with custom arguments
- Update ComfyUI and Manager with one click
- Manage custom nodes (update individually or all at once)
- Kill running server safely
- Edit launch arguments with helpful reference
- Start Cloudflare or Pinggy tunnels
- Open ComfyUI folder in file manager
- Comprehensive help system

### Custom Nodes Manager
- Lists all installed custom nodes
- Shows node name, version, and description (from pyproject.toml)
- Update individual nodes or all at once
- Handles git errors gracefully
- Beautiful, organized display

### Command-Line Interface
```bash
comfy_launch.sh start          # Launch server immediately
comfy_launch.sh update         # Update ComfyUI
comfy_launch.sh nodes          # Manage custom nodes
comfy_launch.sh update-nodes   # Update all nodes
comfy_launch.sh kill           # Stop server
comfy_launch.sh tunnel cf      # Cloudflare tunnel
comfy_launch.sh tunnel pinggy  # Pinggy tunnel
comfy_launch.sh path /dir      # Set ComfyUI path
comfy_launch.sh venv /dir      # Set venv path
comfy_launch.sh folder         # Open folder
comfy_launch.sh help           # Show help
```

### Visual Design
- Tokyo Night / Catppuccin color scheme
- Animated ASCII art on startup and exit
- Rounded box borders
- Terminal-safe icons and glyphs
- Smooth animations and transitions

---

## 📦 Installation

### Prerequisites

**Required:**
- Bash 5.0+
- Git
- Python 3.8+
- ComfyUI installed with venv

**Optional:**
- `cloudflared` - For Cloudflare tunnels
- `lsof` - For better port detection (usually pre-installed)
- File manager: `nemo`, `dolphin`, or `nautilus`

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

**Important:** The path should be the parent folder, not the ComfyUI folder itself.

**Example:**
```
✅ Correct:   /home/user/Desktop/Servers/comfy
❌ Incorrect: /home/user/Desktop/Servers/comfy/ComfyUI
```

Your folder structure should look like:
```
/home/user/Desktop/Servers/comfy/
├── ComfyUI/           # The actual ComfyUI installation
│   ├── main.py
│   ├── custom_nodes/
│   └── ...
└── venv/              # Python virtual environment
```

---

## 🚀 Usage

### Interactive Mode

Simply run the script without arguments:
```bash
./comfy_launch.sh
```

You'll see a beautiful menu with all options:
- **1** - Launch ComfyUI server
- **2** - Update ComfyUI
- **3** - Manage custom nodes
- **4** - Kill running server
- **5** - Edit launch arguments
- **6** - Start Cloudflare tunnel
- **7** - Start Pinggy tunnel
- **8** - Open folder in file manager
- **9** - Set ComfyUI path
- **V** - Set custom venv path
- **H** - Help & links
- **0** - Exit (with cool animation!)

### Command-Line Mode

For automation or quick tasks:

```bash
# Start server immediately
./comfy_launch.sh start

# Update everything
./comfy_launch.sh update
./comfy_launch.sh update-nodes

# Manage custom nodes interactively
./comfy_launch.sh nodes

# Start a tunnel (server must be running)
./comfy_launch.sh tunnel cf

# Configure paths
./comfy_launch.sh path /home/user/comfy
./comfy_launch.sh venv /home/user/comfy/my_venv
```

### Custom Nodes Manager

Access via menu option **3** or `./comfy_launch.sh nodes`

Features:
- Lists all installed custom nodes with metadata
- Shows version and description from pyproject.toml
- Update individual nodes by number
- Update all nodes with option **A**
- Update ComfyUI with option **U**
- Handles errors gracefully (no crashes!)

### Launch Arguments

Edit via menu option **5** or directly in config file.

Common arguments:
- `--listen 0.0.0.0` - Listen on all interfaces (for remote access)
- `--port 6057` - Set port number
- `--highvram` - High VRAM mode (24GB+)
- `--normalvram` - Normal VRAM mode (8-16GB)
- `--lowvram` - Low VRAM mode (4-6GB)
- `--novram` - CPU mode (no GPU)
- `--use-quad-cross-attention` - Faster attention
- `--cuda-malloc` - Better CUDA memory management
- `--fp16-vae` - Use FP16 for VAE (faster, less VRAM)
- `--preview-method auto` - Preview method (auto/latent2rgb/taesd)

**Example:**
```
--listen 0.0.0.0 --port 6057 --highvram --fp16-vae
```

### Tunnels

Share your ComfyUI instance publicly:

**Cloudflare Tunnel** (Recommended):
- No time limit
- Fast and reliable
- Requires `cloudflared` installation

**Pinggy Tunnel**:
- No installation needed (uses SSH)
- Free tier: 60 minutes
- Good for quick sharing

Both tunnels require the server to be running first.

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
```

---

## 🐛 Troubleshooting

### Port Already in Use
```bash
./comfy_launch.sh kill
```

### Server Won't Start
- Check if venv exists: `ls $COMFY_PATH/venv`
- Verify Python: `$COMFY_PATH/venv/bin/python --version`
- Check ComfyUI: `ls $COMFY_PATH/ComfyUI/main.py`

### Path Issues
Make sure you're setting the **root folder**, not the ComfyUI folder itself:
```bash
# Correct structure:
/your/path/
├── ComfyUI/
└── venv/
```

### Custom Venv Location
If your venv is elsewhere:
```bash
./comfy_launch.sh venv /path/to/your/venv
```

### Cloudflared Not Found
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

**⚡ C̷L̷O̷U̷D̷W̷E̷R̷X̷ ̷L̷A̷B̷ » Digital Food for the Analog Soul**

[cloudwerx.dev](https://cloudwerx.dev) | [GitHub](https://github.com/CLOUDWERX-DEV) | [Discord](https://discord.gg/EQSBU5aK)

</div>
