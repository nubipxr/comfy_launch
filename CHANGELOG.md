# Changelog

All notable changes to ComfyUI Launcher will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-12-06

### Added
- Comprehensive launch arguments editor with all ComfyUI options organized by category
  - Network options (listen, port, CORS)
  - VRAM modes (gpu-only, highvram, normalvram, lowvram, novram, cpu)
  - Attention methods (split, quad, pytorch, sage, flash)
  - Precision settings for UNET, VAE, and text encoders
  - Memory management options
  - Cache strategies
  - Preview methods
  - Other options (auto-launch, multi-user, verbose logging)
- Error detection for missing dependencies with fix instructions
- Help text in custom nodes manager explaining how to use the interface
- Clarification text for venv option (Python virtual environment)

### Changed
- Custom nodes now display full descriptions with word wrapping
- Node names displayed in yellow for better visibility
- Added bullet points (•) before each node name
- Improved description formatting with proper indentation
- ASCII header tagline now right-aligned under the art
- Box borders now use open sides (no right border) for cleaner look
- Top-right corner of boxes uses ╴ instead of ─╮

### Fixed
- Removed escape code artifacts from ASCII header
- Fixed literal `\n` in node descriptions being displayed incorrectly
- Filtered out `__pycache__` folder from custom nodes list
- Fixed ANSI color codes showing in ASCII art
- Server launch now captures errors and suggests dependency fixes

## [1.1.0] - 2025-12-06

### Added
- **New ASCII Art Header** - Replaced old ASCII with new gradient animated header
- **Custom Nodes Manager** - Full-featured manager for updating custom nodes
  - Lists all installed nodes with metadata from pyproject.toml
  - Shows name, version, and description for each node
  - Update individual nodes or all at once
  - Handles git errors gracefully
  - Beautiful organized display with Tokyo Night theme
- **Custom Venv Support** - Option to set custom virtual environment path
- **Exit Animation** - Beautiful animated ASCII art when exiting
- **Enhanced Launch Args Editor** - Shows all available ComfyUI arguments with descriptions
- **CLI Arguments for Nodes** - `comfy_launch.sh nodes` and `comfy_launch.sh update-nodes`
- **Expanded Help Menu** - Added donate link, Discord server, and email contact
- **Link Descriptions** - All help links now have descriptions explaining what's on each site

### Changed
- **Rounded Box Borders** - Switched from double-line to rounded corner boxes (╭─╮ style)
- **Removed Boxes** - Removed box around CLOUDWERX LAB branding line for cleaner look
- **Removed Box** - Removed box around top ASCII art
- **Improved Status Detection** - Fixed server status always showing as RUNNING
  - Now uses `lsof` for accurate port detection
  - Shows correct PID when server is running
  - Shows STOPPED when no server detected
- **Better Color Scheme** - Enhanced Tokyo Night/Catppuccin colors throughout
- **Animated Header** - ASCII art now scrolls in with animation on startup
- **Menu Enhancements** - More colorful menu with better visual hierarchy

### Fixed
- **Server Launch Detection** - Fixed issue where server couldn't be launched due to false "already running" status
- **Tunnel Validation** - Cloudflare and Pinggy tunnels now properly check if server is running
- **Folder Option** - Open folder option now disabled if no valid path is set
- **Path Validation** - Better validation of ComfyUI path structure
- **Error Handling** - Improved error handling in custom nodes manager

### Documentation
- **Comprehensive README** - Complete rewrite with detailed installation and usage instructions
- **Path Setup Guide** - Clear explanation of correct folder structure
- **Troubleshooting Section** - Expanded troubleshooting with common issues
- **Support Links** - Added donate, Discord, and email contact information

### Technical
- Switched from `ss` to `lsof` for more reliable port detection
- Added pyproject.toml parsing for custom node metadata
- Improved git error handling in update functions
- Better string truncation for long descriptions
- Enhanced animation timing and visual effects

## [1.0.0] - 2025-12-06

### Added
- Initial release of ComfyUI Launcher
- Interactive menu system with beautiful terminal UI
- Command-line argument support for direct operations
  - `comfy_launch.sh start` - Launch server directly
  - `comfy_launch.sh update` - Update ComfyUI and Manager
  - `comfy_launch.sh kill` - Stop running server
  - `comfy_launch.sh tunnel [cf|pinggy]` - Start tunnels
  - `comfy_launch.sh path /dir` - Set ComfyUI path
  - `comfy_launch.sh folder` - Open folder in file manager
  - `comfy_launch.sh help` - Show help and links
- Auto-detection of ComfyUI installation path
- Server status monitoring (running/stopped with PID)
- Graceful server shutdown with Ctrl+C
- Git repository update functionality for ComfyUI and Manager
- Cloudflare tunnel support with URL detection
- Pinggy tunnel support (60min free tier)
- Configurable launch arguments
- File manager integration (Nemo/Dolphin/Nautilus)
- Comprehensive help system with resource links
- Configuration persistence in ~/.config/comfy_launch/
- Tokyo Night / Catppuccin color theme
- Terminal-safe icons and glyphs
- Proper ANSI color rendering

### Fixed
- ANSI escape codes now render properly instead of showing literally
- Menu layout and spacing optimized for 86-character width
- Color codes properly interpreted with `echo -e`

### Technical
- Bash script with proper error handling
- Port detection using `ss` command
- Process management with PID tracking
- Config file storage in XDG-compliant location
- Support for Arch, Debian, Ubuntu, Mint, and Fedora

### Resources
- Homepage: https://cloudwerx.dev
- GitHub: https://github.com/CLOUDWERX-DEV/comfy_launch
- ComfyUI Examples: https://comfyanonymous.github.io/ComfyUI_examples/
- ComfyUI Docs: https://docs.comfy.org
- ComfyUI GitHub: https://github.com/comfyanonymous/ComfyUI
- Hugging Face: https://huggingface.co/Comfy-Org
- Models: https://civitai.com
