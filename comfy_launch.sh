#!/bin/bash

# ComfyUI Launcher v1.3.0
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

get_port_from_args() {
    echo "$LAUNCH_ARGS" | grep -oP '(?<=--port )\d+' || echo "8188"
}

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

# Rounded box drawing with gradient
rbox_top() {
    echo -e "\e[38;5;39m<$(printf '─%.0s' {1..84})>${N}"
}

rbox_line() {
    local text="$1"
    echo -e " $text"
}

rbox_bottom() {
    echo -e "\e[38;5;39m<$(printf '─%.0s' {1..84})>${N}"
}

divider() {
    echo -e "\e[38;5;39m<$(printf '─%.0s' {1..86})>${N}"
}
# Animated ASCII header
show_header() {
    clear
          echo -e "${M}       _____ _____ _____ _____ __ __    __    _____ _____ _____ _____ _____ ${N}"
    sleep 0.05
          echo -e "${M}      |     |     |     |   __|  |  |  |  |  |  _  |  |  |   | |     |  |  |${N}"
    sleep 0.05
          echo -e "${P}      |   --|  |  | | | |   __|_   _|  |  |__|     |  |  | | | |   --|     |${N}"
    sleep 0.05
          echo -e "${P}      |_____|_____|_|_|_|__|    |_|    |_____|__|__|_____|_|___|_____|__|__|${N}"
    sleep 0.05
    echo -e "   \e[38;5;39m<───\e[0m \e[38;5;33mhttps://github.com/CLOUDWERX-DEV/comfy_launch\e[0m ${W}»${N} \e[38;5;39mhttps://cloudwerx.dev\e[0m \e[38;5;39m───>${N}"
    echo ""
}

# Exit animation
show_exit() {
    clear
    local colors=("$M" "$P" "$C" "$BC" "$BM" "$G")
    local art=(
        "⠀⠀⠀⠀          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣄⡀⠀⠀⠀⠀⠀⠀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀         ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢞⡫⠄⠀⠀⠀⠉⠓⢦⡀⢀⣴⡿⠉⠀⠉⠉⠳⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀          ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣄⣀⠀⣼⢣⣎⠀⠀⠀⠀⠀⠀⠀⠀⢻⣟⣟⠔⠀⠀⠀⠀⠀⢀⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀          ⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⢠⠿⢩⣄⡀⠈⠻⠇⡎⡎⡂⠀⠀⠀⠀⠀⠀⠀⢸⣐⣈⡀⠀⠀⠀⠀⠀⡄⡆⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀          ⠀⠀⠀⠀⠀⠀⣠⡤⠶⣾⠀⠘⠉⣻⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠏⢉⠈⢻⡄⠀⠀⠀⠀⠃⢇⡿⣟⠿⠳⣦⡀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡞⠉⠀⠀⠈⠳⠶⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠁⠀⢿⣤⡾⠁⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠈⣧⠀⠀⠀⠀⠀⠀"
        "⠀          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⠸⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠷⠶⢤⡀⠀⠀⠀"
        "          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⡸⡙⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠋⢀⣀⡀⠀⠙⢧⡀⠀"
        "⠀⠀          ⠀⠀⠀⠀⠀⠀⠀⢀⡴⠞⠛⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⠛⠉⣻⠀⠀⡌⣷⡀"
        "⠀⠀          ⠀⠀⠀⠀⠀⠀⣰⡏⠁⢀⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠶⠤⠶⠋⢠⢠⢃⡿⠁"
        "⠀⠀          ⠀⠀⠀⠀⠀⠀⣿⢇⠀⣿⡀⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡴⠶⣶⡞⠁⠀"
        "⠀⠀           ⠀⠀⠀⠀⠀⠀⠘⢯⣓⡀⠀⢀⣼⣱⡀⠀⠀⠀⠀⠀⠀⣰⠟⠁⢙⡧⠀⠀⠀⠀⢠⢀⠀⠀⠀⠀⢀⡞⠀⠀⠀⠀⠀⡀⡄⢀⠀⠀⠀⢺⣄⡀⠈⣗⠀⠀"
        "⠀          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⣧⠹⣌⠀⠀⠀⠀⠀⠀⢿⡀⠀⠈⠀⠀⠀⠀⣄⣞⣼⠁⠀⠀⠀⢸⡇⠀⠀⠀⡀⡴⣸⠿⣮⡓⠄⠀⠀⠀⢀⣼⠃⠀⠀"
        "⠀⠀          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣤⣑⠂⠀⠀⢀⣠⠞⠷⣤⣀⠀⠀⢀⣈⣬⠞⠉⠳⠶⠴⠶⠛⠳⢤⣄⣈⣽⠶⠋⠀⠀⠙⠛⠒⠒⠚⠋⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀          ⠀⠀⠀⠀⠈⠉⠙⠛⠛⠉⠁⠀⠀⠀⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
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
    echo -e "\t\t\t\t\t\t\t\t        http://cloudwerx.dev${N}"
    echo ""
    echo -e "${BG}                              👋 Thanks for using Comfy Launcher !${N}"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    sleep 0.5
}

is_running() {
    local port=$(get_port_from_args)
    lsof -i :$port -sTCP:LISTEN >/dev/null 2>&1
}

get_pid() {
    local port=$(get_port_from_args)
    lsof -t -i :$port -sTCP:LISTEN 2>/dev/null | head -1
}

kill_server() {
    local pid=$(get_pid)
    local port=$(get_port_from_args)
    if [[ -n "$pid" ]]; then
        echo -e "${Y}⏹  Killing server (PID: $pid)...${N}"
        kill "$pid" 2>/dev/null && echo -e "${G}✓ Server stopped${N}" || echo -e "${R}✗ Failed${N}"
        sleep 1
    else
        echo -e "${R}No server running on port $port${N}"
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
    local output=$(git pull --ff-only 2>&1 | tee /tmp/comfy_update.log)
    if echo "$output" | grep -q "Already up to date"; then
        echo -e "${G}✓ Already up to date${N}"
    elif echo "$output" | grep -q "Updating"; then
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
        
        for node_path in "$nodes_dir"/* "$nodes_dir"/*.disabled; do
            [[ ! -e "$node_path" ]] && continue
            [[ ! -d "$node_path" ]] && continue
            local node_name=$(basename "$node_path")
            [[ "$node_name" == "__pycache__" ]] && continue
            [[ "$node_name" == "*.disabled" ]] && continue
            
            local is_disabled=false
            [[ "$node_path" == *.disabled ]] && is_disabled=true
            
            local display_name="$node_name"
            local version=""
            local desc=""
            local repo_url=""
            
            if [[ -f "$node_path/pyproject.toml" ]]; then
                display_name=$(grep -m1 '^DisplayName' "$node_path/pyproject.toml" 2>/dev/null | cut -d'"' -f2 || echo "${node_name%.disabled}")
                version=$(grep -m1 '^version' "$node_path/pyproject.toml" 2>/dev/null | cut -d'"' -f2)
                desc=$(grep -m1 '^description' "$node_path/pyproject.toml" 2>/dev/null | cut -d'"' -f2 | sed 's/\\n/ /g' | sed 's/  */ /g')
                repo_url=$(grep -m1 '^Repository' "$node_path/pyproject.toml" 2>/dev/null | cut -d'"' -f2)
            fi
            
            nodes+=("$node_path")
            
            local status_icon="${G}●${N}"
            local name_color="$Y"
            if $is_disabled; then
                status_icon="${R}○${N}"
                name_color="$GR"
            fi
            
            echo -e "\e[38;5;39m$i.${N} $status_icon ${name_color}$display_name${N} ${GR}${version:+v$version}${N}"
            if [[ -n "$desc" ]]; then
                while IFS= read -r line; do
                    echo -e "     \e[38;5;39m$line${N}"
                done < <(echo "$desc" | fold -s -w 77)
            fi
            [[ -n "$repo_url" ]] && echo -e "     ${C}🔗 $repo_url${N}"
            echo ""
            ((i++))
        done
        
        divider
        echo -e "${BG}A.${N} ${W}Update All Active Nodes${N}"
        echo -e "${Y}U.${N} ${W}Update ComfyUI${N}"
        echo -e "${R}0.${N} ${W}Back to Main Menu${N}"
        echo ""
        echo -e "\e[38;5;39mEnter a Node number for options:${N}"
        echo -ne "\e[38;5;39m➜\e[0m${N} ${W}Select option:${N} "
        read -r choice
        
        case "$choice" in
            [0]) return ;;
            [Aa])
                echo ""
                for node_path in "${nodes[@]}"; do
                    [[ "$node_path" == *.disabled ]] && continue
                    local name=$(basename "$node_path")
                    echo -e "${Y}Updating $name...${N}"
                    cd "$node_path" && git pull --ff-only 2>&1 | grep -E "(Already|Updating|error)" || echo -e "${GR}  No git repo${N}"
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
                    local node_path="${nodes[$((choice-1))]}"
                    local name=$(basename "$node_path")
                    
                    # Get node details from pyproject.toml
                    local version="" desc="" repo_url="" publisher="" display_name="" icon="" project_name=""
                    if [[ -f "$node_path/pyproject.toml" ]]; then
                        # Create temp Python script to avoid shell escaping issues
                        cat > /tmp/parse_toml_$$.py << 'PYEOF'
