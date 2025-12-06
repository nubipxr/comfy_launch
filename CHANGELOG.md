# Changelog

All notable changes to ComfyUI Launcher will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2025-12-06

### Added
- Comprehensive Settings menu with system configuration options
- Browser selection setting (default: google-chrome)
- File manager selection setting (nemo/dolphin/nautilus)
- Auto-open browser toggle for server and tunnel startup
- System information display (GPU, CPU, hostname, IP, RAM)
- ComfyUI statistics (custom nodes count, Python version, venv info)
- New main menu option to open ComfyUI output folder
- Enhanced tunnel interface with interactive footer
- Real-time tunnel log display with scrolling output
- Tunnel management options (New, Save logs, Menu, Quit)
- Server check before starting tunnels

### Changed
- Tunnel functions completely rewritten with interactive UI
- Tunnels now use port from launch args or default 8188
- Menu box borders changed to dark blue for better contrast
- Server launch screen shows header immediately without waiting message
- Tunnel screens show header immediately without waiting message
- Help menu enhanced with detailed information about venv, paths, and tunnels
- Custom nodes menu "Select option:" text changed to aqua blue
- Removed path issues troubleshooting (auto-handled now)

### Fixed
- Tunnel output now displays in real-time with line buffering
- Tunnels properly killed when returning to menu or quitting
- Browser opens to correct URL based on settings

## [1.4.0] - 2025-12-06

### Added
- Auto-detection of ComfyUI folder (accepts both parent folder and ComfyUI folder itself)
- Full path display showing actual ComfyUI location
- Aqua blue color scheme throughout entire UI
- Enhanced tunnel functions with proper port detection from launch args

