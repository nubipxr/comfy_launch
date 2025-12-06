#!/bin/bash

# ComfyUI Launcher v1.1.0
# https://cloudwerx.dev | https://github.com/CLOUDWERX-DEV/comfy_launch

set -o pipefail

# Colors - Tokyo Night / Catppuccin
R='\e[0;31m'; G='\e[0;32m'; Y='\e[1;33m'; B='\e[0;34m'; P='\e[0;35m'
C='\e[0;36m'; W='\e[1;37m'; GR='\e[0;37m'; M='\e[0;95m'; N='\e[0m'
BG='\e[1;32m'; BC='\e[1;36m'; BM='\e[1;35m'

# Config
CONFIG_DIR="$HOME/.config/comfy_launch"
CONFIG_FILE="$CONFIG_DIR/config.sh"
mkdir -p "$CONFIG_DIR"

COMFY_PATH=""
VENV_PATH=""
LAUNCH_ARGS="--listen 0.0.0.0 --port 6057 --use-quad-cross-attention --cuda-malloc"
SERVER_PORT=6057

load_config() {
    [[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE" 2>/dev/null || true
}

save_config() {
    cat > "$CONFIG_FILE" << EOF
COMFY_PATH="$COMFY_PATH"
VENV_PATH="$VENV_PATH"
LAUNCH_ARGS="$LAUNCH_ARGS"
EOF
}

# Rounded box drawing
rbox_top() {
    echo -e "${C}╭$(printf '─%.0s' {1..84})╴${N}"
}

rbox_line() {
    local text="$1"
    echo -e "${C}│${N} $text"
}

rbox_bottom() {
    echo -e "${C}╰$(printf '─%.0s' {1..84})╴${N}"
}

divider() {
    echo -e "${GR}$(printf '─%.0s' {1..86})${N}"
}

# Animated ASCII header
show_header() {
    clear
    echo -e "${M}  _______ _______ ___ ___ _______ ___ ___     ___     _______ ___ ___ ______  _______ ___ ___ _______ _______ ${N}"
    sleep 0.05
    echo -e "${M} |   _   |   _   |   Y   |   _   |   Y   |   |   |   |   _   |   Y   |   _  \|   _   |   Y   |   _   |   _   \ ${N}"
    sleep 0.05
    echo -e "${P} |.  1___|.  |   |.      |.  1___|   1   |   |.  |   |.  1   |.  |   |.  |   |.  1___|.  1   |.  1___|.  l   /${N}"
    sleep 0.05
    echo -e "${P} |.  |___|.  |   |. \_/  |.  __)  \_   _/    |.  |___|.  _   |.  |   |.  |   |.  |___|.  _   |.  __)_|.  _   1${N}"
    sleep 0.05
    echo -e "${C} |:  1   |:  1   |:  |   |:  |     |:  |     |:  1   |:  |   |:  1   |:  |   |:  1   |:  |   |:  1   |:  |   |${N}"
    sleep 0.05
    echo -e "${C} |::.. . |::.. . |::.|:. |::.|     |::.|     |::.. . |::.|:. |::.. . |::.|   |::.. . |::.|:. |::.. . |::.|:. |${N}"
    sleep 0.05
    echo -e "${BC} \`-------\`-------\`--- ---\`---'     \`---'     \`-------\`--- ---\`-------\`--- ---\`-------\`--- ---\`-------\`--- ---'${N}"
    sleep 0.05
    echo -e "${GR}                                                                   [ A BadAss Launcher Script For ComfyUI.. ]${N}"
    echo ""
    echo -e "  ${BG}⚡ C̷L̷O̷U̷D̷W̷E̷R̷X̷ ̷L̷A̷B̷${N} ${GR}»${N} ${BC}https://cloudwerx.dev${N} ${GR}|${N} ${P}Digital Food for the Analog Soul${N}"
    echo ""
}

# Exit animation
show_exit() {
    clear
    local colors=("$M" "$P" "$C" "$BC" "$BM" "$G")
    local art=(
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣄⡀⠀⠀⠀⠀⠀⠀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢞⡫⠄⠀⠀⠀⠉⠓⢦⡀⢀⣴⡿⠉⠀⠉⠉⠳⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣄⣀⠀⣼⢣⣎⠀⠀⠀⠀⠀⠀⠀⠀⢻⣟⣟⠔⠀⠀⠀⠀⠀⠀⢀⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠿⢩⣄⡀⠈⠻⠇⡎⡎⡂⠀⠀⠀⠀⠀⠀⠀⢸⣐⣈⡀⠀⠀⠀⠀⠀⡄⡆⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡤⠶⣾⠀⠘⠉⣻⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠏⢉⠈⢻⡄⠀⠀⠀⠀⠃⢇⡿⣟⠿⠳⣦⡀⠀⠀⠀⠀⠀⠀"
    )
    
    for i in "${!art[@]}"; do
        local color="${colors[$((i % ${#colors[@]}))]}"
        echo -e "${color}${art[$i]}${N}"
        sleep 0.08
    done
    
    echo ""
    echo -e "${BC}___________   ___________________  ___ __ ________________________     ____   ______________${N}"
    sleep 0.05
    echo -e "${M}7     77  7   7     77  7  77    \\ 7  V  V  77     77  _  77  7  7     7  7   7  _  77  _  7${N}"
    sleep 0.05
    echo -e "${P}|  ___!|  |   |  7  ||  |  ||  7  ||  |  |  ||  ___!|    _|!_   _!     |  |   |  _  ||   __|${N}"
    sleep 0.05
    echo -e "${C}|  7___|  !___|  |  ||  |  ||  |  ||  !  !  ||  __|_|  _ \\ |     |     |  !___|  7  ||  _  |${N}"
    sleep 0.05
    echo -e "${G}|     7|     7|  !  ||  !  ||  !  ||        ||     7|  7  ||  7  |     |     7|  |  ||  7  |${N}"
    sleep 0.05
    echo -e "${Y}!_____!!_____!!_____!!_____!!_____!!________!!_____!!__!__!!__!__!     !_____!!__!__!!_____!${N}"
    sleep 0.05
    echo -e "${BC}                                                                        http://cloudwerx.dev${N}"
    echo ""
    echo -e "${BG}                              👋 Thanks for using ComfyUI Launcher!${N}"
    echo ""
    sleep 0.5
}

is_running() {
    lsof -i :$SERVER_PORT -sTCP:LISTEN >/dev/null 2>&1
}

get_pid() {
    lsof -t -i :$SERVER_PORT -sTCP:LISTEN 2>/dev/null | head -1
}

kill_server() {
    local pid=$(get_pid)
    if [[ -n "$pid" ]]; then
        echo -e "${Y}⏹  Killing server (PID: $pid)...${N}"
        kill "$pid" 2>/dev/null && echo -e "${G}✓ Server stopped${N}" || echo -e "${R}✗ Failed${N}"
        sleep 1
    else
        echo -e "${GR}No server running on port $SERVER_PORT${N}"
    fi
}

validate_setup() {
    [[ ! -d "$COMFY_PATH" ]] && return 1
    [[ ! -d "$COMFY_PATH/ComfyUI" ]] && return 1
    if [[ -n "$VENV_PATH" ]]; then
        [[ ! -d "$VENV_PATH" ]] && return 1
    else
        [[ ! -d "$COMFY_PATH/venv" ]] && return 1
        VENV_PATH="$COMFY_PATH/venv"
    fi
    return 0
}

update_comfyui() {
    cd "$COMFY_PATH/ComfyUI" || return 1
    echo -e "${Y}📦 Updating ComfyUI...${N}"
    if git pull --ff-only 2>&1 | tee /tmp/comfy_update.log; then
        echo -e "${G}✓ ComfyUI updated${N}"
    else
        echo -e "${R}✗ Update failed - check /tmp/comfy_update.log${N}"
    fi
}


# Custom nodes manager
manage_custom_nodes() {
    local nodes_dir="$COMFY_PATH/ComfyUI/custom_nodes"
    [[ ! -d "$nodes_dir" ]] && { echo -e "${R}✗ Custom nodes directory not found${N}"; return 1; }
    
    while true; do
        clear
        show_header
        echo -e "${W}CUSTOM NODES MANAGER${N}"
        divider
        echo ""
        
        local nodes=()
        local i=1
        
        for node_dir in "$nodes_dir"/*; do
            [[ ! -d "$node_dir" ]] && continue
            local node_name=$(basename "$node_dir")
            [[ "$node_name" == "__pycache__" ]] && continue
            local display_name="$node_name"
            local version=""
            local desc=""
            
            if [[ -f "$node_dir/pyproject.toml" ]]; then
                display_name=$(grep -m1 '^DisplayName' "$node_dir/pyproject.toml" 2>/dev/null | cut -d'"' -f2 || echo "$node_name")
                version=$(grep -m1 '^version' "$node_dir/pyproject.toml" 2>/dev/null | cut -d'"' -f2)
                desc=$(grep -m1 '^description' "$node_dir/pyproject.toml" 2>/dev/null | cut -d'"' -f2 | sed 's/\\n/ /g' | sed 's/  */ /g')
            fi
            
            nodes+=("$node_dir")
            
            echo -e "${BC}$i.${N} ${C}•${N} ${Y}$display_name${N} ${GR}${version:+v$version}${N}"
            if [[ -n "$desc" ]]; then
                while IFS= read -r line; do
                    echo -e "     ${GR}$line${N}"
                done < <(echo "$desc" | fold -s -w 77)
            fi
            echo ""
            ((i++))
        done
        
        divider
        echo -e "${BG}A.${N} ${W}Update All Nodes${N}"
        echo -e "${Y}U.${N} ${W}Update ComfyUI${N}"
        echo -e "${R}0.${N} ${W}Back to Main Menu${N}"
        echo ""
        echo -e "${GR}Enter a number (1-${#nodes[@]}) to update that node, or A/U/0${N}"
        echo -ne "${C}➜${N} ${W}Select option:${N} "
        read -r choice
        
        case "$choice" in
            [0]) return ;;
            [Aa])
                echo ""
                for node_dir in "${nodes[@]}"; do
                    local name=$(basename "$node_dir")
                    echo -e "${Y}Updating $name...${N}"
                    cd "$node_dir" && git pull --ff-only 2>&1 | grep -E "(Already|Updating|error)" || echo -e "${GR}  No git repo${N}"
                done
                echo ""
                read -p "Press Enter to continue..."
                ;;
            [Uu])
                update_comfyui
                read -p "Press Enter to continue..."
                ;;
            [1-9]*)
                if [[ $choice -le ${#nodes[@]} ]]; then
                    local node_dir="${nodes[$((choice-1))]}"
                    local name=$(basename "$node_dir")
                    echo ""
                    echo -e "${Y}Updating $name...${N}"
                    cd "$node_dir" && git pull --ff-only || echo -e "${R}✗ Update failed${N}"
                    echo ""
                    read -p "Press Enter to continue..."
                fi
                ;;
        esac
    done
}

launch_server() {
    cd "$COMFY_PATH/ComfyUI" || return 1
    source "$VENV_PATH/bin/activate" || return 1
    
    echo ""
    rbox_top
    rbox_line "${W}🚀 LAUNCHING COMFYUI${N}"
    rbox_line "${GR}Args: $LAUNCH_ARGS${N}"
    rbox_line "${GR}Port: $SERVER_PORT${N}"
    rbox_bottom
    echo ""
    
    python main.py $LAUNCH_ARGS 2>&1 | tee /tmp/comfy_launch_error.log &
    local pid=$!
    sleep 3
    
    if ! kill -0 "$pid" 2>/dev/null; then
        echo -e "${R}✗ Failed to start${N}\n"
        if grep -q "ImportError.*folder_paths" /tmp/comfy_launch_error.log 2>/dev/null; then
            echo -e "${Y}⚠ Dependencies issue detected${N}"
            echo -e "${W}Fix by reinstalling requirements:${N}"
            echo -e "  ${C}cd $COMFY_PATH/ComfyUI${N}"
            echo -e "  ${C}source $VENV_PATH/bin/activate${N}"
            echo -e "  ${C}pip install -r requirements.txt${N}"
            echo ""
            read -p "Press Enter to continue..."
        fi
        return 1
    fi
    
    echo -e "${G}✓ Server started (PID: $pid)${N}"
    echo -e "${C}💡 Press Ctrl+C to stop${N}\n"
    trap "echo -e '\n${Y}⏹  Stopping...${N}'; kill $pid 2>/dev/null; sleep 2; exit 0" INT
    wait $pid
}

tunnel_cloudflare() {
    command -v cloudflared &>/dev/null || { echo -e "${R}✗ cloudflared not installed${N}"; return 1; }
    echo -e "${M}☁️  Starting Cloudflare tunnel...${N}\n"
    cloudflared tunnel --url "http://localhost:$SERVER_PORT" 2>&1 | while IFS= read -r line; do
        [[ "$line" =~ trycloudflare\.com ]] && echo -e "${BG}🌐 ${W}$line${N}" || echo -e "${GR}$line${N}"
    done
}

tunnel_pinggy() {
    command -v ssh &>/dev/null || { echo -e "${R}✗ SSH required${N}"; return 1; }
    echo -e "${C}🌐 Starting Pinggy tunnel (60min free)...${N}\n"
    echo "yes" | ssh -p 443 -R0:localhost:$SERVER_PORT qr@free.pinggy.io
}

open_folder() {
    for fm in nemo dolphin nautilus; do
        if command -v $fm &>/dev/null; then
            $fm "$COMFY_PATH" &>/dev/null &
            echo -e "${G}✓ Opened${N}"
            return 0
        fi
    done
    xdg-open "$COMFY_PATH" &>/dev/null &
}

set_path() {
    echo -e "${C}Enter ComfyUI root path (containing ComfyUI/ folder):${N}"
    echo -e "${GR}Example: /home/user/Desktop/Servers/comfy${N}"
    read -r new_path
    [[ -n "$new_path" ]] && COMFY_PATH=$(realpath "$new_path" 2>/dev/null || echo "$new_path") && save_config
}

set_venv() {
    echo -e "${C}Enter venv path:${N}"
    echo -e "${GR}Example: /home/user/Desktop/Servers/comfy/venv${N}"
    echo -e "${GR}Leave empty to use default (COMFY_PATH/venv)${N}"
    read -r new_venv
    VENV_PATH="$new_venv"
    save_config
    echo -e "${G}✓ Venv path updated${N}"
}

edit_launch_args() {
    clear
    show_header
    echo -e "${W}LAUNCH ARGUMENTS EDITOR${N}"
    divider
    echo -e "${W}Current:${N} ${C}$LAUNCH_ARGS${N}\n"
    
    echo -e "${BG}NETWORK${N}"
    echo -e "  ${C}--listen 0.0.0.0${N}              ${GR}Listen on all interfaces (default: 127.0.0.1)${N}"
    echo -e "  ${C}--port 8188${N}                   ${GR}Set port number (default: 8188)${N}"
    echo -e "  ${C}--enable-cors-header${N}          ${GR}Enable CORS${N}"
    
    echo -e "\n${BG}VRAM MODES${N} ${GR}(mutually exclusive)${N}"
    echo -e "  ${C}--gpu-only${N}                    ${GR}Keep everything on GPU${N}"
    echo -e "  ${C}--highvram${N}                    ${GR}Keep models in GPU (24GB+)${N}"
    echo -e "  ${C}--normalvram${N}                  ${GR}Normal VRAM usage (8-16GB)${N}"
    echo -e "  ${C}--lowvram${N}                     ${GR}Split unet for less VRAM (4-6GB)${N}"
    echo -e "  ${C}--novram${N}                      ${GR}Minimal VRAM mode${N}"
    echo -e "  ${C}--cpu${N}                         ${GR}CPU only (slow)${N}"
    
    echo -e "\n${BG}ATTENTION${N} ${GR}(mutually exclusive)${N}"
    echo -e "  ${C}--use-split-cross-attention${N}   ${GR}Split cross attention${N}"
    echo -e "  ${C}--use-quad-cross-attention${N}    ${GR}Sub-quadratic attention (recommended)${N}"
    echo -e "  ${C}--use-pytorch-cross-attention${N} ${GR}PyTorch 2.0 attention${N}"
    echo -e "  ${C}--use-sage-attention${N}          ${GR}Sage attention${N}"
    echo -e "  ${C}--use-flash-attention${N}         ${GR}Flash attention${N}"
    
    echo -e "\n${BG}PRECISION - UNET${N} ${GR}(mutually exclusive)${N}"
    echo -e "  ${C}--fp16-unet${N}                   ${GR}FP16 diffusion model${N}"
    echo -e "  ${C}--bf16-unet${N}                   ${GR}BF16 diffusion model${N}"
    echo -e "  ${C}--fp8_e4m3fn-unet${N}             ${GR}FP8 E4M3FN weights${N}"
    echo -e "  ${C}--fp8_e5m2-unet${N}               ${GR}FP8 E5M2 weights${N}"
    
    echo -e "\n${BG}PRECISION - VAE${N} ${GR}(mutually exclusive)${N}"
    echo -e "  ${C}--fp16-vae${N}                    ${GR}FP16 VAE (faster, may cause black images)${N}"
    echo -e "  ${C}--fp32-vae${N}                    ${GR}FP32 VAE (full precision)${N}"
    echo -e "  ${C}--bf16-vae${N}                    ${GR}BF16 VAE${N}"
    echo -e "  ${C}--cpu-vae${N}                     ${GR}Run VAE on CPU${N}"
    
    echo -e "\n${BG}PRECISION - TEXT ENCODER${N} ${GR}(mutually exclusive)${N}"
    echo -e "  ${C}--fp8_e4m3fn-text-enc${N}         ${GR}FP8 E4M3FN text encoder${N}"
    echo -e "  ${C}--fp8_e5m2-text-enc${N}           ${GR}FP8 E5M2 text encoder${N}"
    echo -e "  ${C}--fp16-text-enc${N}               ${GR}FP16 text encoder${N}"
    
    echo -e "\n${BG}MEMORY${N}"
    echo -e "  ${C}--cuda-malloc${N}                 ${GR}Enable cudaMallocAsync${N}"
    echo -e "  ${C}--disable-smart-memory${N}        ${GR}Aggressive RAM offload${N}"
    echo -e "  ${C}--reserve-vram 2${N}              ${GR}Reserve VRAM in GB for OS${N}"
    
    echo -e "\n${BG}CACHE${N} ${GR}(mutually exclusive)${N}"
    echo -e "  ${C}--cache-classic${N}               ${GR}Aggressive caching${N}"
    echo -e "  ${C}--cache-lru 10${N}                ${GR}LRU cache (N results)${N}"
    
    echo -e "\n${BG}PREVIEW${N}"
    echo -e "  ${C}--preview-method auto${N}         ${GR}auto/latent2rgb/taesd/none${N}"
    
    echo -e "\n${BG}OTHER${N}"
    echo -e "  ${C}--auto-launch${N}                 ${GR}Open browser automatically${N}"
    echo -e "  ${C}--multi-user${N}                  ${GR}Enable per-user storage${N}"
    echo -e "  ${C}--verbose DEBUG${N}               ${GR}Logging level${N}"
    
    echo -e "\n${Y}Format:${N} ${GR}Separate with spaces${N}"
    echo -e "${Y}Example:${N} ${C}--listen 0.0.0.0 --port 6057 --highvram --fp16-vae${N}\n"
    echo -ne "${C}Enter new args (or Enter to keep):${N} "
    read -r new_args
    [[ -n "$new_args" ]] && LAUNCH_ARGS="$new_args" && save_config && echo -e "${G}✓ Updated${N}"
    sleep 2
}


show_help() {
    clear
    show_header
    echo -e "${W}HELP & RESOURCES${N}"
    divider
    echo ""
    echo -e "${W}USAGE:${N}"
    echo -e "  ${C}comfy_launch.sh${N}                ${GR}Interactive menu${N}"
    echo -e "  ${C}comfy_launch.sh start${N}          ${GR}Start server${N}"
    echo -e "  ${C}comfy_launch.sh update${N}         ${GR}Update ComfyUI${N}"
    echo -e "  ${C}comfy_launch.sh kill${N}           ${GR}Kill server${N}"
    echo -e "  ${C}comfy_launch.sh nodes${N}          ${GR}Manage custom nodes${N}"
    echo -e "  ${C}comfy_launch.sh update-nodes${N}   ${GR}Update all nodes${N}"
    echo -e "  ${C}comfy_launch.sh tunnel cf${N}      ${GR}Cloudflare tunnel${N}"
    echo -e "  ${C}comfy_launch.sh tunnel pinggy${N}  ${GR}Pinggy tunnel${N}"
    echo -e "  ${C}comfy_launch.sh path /dir${N}      ${GR}Set ComfyUI path${N}"
    echo -e "  ${C}comfy_launch.sh venv /dir${N}      ${GR}Set venv path${N}"
    echo -e "  ${C}comfy_launch.sh folder${N}         ${GR}Open folder${N}"
    echo ""
    echo -e "${W}LINKS:${N}"
    echo -e "  ${BC}🏠 https://cloudwerx.dev${N}                              ${GR}Homepage & Blog${N}"
    echo -e "  ${BC}📖 https://comfyanonymous.github.io/ComfyUI_examples/${N}  ${GR}Official Examples & Workflows${N}"
    echo -e "  ${BC}📚 https://docs.comfy.org${N}                             ${GR}Official Documentation${N}"
    echo -e "  ${P}🐙 https://github.com/comfyanonymous/ComfyUI${N}          ${GR}ComfyUI Source Code${N}"
    echo -e "  ${P}💻 https://github.com/CLOUDWERX-DEV/comfy_launch${N}      ${GR}This Script (Report Issues)${N}"
    echo -e "  ${Y}🤗 https://huggingface.co/Comfy-Org${N}                   ${GR}Official Models & Resources${N}"
    echo -e "  ${G}🎨 https://civitai.com${N}                                ${GR}Community Models & LoRAs${N}"
    echo ""
    echo -e "${W}SUPPORT:${N}"
    echo -e "  ${M}☕ https://buymeacoffee.com/cloudwerxl3${N}               ${GR}Buy Me A Coffee (Donate)${N}"
    echo -e "  ${BC}💬 https://discord.gg/EQSBU5aK${N}                        ${GR}Discord Server (Help & Chat)${N}"
    echo -e "  ${C}📧 mail@cloudwerx.dev${N}                                ${GR}Email Contact${N}"
    echo ""
    echo -e "${W}TROUBLESHOOTING:${N}"
    echo -e "  ${R}✗${N} Port busy? ${G}comfy_launch.sh kill${N}"
    echo -e "  ${R}✗${N} No venv? ${C}cd ComfyUI && python -m venv venv${N}"
    echo -e "  ${R}✗${N} Path issues? Set root folder containing ComfyUI/, not ComfyUI/ itself"
    echo ""
    read -p "Press Enter to continue..."
}

show_menu() {
    show_header
    load_config
    
    rbox_top
    if [[ -z "$COMFY_PATH" ]] || ! validate_setup; then
        rbox_line "${R}⚠  NO VALID COMFYUI PATH DETECTED${N}"
    else
        local status="${G}⏹ STOPPED${N}"
        is_running && status="${R}🖥 RUNNING (PID: $(get_pid))${N}"
        rbox_line "${B}📁${N} ${W}Path:${N} ${C}$COMFY_PATH${N}"
        rbox_line "${G}⚙${N}  ${W}Status:${N} $status"
        rbox_line "${Y}⚡${N} ${W}Args:${N} ${GR}$LAUNCH_ARGS${N}"
        [[ -n "$VENV_PATH" ]] && rbox_line "${P}🐍${N} ${W}Venv:${N} ${GR}$VENV_PATH${N}"
    fi
    rbox_bottom
    echo ""
    
    rbox_top
    rbox_line "${BG}1.${N} ${W}Launch ComfyUI${N} ${GR}(Ctrl+C to stop)${N}"
    rbox_line "${Y}2.${N} ${W}Update ComfyUI${N}"
    rbox_line "${BC}3.${N} ${W}Manage Custom Nodes${N}"
    rbox_line "${R}4.${N} ${W}Kill Server${N} ${GR}(if running)${N}"
    rbox_line "${C}5.${N} ${W}Edit Launch Args${N}"
    rbox_line "${M}6.${N} ${W}☁️  Cloudflare Tunnel${N}"
    rbox_line "${C}7.${N} ${W}🌐 Pinggy Tunnel${N} ${GR}(60min free)${N}"
    rbox_line "${B}8.${N} ${W}Open Folder${N}"
    rbox_line "${B}9.${N} ${W}Set ComfyUI Path${N}"
    rbox_line "${P}V.${N} ${W}Set Venv Path${N} ${GR}(Python virtual environment)${N}"
    rbox_line "${W}H.${N} ${W}Help & Links${N}"
    rbox_line "${R}0.${N} ${W}Exit${N}"
    rbox_bottom
    echo ""
    
    echo -ne "${BC}➜${N} ${W}Select option:${N} "
}

# CLI argument handling
if [[ $# -gt 0 ]]; then
    load_config
    case "$1" in
        start|launch)
            validate_setup || { echo -e "${R}✗ Invalid setup${N}"; exit 1; }
            is_running && { echo -e "${R}✗ Already running${N}"; exit 1; }
            launch_server
            ;;
        update)
            validate_setup || { echo -e "${R}✗ Invalid setup${N}"; exit 1; }
            update_comfyui
            ;;
        nodes)
            validate_setup || { echo -e "${R}✗ Invalid setup${N}"; exit 1; }
            manage_custom_nodes
            ;;
        update-nodes)
            validate_setup || { echo -e "${R}✗ Invalid setup${N}"; exit 1; }
            nodes_dir="$COMFY_PATH/ComfyUI/custom_nodes"
            for node_dir in "$nodes_dir"/*; do
                [[ -d "$node_dir" ]] && cd "$node_dir" && echo "Updating $(basename "$node_dir")..." && git pull --ff-only
            done
            ;;
        kill|stop)
            kill_server
            ;;
        tunnel)
            is_running || { echo -e "${R}✗ Start server first${N}"; exit 1; }
            case "${2:-cf}" in
                cf|cloudflare) tunnel_cloudflare ;;
                pinggy) tunnel_pinggy ;;
                *) echo -e "${R}✗ Use: tunnel [cf|pinggy]${N}"; exit 1 ;;
            esac
            ;;
        folder|open)
            [[ -n "$COMFY_PATH" ]] && validate_setup || { echo -e "${R}✗ Set path first${N}"; exit 1; }
            open_folder
            ;;
        path)
            [[ -n "$2" ]] && COMFY_PATH="$2" && save_config && echo -e "${G}✓ Path set${N}" || set_path
            ;;
        venv)
            [[ -n "$2" ]] && VENV_PATH="$2" && save_config && echo -e "${G}✓ Venv set${N}" || set_venv
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            echo -e "${R}✗ Unknown command: $1${N}"
            echo -e "Run ${C}comfy_launch.sh help${N} for usage"
            exit 1
            ;;
    esac
    exit 0
fi

# Interactive menu loop
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            if ! validate_setup; then
                echo -e "${Y}⚠ Set path first (option 9)${N}"
                sleep 2
                continue
            fi
            if is_running; then
                echo -e "${R}✗ Already running (use option 4 to kill)${N}"
                sleep 2
            else
                launch_server
            fi
            ;;
        2)
            validate_setup && update_comfyui || echo -e "${Y}⚠ Set path first${N}"
            sleep 2
            ;;
        3)
            validate_setup && manage_custom_nodes || { echo -e "${Y}⚠ Set path first${N}"; sleep 2; }
            ;;
        4)
            kill_server
            sleep 2
            ;;
        5)
            edit_launch_args
            ;;
        6)
            if ! is_running; then
                echo -e "${R}✗ Start server first (option 1)${N}"
                sleep 2
            else
                tunnel_cloudflare
            fi
            ;;
        7)
            if ! is_running; then
                echo -e "${R}✗ Start server first (option 1)${N}"
                sleep 2
            else
                tunnel_pinggy
            fi
            ;;
        8)
            if [[ -n "$COMFY_PATH" ]] && validate_setup; then
                open_folder
            else
                echo -e "${Y}⚠ Set valid path first (option 9)${N}"
            fi
            sleep 2
            ;;
        9)
            set_path
            sleep 2
            ;;
        [Vv])
            set_venv
            sleep 2
            ;;
        [Hh])
            show_help
            ;;
        0|q|Q|exit)
            show_exit
            exit 0
            ;;
        *)
            echo -e "${R}Invalid option${N}"
            sleep 1
            ;;
    esac
done