import sys, re
try:
    with open(sys.argv[1], 'r') as f:
        content = f.read()
    
    fields = {}
    fields['name'] = re.search(r'^name\s*=\s*"([^"]+)"', content, re.M)
    fields['version'] = re.search(r'^version\s*=\s*"([^"]+)"', content, re.M)
    fields['desc'] = re.search(r'description\s*=\s*"((?:[^"\\]|\\.)*)"', content, re.DOTALL)
    fields['repo'] = re.search(r'Repository\s*=\s*"([^"]+)"', content)
    fields['pub'] = re.search(r'PublisherId\s*=\s*"([^"]+)"', content)
    fields['disp'] = re.search(r'DisplayName\s*=\s*"([^"]+)"', content)
    fields['icon'] = re.search(r'Icon\s*=\s*"([^"]+)"', content)
    
    for key in ['name', 'version', 'desc', 'repo', 'pub', 'disp', 'icon']:
        if fields[key]:
            val = fields[key].group(1)
            if key == 'desc':
                val = val.replace('\\n', ' ').replace('\\"', '"').strip()
            print(val, end='\0')
        else:
            print('', end='\0')
except:
    for i in range(7): print('', end='\0')
PYEOF
                        local i=0
                        while IFS= read -r -d '' field; do
                            case $i in
                                0) project_name="$field" ;;
                                1) version="$field" ;;
                                2) desc="$field" ;;
                                3) repo_url="$field" ;;
                                4) publisher="$field" ;;
                                5) display_name="$field" ;;
                                6) icon="$field" ;;
                            esac
                            ((i++))
                        done < <(python3 /tmp/parse_toml_$$.py "$node_path/pyproject.toml" 2>/dev/null)
                        rm -f /tmp/parse_toml_$$.py
                    fi
                    # Fallback to git remote if no repo in pyproject
                    if [[ -z "$repo_url" && -d "$node_path/.git" ]]; then
                        repo_url=$(cd "$node_path" && git remote get-url origin 2>/dev/null)
                    fi
                    
                    clear
                    show_header
                    echo -e "${W}MANAGE: ${Y}${name%.disabled}${N}"
                    divider
                    echo ""
                    
                    # Display icon at the top if available
                    if [[ -n "$icon" ]]; then
                        if [[ "$icon" =~ ^https?:// ]]; then
                            # Try to display image
                            if command -v curl &>/dev/null; then
                                local tmp_icon="/tmp/node_icon_$$.png"
                                curl -s "$icon" -o "$tmp_icon" 2>/dev/null
                                if [[ -f "$tmp_icon" ]]; then
                                    if [[ "$TERM" == "xterm-kitty" ]]; then
                                        kitty +kitten icat --align left --scale-up "$tmp_icon" 2>/dev/null
                                    elif command -v chafa &>/dev/null; then
                                        chafa -s 40x20 "$tmp_icon" 2>/dev/null
                                    elif command -v jp2a &>/dev/null; then
                                        jp2a --width=60 "$tmp_icon" 2>/dev/null
                                    fi
                                    rm -f "$tmp_icon"
                                fi
                            fi
                            echo -e "  \e[38;5;33m🎨 Icon URL:\e[0m ${BC}$icon${N}"
                            echo ""
                        fi
                    fi
                    
                    [[ -n "$display_name" ]] && echo -e "  \e[38;5;33m📛 Display Name:\e[0m ${W}$display_name${N}"
                    [[ -n "$project_name" ]] && echo -e "  \e[38;5;33m📦 Project Name:\e[0m ${C}$project_name${N}"
                    [[ -n "$version" ]] && echo -e "  \e[38;5;33m🔢 Version:\e[0m ${C}$version${N}"
                    [[ -n "$publisher" ]] && echo -e "  \e[38;5;33m👤 Publisher:\e[0m ${M}$publisher${N}"
                    [[ -n "$desc" ]] && echo -e "  \e[38;5;33m📝 Description:\e[0m ${GR}$desc${N}"
                    [[ -n "$repo_url" ]] && echo -e "  \e[38;5;33m🔗 Repository:\e[0m ${BC}$repo_url${N}"
                    echo ""
                    echo -e "${G}U.${N} ${W}Update Node${N}"
                    echo -e "${C}T.${N} ${W}Toggle On/Off${N}"
                    echo -e "${Y}I.${N} ${W}Install Dependencies (requirements.txt)${N}"
                    echo -e "${R}D.${N} ${W}Delete Node${N}"
                    echo -e "${GR}0.${N} ${W}Back${N}"
                    echo ""
                    echo -ne "\e[38;5;33m➜\e[0m \e[38;5;27mAction:\e[0m "
                    read -r action
                    
                    case "$action" in
                        [Uu])
                            echo ""
                            echo -e "${Y}Updating ${name%.disabled}...${N}"
                            cd "$node_path" && git pull --ff-only || echo -e "${R}✗ Update failed${N}"
                            echo ""
                            read -p "Press Enter to continue..."
                            ;;
                        [Tt])
                            if [[ "$node_path" == *.disabled ]]; then
                                mv "$node_path" "${node_path%.disabled}"
                                echo -e "${G}✓ Node enabled${N}"
                            else
                                mv "$node_path" "$node_path.disabled"
                                echo -e "${Y}✓ Node disabled${N}"
                            fi
                            sleep 1
                            ;;
                        [Ii])
                            if [[ -f "$node_path/requirements.txt" ]]; then
                                echo ""
                                echo -e "${Y}Installing dependencies...${N}"
                                source "$VENV_PATH/bin/activate"
                                pip install -r "$node_path/requirements.txt"
                                echo ""
                                read -p "Press Enter to continue..."
                            else
                                echo -e "${R}✗ No requirements.txt found${N}"
                                sleep 2
                            fi
                            ;;
                        [Dd])
                            echo ""
                            echo -e "${R}⚠ WARNING: This will permanently delete ${name%.disabled}${N}"
                            echo -ne "${Y}Type 'DELETE' to confirm:${N} "
                            read -r confirm
                            if [[ "$confirm" == "DELETE" ]]; then
                                rm -rf "$node_path"
                                echo -e "${G}✓ Node deleted${N}"
                                sleep 1
                            else
                                echo -e "${GR}Cancelled${N}"
                                sleep 1
                            fi
                            ;;
                    esac
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
    
    # Start server and capture output
    > /tmp/comfy_launch_output.log
    python main.py $LAUNCH_ARGS >> /tmp/comfy_launch_output.log 2>&1 &
    local pid=$!
    local tunnel_pid=""
    local tunnel_url=""
    local tunnel_status=""
    local tunnel_type=""  # Track which tunnel was requested
    local server_url=""
    
    # Clear screen before showing logs
    sleep 1
    clear
    
    # Draw fixed footer at bottom
    draw_footer() {
        local rows=$(tput lines)
        local footer_lines=2
        [[ -n "$tunnel_url" || -n "$tunnel_status" ]] && footer_lines=4
        
        # Position at footer area
        tput cup $((rows - footer_lines)) 0
        
        # Determine tunnel type label
        local tunnel_label="CLOUDFLARE TUNNEL"
        [[ "$tunnel_type" == "pinggy" ]] && tunnel_label="PINGGY TUNNEL"
        
        # Draw tunnel section if active or waiting
        if [[ -n "$tunnel_url" ]]; then
            echo -e "\e[38;5;33m╭─[\e[0m \e[38;5;39m☁️  $tunnel_label\e[38;5;33m ]──────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;33m│\e[0m ${Y}$tunnel_url${N}"
            echo -e "\e[38;5;27m├────────────────────────────────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;27m│\e[0m \e[38;5;33mT\e[0m=Tunnel \e[38;5;33mP\e[0m=Pinggy ${Y}K${N}=Kill ${G}S${N}=Save \e[38;5;27mM\e[0m=Menu ${M}E${N}=Exit \e[38;5;240m| PID: ${R}$pid${N}"
        elif [[ -n "$tunnel_status" ]]; then
            echo -e "\e[38;5;33m╭─[\e[0m \e[38;5;39m☁️  $tunnel_label\e[38;5;33m ]──────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;33m│\e[0m ${Y}$tunnel_status${N}"
            echo -e "\e[38;5;27m├────────────────────────────────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;27m│\e[0m \e[38;5;33mT\e[0m=Tunnel \e[38;5;33mP\e[0m=Pinggy ${Y}K${N}=Kill ${G}S${N}=Save \e[38;5;27mM\e[0m=Menu ${M}E${N}=Exit \e[38;5;240m| PID: ${R}$pid${N}"
        else
            echo -e "\e[38;5;33m╭────────────────────────────────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;27m│\e[0m \e[38;5;33mT\e[0m=Tunnel \e[38;5;33mP\e[0m=Pinggy ${Y}K${N}=Kill ${G}S${N}=Save \e[38;5;27mM\e[0m=Menu ${M}E${N}=Exit \e[38;5;240m| PID: ${R}$pid${N}"
        fi
    }
    
    # Handle footer commands
    handle_command() {
        case "$1" in
            t|T)
                if [[ -z "$tunnel_pid" ]]; then
                    tunnel_type="cloudflare"
                    # Check if server is ready
                    if [[ -z "$server_url" ]]; then
                        tunnel_status="⏳ Waiting for server to start..."
                        footer_lines=4
                        local rows=$(tput lines)
                        tput csr $header_lines $((rows - footer_lines - 1))
                        draw_footer
                        return 0
                    fi
                    
                    if ! command -v cloudflared &>/dev/null; then
                        if command -v apt &>/dev/null; then
                            curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloudflare-main.gpg 2>&1 | grep -v "^$"
                            echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/ focal main' | sudo tee /etc/apt/sources.list.d/cloudflare-main.list >/dev/null
                            sudo apt update >/dev/null 2>&1 && sudo apt install -y cloudflared >/dev/null 2>&1
                        fi
                        if ! command -v cloudflared &>/dev/null; then
                            return 0
                        fi
                    fi
                    
                    tunnel_status="⏳ Digging tunnel, please wait..."
                    draw_footer
                    
                    > /tmp/comfy_tunnel.log
                    cloudflared tunnel --url "$server_url" >> /tmp/comfy_tunnel.log 2>&1 &
                    tunnel_pid=$!
                    
                    # Wait for tunnel URL
                    local attempts=0
                    while [[ $attempts -lt 20 ]]; do
                        tunnel_url=$(grep -oP "https://[a-z0-9-]+\.trycloudflare\.com" /tmp/comfy_tunnel.log 2>/dev/null | head -1)
                        [[ -n "$tunnel_url" ]] && break
                        sleep 0.5
                        ((attempts++))
                    done
                    
                    tunnel_status=""
                    if [[ -n "$tunnel_url" ]]; then
                        draw_footer
                    else
                        footer_lines=2
                        local rows=$(tput lines)
                        tput csr $header_lines $((rows - footer_lines - 1))
                        kill $tunnel_pid 2>/dev/null
                        tunnel_pid=""
                        draw_footer
                    fi
                fi
                ;;
            p|P)
                if [[ -z "$tunnel_pid" ]]; then
                    tunnel_type="pinggy"
                    if [[ -z "$server_url" ]]; then
                        tunnel_status="⏳ Waiting for server to start..."
                        footer_lines=4
                        local rows=$(tput lines)
                        tput csr $header_lines $((rows - footer_lines - 1))
                        draw_footer
                        return 0
                    fi
                    
                    if ! command -v ssh &>/dev/null; then
                        return 0
                    fi
                    
                    tunnel_status="⏳ Starting Pinggy tunnel..."
                    draw_footer
                    
                    > /tmp/comfy_pinggy.log
                    echo "yes" | ssh -p 443 -R0:localhost:${server_url##*:} qr@free.pinggy.io >> /tmp/comfy_pinggy.log 2>&1 &
                    tunnel_pid=$!
                    
                    # Wait for tunnel URL
                    local attempts=0
                    while [[ $attempts -lt 20 ]]; do
                        tunnel_url=$(grep -oP "https?://[a-z0-9-]+\.a\.free\.pinggy\.link" /tmp/comfy_pinggy.log 2>/dev/null | head -1)
                        [[ -n "$tunnel_url" ]] && break
                        sleep 0.5
                        ((attempts++))
                    done
                    
                    tunnel_status=""
                    if [[ -n "$tunnel_url" ]]; then
                        tunnel_url="$tunnel_url ${GR}(60min free)${N}"
                        draw_footer
                    else
                        footer_lines=2
                        local rows=$(tput lines)
                        tput csr $header_lines $((rows - footer_lines - 1))
                        kill $tunnel_pid 2>/dev/null
                        tunnel_pid=""
                        draw_footer
                    fi
                fi
                ;;
            k|K)
                local rows=$(tput lines)
                tput cup $((rows - footer_lines - 2)) 0
                echo -e "${Y}⏹  Stopping server...${N}"
                kill $pid 2>/dev/null
                [[ -n "$tunnel_pid" ]] && kill $tunnel_pid 2>/dev/null
                sleep 1
                [[ $(kill -0 $pid 2>/dev/null) ]] && kill -9 $pid 2>/dev/null
                return 1
                ;;
            s|S)
                local rows=$(tput lines)
                tput cup $((rows - footer_lines - 2)) 0
                local logfile="comfy_$(date +%Y%m%d_%H%M%S).log"
                cp /tmp/comfy_launch_output.log "$COMFY_PATH/$logfile"
                echo -e "${G}✓ Logs saved: $COMFY_PATH/$logfile${N}"
                ;;
            m|M)
                local rows=$(tput lines)
                tput cup $((rows - footer_lines - 2)) 0
                echo -e "${C}↩  Returning to menu (server still running)...${N}"
                if [[ -n "$tunnel_pid" ]]; then
                    echo -e "${Y}⚠ Stopping tunnel...${N}"
                    kill $tunnel_pid 2>/dev/null
                    tunnel_pid=""
                    tunnel_url=""
                fi
                return 1
                ;;
            e|E)
                local rows=$(tput lines)
                tput cup $((rows - footer_lines - 2)) 0
                echo -e "${P}👋 Exiting (server still running)...${N}"
                if [[ -n "$tunnel_pid" ]]; then
                    echo -e "${Y}⚠ Stopping tunnel...${N}"
                    kill $tunnel_pid 2>/dev/null
                fi
                exit 0
                ;;
        esac
    }
    
    # Set up cleanup trap
    cleanup_server() {
        tput csr 0 $(tput lines)  # Reset scroll region
        tput cnorm  # Show cursor
        kill $pid 2>/dev/null
        [[ -n "$tunnel_pid" ]] && kill $tunnel_pid 2>/dev/null
        sleep 1
        [[ $(kill -0 $pid 2>/dev/null) ]] && kill -9 $pid 2>/dev/null
        exit 0
    }
    trap cleanup_server INT TERM EXIT
    
    # Show header at top
    show_header
    
    # Set up scroll region (leave space for footer)
    local rows=$(tput lines)
    local footer_lines=2
    local header_lines=7  # Lines used by header
    tput csr $header_lines $((rows - footer_lines - 1))  # Scroll between header and footer
    tput cup $header_lines 0  # Move cursor to start of scroll region
    
    # Monitor output and handle input
    local browser_launched=false
    local last_line=0
    tput civis  # Hide cursor
    
    # Draw initial footer
    draw_footer
    
    while kill -0 "$pid" 2>/dev/null; do
        # Show new output lines
        local current_lines=$(wc -l < /tmp/comfy_launch_output.log 2>/dev/null || echo 0)
        if [ $current_lines -gt $last_line ]; then
            tput cup $((rows - footer_lines - 1)) 0  # Position at bottom of scroll region
            tail -n +$((last_line + 1)) /tmp/comfy_launch_output.log
            last_line=$current_lines
            draw_footer  # Redraw footer after output
        fi
        
        # Check for ready message and launch browser
        if ! $browser_launched && grep -q "To see the GUI go to:" /tmp/comfy_launch_output.log 2>/dev/null; then
            local detected_url=$(grep -oP "http://[0-9.:]+(?=\s|$)" /tmp/comfy_launch_output.log | head -1)
            
            # Extract port and create proper URLs
            local port=$(echo "$detected_url" | grep -oP ':\K\d+')
            server_url="http://127.0.0.1:$port"  # For cloudflared
            local browser_url="$detected_url"     # For browser (can be 0.0.0.0)
            
            # Auto-start tunnel if user pressed T or P while waiting
            if [[ -n "$tunnel_status" && -z "$tunnel_pid" ]]; then
                if [[ "$tunnel_type" == "pinggy" ]]; then
                    handle_command "p"
                else
                    handle_command "t"
                fi
            fi
            
            if [[ -n "$browser_url" ]]; then
                echo -e "${G}✓ Server ready!${N}"
                
                if command -v google-chrome &>/dev/null; then
                    google-chrome "$browser_url" &>/dev/null &
                    echo -e "${G}🌐 Opened browser${N}"
                elif command -v chromium &>/dev/null; then
                    chromium "$browser_url" &>/dev/null &
                    echo -e "${G}🌐 Opened browser${N}"
                elif command -v firefox &>/dev/null; then
                    firefox "$browser_url" &>/dev/null &
                    echo -e "${G}🌐 Opened browser${N}"
                fi
                
                browser_launched=true
                draw_footer
            fi
        fi
        
        # Check for key input with timeout
        if read -rsn1 -t 0.2 key 2>/dev/null; then
            handle_command "$key" || break
        fi
    done
    
    tput csr 0 $(tput lines)  # Reset scroll region
    tput cnorm  # Show cursor
    
    # Check if server failed
    if grep -q "ImportError.*folder_paths" /tmp/comfy_launch_output.log 2>/dev/null; then
        echo -e "\n${R}✗ Failed to start${N}\n"
        echo -e "${Y}⚠ Dependencies issue detected${N}"
        echo -e "${W}Fix by reinstalling requirements:${N}"
        echo -e "  ${C}cd $COMFY_PATH/ComfyUI${N}"
        echo -e "  ${C}source $VENV_PATH/bin/activate${N}"
        echo -e "  ${C}pip install -r requirements.txt${N}"
        echo ""
        read -p "Press Enter to continue..."
        return 1
    fi
}