### Changed
- Box borders changed from rounded (╭╮╰╯) to angle brackets (<>)
- All teal colors replaced with aqua blue (#39 color code)
- Main menu now shows all sections even when path is invalid
- Path warning displays inline instead of replacing entire info box
- Exit animation updated with full ASCII art
- Launch box now clears properly when server starts
- Update status messages show proper colors (green/red)
- Custom nodes disabled indicator changed to red circle
- Launch arguments editor uses aqua blue throughout
- Help menu colors updated to aqua blue with yellow highlights
- Args text on main menu changed to green
- Footer borders changed to use > instead of ╴
- Exit key (E) in footer changed to purple color
- Venv path menu colors updated (yellow example, aqua instructions)

### Fixed
- Server status detection works correctly with valid/invalid paths
- Tunnel functions now use port from launch args or default 8188
- Path validation no longer breaks menu display

## [1.3.0] - 2025-12-06

### Added
- New compact ASCII header design
- Blue gradient color theme throughout UI
- GitHub repository link in header
- Comprehensive node details display (version, publisher, description, icon, etc.)
- Icon rendering support (Kitty terminal inline images, chafa/jp2a ASCII art)
- Proper TOML parsing for all pyproject.toml fields
- Menu icons for all options

### Changed
- Complete UI redesign with blue gradient theme
- Menu boxes now use gradient borders
- All prompts and labels use blue color scheme
- Custom nodes manager shows full node information
- Node details display at top with icon rendering
- Improved prompt text in custom nodes menu
- Path, Status, Args, and Venv now display with proper wrapping

### Fixed
- Description parsing handles escaped quotes and multi-line content
- All TOML fields parse correctly without breaking on special characters
- Box borders properly closed with corner characters

## [1.2.0] - 2025-12-06

### Fixed
- Pinggy tunnel now works correctly from footer (P key)
- Footer label correctly shows "PINGGY TUNNEL" or "CLOUDFLARE TUNNEL" based on tunnel type
- Tunnel type tracking ensures correct tunnel starts when server becomes ready
- Pinggy tunnel runs silently in background like Cloudflare
- Pinggy URL displays with "(60min free)" note in footer

### Changed
- Tunnel type is now tracked separately from tunnel PID
- Auto-start logic respects which tunnel type user requested

## [1.1.9] - 2025-12-06

### Added
- Pinggy tunnel support from footer (P key)
- Footer now shows both T=Tunnel and P=Pinggy options

### Changed
- Tunnel URL color changed to yellow for better visibility
- PID color changed to red for emphasis
- Removed fade effect from footer borders for cleaner look
- Status messages (Kill, Save, Menu, Exit) now appear above footer

## [1.1.8] - 2025-12-06

### Added
- Tunnel status messages in footer during tunnel creation
- "Waiting for server to start..." when T pressed before server ready
- "Digging tunnel, please wait..." while establishing tunnel connection
- Auto-start tunnel when server becomes ready if user already pressed T

### Fixed
- Tunnel status messages now display in footer instead of scrolling output
- Footer properly expands to 4 lines for tunnel status/URL display
- Tunnel creation is silent - no scrolling messages

## [1.1.7] - 2025-12-06

### Fixed
- Footer now properly locked to bottom of terminal using scroll regions
- Output scrolls only in designated area between header and footer
- Footer no longer overwrites or scrolls with server output
- Proper cursor positioning maintains clean output flow

### Changed
- Implemented terminal scroll region (tput csr) for fixed footer
- Footer redraws after each output batch to stay visible
- Scroll region resets on cleanup/exit

## [1.1.6] - 2025-12-06

### Added
- Persistent footer with live controls while server runs
- Footer shows: T=Tunnel, K=Kill, S=Save, M=Menu, E=Exit
- Tunnel URL displays in footer when active
- "Digging tunnel" message while waiting for tunnel
- Auto-install cloudflared from footer (apt support)
- Server URL detection for proper tunnel creation

### Changed
- Footer attempts to stay at bottom of terminal
- Tunnel section shows in labeled box when active
- Footer redraws after output to maintain visibility

### Known Issues
- Footer positioning needs refinement (scrolls with output)
- Working on persistent bottom placement

## [1.1.5] - 2025-12-06

### Added
- Auto-install cloudflared when starting Cloudflare tunnel
- Multi-line wrapping for long paths, args, and venv paths
- Menu (M) option in footer to return to menu without killing server
- Exit (E) option in footer to exit script without killing server

### Fixed
- Footer key commands now working (T, K, S, M, E)
- Port detection now uses actual port from launch args
- Long launch args no longer break menu layout
- Args display in red, venv path in purple for better visibility

### Changed
- Footer shows: T=Tunnel, K=Kill, S=Save, M=Menu, E=Exit
- Text wraps properly with indentation instead of truncating
- Status detection uses dynamic port from args

## [1.1.4] - 2025-12-06

### Added
- Interactive footer while server is running
- Live controls: T=Tunnel, K=Kill, S=Save Logs, Q=Quit
- Footer stays at bottom of terminal
- Real-time key input handling

### Changed
- Server output scrolls normally with footer overlay
- Simplified terminal control for better compatibility

## [1.1.3] - 2025-12-06

### Added
- Auto-launch browser when server is ready
- Browser opens only after detecting "To see the GUI go to:" message
- Readline editing for launch args (backspace, arrow keys work)
- Pre-filled current args in editor for easy modification

### Fixed
- Status colors: STOPPED now red, RUNNING now green (was reversed)
- Ctrl+C now properly kills server process (no orphaned processes)
- Duplicate console output removed (was showing twice)
- Browser launch detection now works correctly
- Server cleanup with force kill if needed

### Changed
- Launch args editor now on separate line for better editing
- Real-time output streaming without duplication
- Improved trap handling for graceful shutdown

## [1.1.2] - 2025-12-06

### Added
- **Advanced Custom Nodes Management**
  - Toggle nodes on/off (disables without deleting)
  - Install node dependencies from requirements.txt into venv
  - Delete nodes with confirmation prompt
  - Repository URL display for each node
  - Visual status indicators (● enabled, ○ disabled)
  - Per-node action menu (Update, Toggle, Install Deps, Delete)
- Dimmed display for disabled nodes (gray text)
- Repository links shown under each node description

### Changed
- Custom nodes manager completely overhauled with new UI
- Disabled nodes shown with gray color and hollow circle indicator
- Active nodes shown with green circle and yellow name
- Update All now only updates active (enabled) nodes
- Improved help text explaining available actions

### Technical
- Nodes disabled by renaming with `.disabled` suffix
- ComfyUI automatically ignores `.disabled` folders
- Dependencies installed directly into project venv
- Safe delete with "DELETE" confirmation required

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