tunnel_cloudflare() {
    local port=$(get_port_from_args)
    
    # Check if server is running
    if ! is_running; then
        echo -e "${R}✗ Server not running. Start server first (option 1)${N}"
        sleep 2
        return 1
    fi
    
    if ! command -v cloudflared &>/dev/null; then
        echo -e "${Y}⚠ cloudflared not installed${N}"
        echo -e "${W}Installing cloudflared...${N}\n"
        
        if command -v apt &>/dev/null; then
            curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloudflare-main.gpg
            echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/ focal main' | sudo tee /etc/apt/sources.list.d/cloudflare-main.list
            sudo apt update && sudo apt install -y cloudflared
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y cloudflared
        elif command -v yum &>/dev/null; then
            sudo yum install -y cloudflared
        else
            echo -e "${R}✗ Could not detect package manager${N}"
            echo -e "${Y}Install manually: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/${N}"
            return 1
        fi
        
        if ! command -v cloudflared &>/dev/null; then
            echo -e "${R}✗ Installation failed${N}"
            return 1
        fi
    fi
    
    clear
    show_header
    
    > /tmp/comfy_tunnel.log
    stdbuf -oL cloudflared tunnel --url "http://localhost:$port" >> /tmp/comfy_tunnel.log 2>&1 &
    local tunnel_pid=$!
    local tunnel_url=""
    
    # Draw footer
    draw_tunnel_footer() {
        local rows=$(tput lines)
        local footer_lines=2
        [[ -n "$tunnel_url" ]] && footer_lines=4
        
        tput cup $((rows - footer_lines)) 0
        
        if [[ -n "$tunnel_url" ]]; then
            echo -e "\e[38;5;33m╭─[\e[0m \e[38;5;39m☁️  CLOUDFLARE TUNNEL\e[38;5;33m ]──────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;33m│\e[0m ${G}$tunnel_url${N}"
            echo -e "\e[38;5;27m├────────────────────────────────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;27m│\e[0m \e[38;5;33mN\e[0m=New ${G}S${N}=Save \e[38;5;27mM\e[0m=Menu ${M}Q${N}=Quit \e[38;5;240m| PID: ${R}$tunnel_pid${N}"
        else
            echo -e "\e[38;5;33m╭────────────────────────────────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;27m│\e[0m \e[38;5;33mN\e[0m=New ${G}S${N}=Save \e[38;5;27mM\e[0m=Menu ${M}Q${N}=Quit \e[38;5;240m| PID: ${R}$tunnel_pid${N}"
        fi
    }
    
    # Handle commands
    handle_tunnel_command() {
        case "$1" in
            n|N)
                kill $tunnel_pid 2>/dev/null
                tunnel_cloudflare
                return 1
                ;;
            s|S)
                local logfile="tunnel_cf_$(date +%Y%m%d_%H%M%S).log"
                cp /tmp/comfy_tunnel.log "$COMFY_PATH/$logfile"
                local rows=$(tput lines)
                tput cup $((rows - 3)) 0
                echo -e "${G}✓ Logs saved: $COMFY_PATH/$logfile${N}"
                ;;
            m|M)
                kill $tunnel_pid 2>/dev/null
                return 1
                ;;
            q|Q)
                kill $tunnel_pid 2>/dev/null
                exit 0
                ;;
        esac
    }
    
    trap "kill $tunnel_pid 2>/dev/null; exit 0" INT TERM EXIT
    
    local rows=$(tput lines)
    local footer_lines=2
    local header_lines=7
    tput csr $header_lines $((rows - footer_lines - 1))
    tput cup $header_lines 0
    tput civis
    
    draw_tunnel_footer
    
    local last_line=0
    while kill -0 "$tunnel_pid" 2>/dev/null; do
        local current_lines=$(wc -l < /tmp/comfy_tunnel.log 2>/dev/null || echo 0)
        if [ $current_lines -gt $last_line ]; then
            tput cup $((rows - footer_lines - 1)) 0
            tail -n +$((last_line + 1)) /tmp/comfy_tunnel.log
            last_line=$current_lines
            
            if [[ -z "$tunnel_url" ]]; then
                tunnel_url=$(grep -oP "https://[a-z0-9-]+\.trycloudflare\.com" /tmp/comfy_tunnel.log 2>/dev/null | head -1)
                [[ -n "$tunnel_url" ]] && footer_lines=4 && tput csr $header_lines $((rows - footer_lines - 1))
            fi
            
            draw_tunnel_footer
        fi
        
        if read -rsn1 -t 0.2 key 2>/dev/null; then
            handle_tunnel_command "$key" || break
        fi
    done
    
    tput csr 0 $(tput lines)
    tput cnorm
}

tunnel_pinggy() {
    local port=$(get_port_from_args)
    
    if ! is_running; then
        echo -e "${R}✗ Server not running. Start server first (option 1)${N}"
        sleep 2
        return 1
    fi
    
    if ! command -v ssh &>/dev/null; then
        echo -e "${R}✗ SSH required${N}"
        return 1
    fi
    
    clear
    show_header
    
    > /tmp/comfy_pinggy.log
    echo "yes" | stdbuf -oL ssh -p 443 -R0:localhost:$port qr@free.pinggy.io >> /tmp/comfy_pinggy.log 2>&1 &
    local tunnel_pid=$!
    local tunnel_url=""
    
    draw_tunnel_footer() {
        local rows=$(tput lines)
        local footer_lines=2
        [[ -n "$tunnel_url" ]] && footer_lines=4
        
        tput cup $((rows - footer_lines)) 0
        
        if [[ -n "$tunnel_url" ]]; then
            echo -e "\e[38;5;33m╭─[\e[0m \e[38;5;39m🌐 PINGGY TUNNEL\e[38;5;33m ]──────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;33m│\e[0m ${G}$tunnel_url ${GR}(60min free)${N}"
            echo -e "\e[38;5;27m├────────────────────────────────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;27m│\e[0m \e[38;5;33mN\e[0m=New ${G}S${N}=Save \e[38;5;27mM\e[0m=Menu ${M}Q${N}=Quit \e[38;5;240m| PID: ${R}$tunnel_pid${N}"
        else
            echo -e "\e[38;5;33m╭────────────────────────────────────────────────────────────────────────────────────>${N}"
            echo -e "\e[38;5;27m│\e[0m \e[38;5;33mN\e[0m=New ${G}S${N}=Save \e[38;5;27mM\e[0m=Menu ${M}Q${N}=Quit \e[38;5;240m| PID: ${R}$tunnel_pid${N}"
        fi
    }
    
    handle_tunnel_command() {
        case "$1" in
            n|N)
                kill $tunnel_pid 2>/dev/null
                tunnel_pinggy
                return 1
                ;;
            s|S)
                local logfile="tunnel_pinggy_$(date +%Y%m%d_%H%M%S).log"
                cp /tmp/comfy_pinggy.log "$COMFY_PATH/$logfile"
                local rows=$(tput lines)
                tput cup $((rows - 3)) 0
                echo -e "${G}✓ Logs saved: $COMFY_PATH/$logfile${N}"
                ;;
            m|M)
                kill $tunnel_pid 2>/dev/null
                return 1
                ;;
            q|Q)
                kill $tunnel_pid 2>/dev/null
                exit 0
                ;;
        esac
    }
    
    trap "kill $tunnel_pid 2>/dev/null; exit 0" INT TERM EXIT
    
    local rows=$(tput lines)
    local footer_lines=2
    local header_lines=7
    tput csr $header_lines $((rows - footer_lines - 1))
    tput cup $header_lines 0
    tput civis
    
    draw_tunnel_footer
    
    local last_line=0
    while kill -0 "$tunnel_pid" 2>/dev/null; do
        local current_lines=$(wc -l < /tmp/comfy_pinggy.log 2>/dev/null || echo 0)
        if [ $current_lines -gt $last_line ]; then
            tput cup $((rows - footer_lines - 1)) 0
            tail -n +$((last_line + 1)) /tmp/comfy_pinggy.log
            last_line=$current_lines
            
            if [[ -z "$tunnel_url" ]]; then
                tunnel_url=$(grep -oP "https?://[a-z0-9-]+\.a\.free\.pinggy\.link" /tmp/comfy_pinggy.log 2>/dev/null | head -1)
                [[ -n "$tunnel_url" ]] && footer_lines=4 && tput csr $header_lines $((rows - footer_lines - 1))
            fi
            
            draw_tunnel_footer
        fi
        
        if read -rsn1 -t 0.2 key 2>/dev/null; then
            handle_tunnel_command "$key" || break
        fi
    done
    
    tput csr 0 $(tput lines)
    tput cnorm
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
    echo -e "\e[38;5;39mEnter ComfyUI root path (containing ComfyUI/ folder):${N}"
    echo -e "${Y}Example: /home/user/Desktop/Servers/comfy${N}"
    read -r new_path
    if [[ -n "$new_path" ]]; then
        new_path=$(realpath "$new_path" 2>/dev/null || echo "$new_path")
        # If user selected the ComfyUI folder itself, go up one level
        if [[ "$(basename "$new_path")" == "ComfyUI" ]]; then
            new_path=$(dirname "$new_path")
        fi
        COMFY_PATH="$new_path"
        save_config
    fi
}

set_venv() {
    echo -e "${C}Enter venv path:${N}"
    echo -e "${Y}Example: /home/user/Desktop/Servers/comfy/venv${N}"
    echo -e "\e[38;5;39mLeave empty to use default (COMFY_PATH/venv)${N}"
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
    echo -e "${W}Current:${N} \e[38;5;39m$LAUNCH_ARGS${N}\n"
    
    echo -e "${BG}NETWORK${N}"
    echo -e "  \e[38;5;39m--listen 0.0.0.0${N}              ${GR}Listen on all interfaces (default: 127.0.0.1)${N}"
    echo -e "  \e[38;5;39m--port 8188${N}                   ${GR}Set port number (default: 8188)${N}"
    echo -e "  \e[38;5;39m--enable-cors-header${N}          ${GR}Enable CORS${N}"
    
    echo -e "\n${BG}VRAM MODES${N} ${GR}(mutually exclusive)${N}"
    echo -e "  \e[38;5;39m--gpu-only${N}                    ${GR}Keep everything on GPU${N}"
    echo -e "  \e[38;5;39m--highvram${N}                    ${GR}Keep models in GPU (24GB+)${N}"
    echo -e "  \e[38;5;39m--normalvram${N}                  ${GR}Normal VRAM usage (8-16GB)${N}"
    echo -e "  \e[38;5;39m--lowvram${N}                     ${GR}Split unet for less VRAM (4-6GB)${N}"
    echo -e "  \e[38;5;39m--novram${N}                      ${GR}Minimal VRAM mode${N}"
    echo -e "  \e[38;5;39m--cpu${N}                         ${GR}CPU only (slow)${N}"
    
    echo -e "\n${BG}ATTENTION${N} ${GR}(mutually exclusive)${N}"
    echo -e "  \e[38;5;39m--use-split-cross-attention${N}   ${GR}Split cross attention${N}"
    echo -e "  \e[38;5;39m--use-quad-cross-attention${N}    ${GR}Sub-quadratic attention (recommended)${N}"
    echo -e "  \e[38;5;39m--use-pytorch-cross-attention${N} ${GR}PyTorch 2.0 attention${N}"
    echo -e "  \e[38;5;39m--use-sage-attention${N}          ${GR}Sage attention${N}"
    echo -e "  \e[38;5;39m--use-flash-attention${N}         ${GR}Flash attention${N}"
    
    echo -e "\n${BG}PRECISION - UNET${N} ${GR}(mutually exclusive)${N}"
    echo -e "  \e[38;5;39m--fp16-unet${N}                   ${GR}FP16 diffusion model${N}"
    echo -e "  \e[38;5;39m--bf16-unet${N}                   ${GR}BF16 diffusion model${N}"
    echo -e "  \e[38;5;39m--fp8_e4m3fn-unet${N}             ${GR}FP8 E4M3FN weights${N}"
    echo -e "  \e[38;5;39m--fp8_e5m2-unet${N}               ${GR}FP8 E5M2 weights${N}"
    
    echo -e "\n${BG}PRECISION - VAE${N} ${GR}(mutually exclusive)${N}"
    echo -e "  \e[38;5;39m--fp16-vae${N}                    ${GR}FP16 VAE (faster, may cause black images)${N}"
    echo -e "  \e[38;5;39m--fp32-vae${N}                    ${GR}FP32 VAE (full precision)${N}"
    echo -e "  \e[38;5;39m--bf16-vae${N}                    ${GR}BF16 VAE${N}"
    echo -e "  \e[38;5;39m--cpu-vae${N}                     ${GR}Run VAE on CPU${N}"
    
    echo -e "\n${BG}PRECISION - TEXT ENCODER${N} ${GR}(mutually exclusive)${N}"
    echo -e "  \e[38;5;39m--fp8_e4m3fn-text-enc${N}         ${GR}FP8 E4M3FN text encoder${N}"
    echo -e "  \e[38;5;39m--fp8_e5m2-text-enc${N}           ${GR}FP8 E5M2 text encoder${N}"
    echo -e "  \e[38;5;39m--fp16-text-enc${N}               ${GR}FP16 text encoder${N}"
    
    echo -e "\n${BG}MEMORY${N}"
    echo -e "  \e[38;5;39m--cuda-malloc${N}                 ${GR}Enable cudaMallocAsync${N}"
    echo -e "  \e[38;5;39m--disable-smart-memory${N}        ${GR}Aggressive RAM offload${N}"
    echo -e "  \e[38;5;39m--reserve-vram 2${N}              ${GR}Reserve VRAM in GB for OS${N}"
    
    echo -e "\n${BG}CACHE${N} ${GR}(mutually exclusive)${N}"
    echo -e "  \e[38;5;39m--cache-classic${N}               ${GR}Aggressive caching${N}"
    echo -e "  \e[38;5;39m--cache-lru 10${N}                ${GR}LRU cache (N results)${N}"
    
    echo -e "\n${BG}PREVIEW${N}"
    echo -e "  \e[38;5;39m--preview-method auto${N}         ${GR}auto/latent2rgb/taesd/none${N}"
    
    echo -e "\n${BG}OTHER${N}"
    echo -e "  \e[38;5;39m--auto-launch${N}                 ${GR}Open browser automatically${N}"
    echo -e "  \e[38;5;39m--multi-user${N}                  ${GR}Enable per-user storage${N}"
    echo -e "  \e[38;5;39m--verbose DEBUG${N}               ${GR}Logging level${N}"
    
    echo -e "\n${Y}Format:${N} ${GR}Separate with spaces${N}"
    echo -e "${Y}Example:${N} \e[38;5;39m--listen 0.0.0.0 --port 6057 --highvram --fp16-vae${N}\n"
    echo -e "\e[38;5;39mEnter new args (or Enter to keep):${N}"
    read -e -i "$LAUNCH_ARGS" new_args
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
    echo -e "  \e[38;5;39mcomfy_launch.sh${N}                ${GR}Interactive menu${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh start${N}          ${GR}Start server${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh update${N}         ${GR}Update ComfyUI${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh kill${N}           ${GR}Kill server${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh nodes${N}          ${GR}Manage custom nodes${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh update-nodes${N}   ${GR}Update all nodes${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh tunnel cf${N}      ${GR}Cloudflare tunnel${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh tunnel pinggy${N}  ${GR}Pinggy tunnel${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh path /dir${N}      ${GR}Set ComfyUI path${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh venv /dir${N}      ${GR}Set venv path${N}"
    echo -e "  \e[38;5;39mcomfy_launch.sh folder${N}         ${GR}Open folder${N}"
    echo ""
    echo -e "${W}LINKS:${N}"
    echo -e "  \e[38;5;39m🏠 https://cloudwerx.dev${N}                              ${GR}Homepage & Blog${N}"
    echo -e "  \e[38;5;39m📖 https://comfyanonymous.github.io/ComfyUI_examples/${N} ${GR}Official Examples & Workflows${N}"
    echo -e "  \e[38;5;39m📚 https://docs.comfy.org${N}                             ${GR}Official Documentation${N}"
    echo -e "  \e[38;5;39m🐙 https://github.com/comfyanonymous/ComfyUI${N}          ${GR}ComfyUI Source Code${N}"
    echo -e "  \e[38;5;39m💻 https://github.com/CLOUDWERX-DEV/comfy_launch${N}      ${GR}This Script (Report Issues)${N}"
    echo -e "  \e[38;5;39m🤗 https://huggingface.co/Comfy-Org${N}                   ${GR}Official Models & Resources${N}"
    echo -e "  \e[38;5;39m🎨 https://civitai.com${N}                                ${GR}Community Models & LoRAs${N}"
    echo ""
    echo -e "${W}SUPPORT:${N}"
    echo -e "  \e[38;5;39m☕ https://buymeacoffee.com/cloudwerxl3${N}               ${GR}Buy Me A Coffee (Donate)${N}"
    echo -e "  \e[38;5;39m💬 https://discord.gg/EQSBU5aK${N}                        ${GR}Discord Server (Help & Chat)${N}"
    echo -e "  \e[38;5;39m📧 mail@cloudwerx.dev${N}                                 ${GR}Email Contact${N}"
    echo ""
    echo -e "${W}TROUBLESHOOTING:${N}"
    echo -e "  ${R}✗${N} Port busy? \e[38;5;39mcomfy_launch.sh kill${N}"
    echo -e "  ${R}✗${N} No venv? \e[38;5;39mcd ComfyUI && python -m venv venv${N}"
    echo ""
    read -p "Press Enter to continue..."
}

show_menu() {
    show_header
    load_config
    
    rbox_top
    
    # Path with wrapping
    echo -e " ${B}📁${N} \e[38;5;39mPath:${N}"
    if [[ -z "$COMFY_PATH" ]] || ! validate_setup; then
        echo -e "   ${R}⚠  NO VALID COMFYUI PATH DETECTED${N}"
    else
        local display_path="$COMFY_PATH"
        # Show full path to ComfyUI folder if it exists
        if [[ -d "$COMFY_PATH/ComfyUI" ]]; then
            display_path="$COMFY_PATH/ComfyUI"
        fi
        echo "$display_path" | fold -s -w 75 | while IFS= read -r line; do
            echo -e "   ${C}$line${N}"
        done
    fi
    
    # Status
    local status="${R}⏹ STOPPED${N}"
    if [[ -n "$COMFY_PATH" ]] && validate_setup; then
        is_running && status="${G}🖥 RUNNING (PID: $(get_pid))${N}"
    fi
    echo -e " ${G}⚙${N}  \e[38;5;39mStatus:${N}"
    echo -e "   $status"
    
    # Args with wrapping
    echo -e " ${Y}⚡${N} \e[38;5;39mArgs:${N}"
    echo "$LAUNCH_ARGS" | fold -s -w 75 | while IFS= read -r line; do
        echo -e "   ${G}$line${N}"
    done
    
    # Venv with wrapping
    if [[ -n "$VENV_PATH" ]]; then
        echo -e " ${P}🐍${N} \e[38;5;39mVenv:${N}"
        echo "$VENV_PATH" | fold -s -w 75 | while IFS= read -r line; do
            echo -e "   ${P}$line${N}"
        done
    fi
    rbox_bottom
    echo ""
    
    echo -e "\e[38;5;27m<$(printf '─%.0s' {1..84})>${N}"
    rbox_line "${BG}1.${N} ${W}🚀 Launch ComfyUI${N} ${GR}(Ctrl+C to stop)${N}"
    rbox_line "${Y}2.${N} ${W}🔄 Update ComfyUI${N}"
    rbox_line "${BC}3.${N} ${W}📦 Manage Custom Nodes${N}"
    rbox_line "${R}4.${N} ${W}⏹  Kill Server${N} ${GR}(if running)${N}"
    rbox_line "${C}5.${N} ${W}✏️  Edit Launch Args${N}"
    rbox_line "${M}6.${N} ${W}☁️  Cloudflare Tunnel${N}"
    rbox_line "${C}7.${N} ${W}🌐 Pinggy Tunnel${N} ${GR}(60min free)${N}"
    rbox_line "${B}8.${N} ${W}📁 Open Folder${N}"
    rbox_line "${B}9.${N} ${W}⚙️  Set ComfyUI Path${N}"
    rbox_line "${P}V.${N} ${W}🐍 Set Venv Path${N} ${GR}(Python virtual environment)${N}"
    rbox_line "${W}H.${N} ${W}❓ Help & Links${N}"
    rbox_line "${R}0.${N} ${W}👋 Exit${N}"
    echo -e "\e[38;5;27m<$(printf '─%.0s' {1..84})>${N}"
    echo ""
    
    echo -ne "\e[38;5;39m➜\e[0m \e[38;5;39mSelect option:\e[0m "
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
