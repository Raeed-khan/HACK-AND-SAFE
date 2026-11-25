#!/bin/bash
##  ===================================================================
##  R-ATTACK-NET : ULTIMATE 3D EDITION v5.0 (PRO)
##  Lead Architect : RAEED KHAN (RHCSA | BBA UOB)
##  ===================================================================

set -o pipefail

# ==========================================
# SAFE EXIT TRAP (Ctrl+C & Exit Protection)
# ==========================================
cleanup_and_exit() {
    echo -e "\n\033[1;32m[+] Cleaning up session... Stay Invisible, Raeed.\033[0m"
    tput cnorm 2>/dev/null
    echo -e "\033[0m"
    exit 0
}
trap cleanup_and_exit INT TERM

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
BOLD='\033[1m'

# Global Variables
TARGET_IP=""
USERNAME=""
WORDLIST=""
REPORT_DIR="reports"
SESSION_ID="$(date +%Y%m%d_%H%M%S)"

# ==========================================
# LIGHTNING TYPING EFFECT
# ==========================================
type_lightning() {
    local text="$1"
    local color="$2"
    local delay="${3:-0.008}"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${color}${text:$i:1}${NC}"
        sleep "$delay"
    done
    echo ""
}

# ==========================================
# BANNER FUNCTION WITH 3D ASCII ART
# ==========================================
show_banner() {
    clear
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
    echo -e "${BLUE}[+] ======================================================= [+]${NC}"
    echo -e "${GREEN}[+] Framework : RAEED-SYSTEMS AUDIT SUITE v5.0 (PRO)      [+]${NC}"
    echo -e "${GREEN}[+] Lead      : Raeed Khan (RHCSA | BBA UOB)                [+]${NC}"
    echo -e "${CYAN}[+] Session   : ${SESSION_ID}                            [+]${NC}"
    echo -e "${BLUE}[+] ======================================================= [+]${NC}"
    echo -e ""
}

# ==========================================
# PRIVILEGE & ENVIRONMENT CHECK
# ==========================================
check_environment() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}[!] Tip: Running as non-root. Some scans/installs may prompt for sudo.${NC}"
    fi
}

# ==========================================
# SMART AUTO INSTALL & DIRECTORY SETUP
# ==========================================
install_dependencies() {
    type_lightning "[+] Verifying System Dependencies & Initializing Workspace..." "${CYAN}"

    mkdir -p "$REPORT_DIR"
    local tools=("hydra" "nmap" "openssh-client" "smbclient" "ftp" "gobuster")
    local missing=()

    for tool in "${tools[@]}"; do
        if ! dpkg -s "$tool" &> /dev/null; then
            missing+=("$tool")
        fi
    done

    if ! command -v xfreerdp3 &> /dev/null && ! command -v xfreerdp &> /dev/null; then
        if apt-cache show freerdp3-x11 &> /dev/null 2>&1; then
            missing+=("freerdp3-x11")
        else
            missing+=("freerdp2-x11")
        fi
    fi

    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${YELLOW}[!] Installing missing packages: ${missing[*]}${NC}"
        sudo apt update -y && sudo apt install -y "${missing[@]}"
    fi

    if [ ! -f "/usr/share/wordlists/rockyou.txt" ]; then
        echo -e "${YELLOW}[!] Wordlist rockyou.txt not found. Downloading...${NC}"
        sudo mkdir -p /usr/share/wordlists
        sudo wget -q --show-progress https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt -O /usr/share/wordlists/rockyou.txt || \
            echo -e "${RED}[-] Could not download rockyou.txt automatically.${NC}"
    fi

    type_lightning "[+] Workspace Ready! Reports folder: ./$REPORT_DIR" "${GREEN}"
    sleep 1
}

# ==========================================
# HELPER FUNCTIONS
# ==========================================
pause_screen() {
    read -p "$(echo -e ${YELLOW}"\nPress [Enter] to continue..."${NC})"
}

get_target_ip() {
    read -p "$(echo -e ${CYAN}"[?] Enter Target IP: "${NC})" TARGET_IP
    if [[ ! $TARGET_IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo -e "${RED}[-] Invalid IP Format!${NC}"
        return 1
    fi
    return 0
}

get_wordlist() {
    read -p "$(echo -e ${CYAN}"[?] Wordlist Path [Default: /usr/share/wordlists/rockyou.txt]: "${NC})" WORDLIST
    [ -z "$WORDLIST" ] && WORDLIST="/usr/share/wordlists/rockyou.txt"
    if [ ! -f "$WORDLIST" ]; then
        echo -e "${RED}[-] Wordlist not found at: $WORDLIST${NC}"
        return 1
    fi
    return 0
}

check_host_reachability() {
    local ip="$1"
    echo -e "${CYAN}[*] Checking host reachability ($ip)...${NC}"
    if ping -c 1 -W 2 "$ip" &> /dev/null; then
        echo -e "${GREEN}[+] Host is reachable (ICMP reply received).${NC}"
    else
        echo -e "${YELLOW}[!] No ICMP reply (host may block ping or be offline). Continuing...${NC}"
    fi
}

# ==========================================
# COLORIZED HYDRA RUNNER FUNCTION
# ==========================================
run_hydra_colorized() {
    local report_file="$1"
    shift
    "$@" | while IFS= read -r line; do
        if echo "$line" | grep -qE "login:|password:"; then
            echo -e "\033[1;32m$line\033[0m"
        else
            echo "$line"
        fi
    done | tee "$report_file"
    echo -e "\n${CYAN}[i] Report saved to: ${WHITE}$report_file${NC}"
}

# ==========================================
# RDP ATTACK & SMART CONNECT MODULE
# ==========================================
rdp_attack() {
    while true; do
        clear
        echo -e "\n${MAGENTA}  ╔════════════════════════════════════════════════════╗${NC}"
        echo -e "${MAGENTA}  ║             RDP ATTACK & SMART CONNECT             ║${NC}"
        echo -e "${MAGENTA}  ╚════════════════════════════════════════════════════╝${NC}"
        echo -e "${CYAN}  [1]${NC} Known Username + Wordlist (Safe Hydra)"
        echo -e "${CYAN}  [2]${NC} Full Brute Force (Userlist + Wordlist)"
        echo -e "${CYAN}  [3]${NC} Check RDP Port (Nmap)"
        echo -e "${CYAN}  [4]${NC} ${GREEN}Smart Direct Connect (Known Credentials)${NC}"
        echo -e "${CYAN}  [5]${NC} Back to Main Menu"
        read -p "$(echo -e ${YELLOW}"  Select [1-5]: "${NC})" rdp_choice

        case $rdp_choice in
            1)
                get_target_ip || { pause_screen; continue; }
                get_wordlist || { pause_screen; continue; }
                read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" USERNAME
                check_host_reachability "$TARGET_IP"
                local out_file="$REPORT_DIR/rdp_hydra_$(date +%F_%H-%M-%S).txt"
                echo -e "\n${GREEN}[+] Running Hydra in SAFE MODE (Anti-Lockout)...${NC}"
                run_hydra_colorized "$out_file" hydra -l "$USERNAME" -P "$WORDLIST" -s 3389 -t 1 -W 3 "rdp://$TARGET_IP" -V
                ;;
            2)
                get_target_ip || { pause_screen; continue; }
                get_wordlist || { pause_screen; continue; }
                read -p "$(echo -e ${CYAN}"[?] Enter Username List Path: "${NC})" USERLIST
                if [ ! -f "$USERLIST" ]; then
                    echo -e "${RED}[-] Userlist file not found!${NC}"
                    pause_screen; continue
                fi
                check_host_reachability "$TARGET_IP"
                local out_file="$REPORT_DIR/rdp_full_$(date +%F_%H-%M-%S).txt"
                echo -e "\n${GREEN}[+] Running Full Brute Force...${NC}"
                run_hydra_colorized "$out_file" hydra -L "$USERLIST" -P "$WORDLIST" -s 3389 -t 1 -W 3 "rdp://$TARGET_IP" -V
                ;;
            3)
                get_target_ip || { pause_screen; continue; }
                local out_file="$REPORT_DIR/rdp_scan_$(date +%F_%H-%M-%S).txt"
                echo -e "\n${GREEN}[+] Scanning RDP Port 3389...${NC}"
                nmap -sV -p 3389 "$TARGET_IP" | tee "$out_file"
                echo -e "\n${CYAN}[i] Report saved to: ${WHITE}$out_file${NC}"
                ;;
            4)
                get_target_ip || { pause_screen; continue; }
                read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" RDP_USER
                read -s -p "$(echo -e ${CYAN}"[?] Enter Password: "${NC})" RDP_PASS
                echo ""

                check_host_reachability "$TARGET_IP"
                echo -e "\n${GREEN}[+] Initializing RDP Session to $TARGET_IP...${NC}"
                echo -e "${YELLOW}[!] Accept certificate fingerprint prompt if shown.${NC}"
                sleep 1

                if command -v xfreerdp3 &> /dev/null; then
                    xfreerdp3 /v:"$TARGET_IP" /u:"$RDP_USER" /p:"$RDP_PASS" /cert:ignore +clipboard /dynamic-resolution /f
                else
                    xfreerdp /v:"$TARGET_IP" /u:"$RDP_USER" /p:"$RDP_PASS" /cert:ignore +clipboard /dynamic-resolution /f 2>/dev/null || \
                    xfreerdp v:"$TARGET_IP" u:"$RDP_USER" p:"$RDP_PASS" /cert:ignore +clipboard /dynamic-resolution /f
                fi

                if [ $? -ne 0 ]; then
                    echo -e "\n${RED}[-] Connection Failed. Verify RDP is enabled, firewall allows 3389, and credentials are valid.${NC}"
                fi
                ;;
            5) break ;;
            *) echo -e "${RED}[-] Invalid Option!${NC}" ;;
        esac
        pause_screen
    done
}

# ==========================================
# SERVICE ATTACK MODULES
# ==========================================
service_hydra_module() {
    local service_name="$1"
    local upper_name
    upper_name=$(echo "$service_name" | tr '[:lower:]' '[:upper:]')

    clear
    echo -e "\n${YELLOW}[+] ${upper_name} Audit Module (Hydra)${NC}"
    get_target_ip || { pause_screen; return; }
    get_wordlist || { pause_screen; return; }
    read -p "$(echo -e ${CYAN}"[?] Enter Username: "${NC})" USERNAME
    check_host_reachability "$TARGET_IP"

    local out_file="$REPORT_DIR/${service_name}_attack_$(date +%F_%H-%M-%S).txt"
    run_hydra_colorized "$out_file" hydra -l "$USERNAME" -P "$WORDLIST" -t 2 "$TARGET_IP" "$service_name" -V
    pause_screen
}

ftp_attack() { service_hydra_module "ftp"; }
ssh_attack() { service_hydra_module "ssh"; }
smb_attack() { service_hydra_module "smb"; }

port_scan() {
    clear
    echo -e "\n${YELLOW}[+] Deep Service & Port Scan (Nmap)${NC}"
    get_target_ip || { pause_screen; return; }
    check_host_reachability "$TARGET_IP"

    local out_file="$REPORT_DIR/nmap_scan_$(date +%F_%H-%M-%S).txt"
    nmap -sV -sC -p 21,22,23,80,139,443,445,3389 "$TARGET_IP" | tee "$out_file"
    echo -e "\n${CYAN}[i] Report saved to: ${WHITE}$out_file${NC}"
    pause_screen
}

# ==========================================
# RECON & NETWORK MODULES
# ==========================================
web_dir_scan() {
    clear
    echo -e "\n${YELLOW}[+] Web Directory Enumeration (Gobuster)${NC}"
    read -p "$(echo -e ${CYAN}"[?] Enter Target URL (e.g., http://192.168.1.10): "${NC})" target_url
    if [[ ! $target_url =~ ^https?:// ]]; then
        echo -e "${RED}[-] URL must start with http:// or https://${NC}"
        pause_screen; return
    fi

    read -p "$(echo -e ${CYAN}"[?] Wordlist path [Default: /usr/share/wordlists/dirb/common.txt]: "${NC})" web_wordlist
    [ -z "$web_wordlist" ] && web_wordlist="/usr/share/wordlists/dirb/common.txt"

    if [ ! -f "$web_wordlist" ]; then
        echo -e "${YELLOW}[!] Default dir wordlist not found. Falling back to rockyou.txt.${NC}"
        web_wordlist="/usr/share/wordlists/rockyou.txt"
    fi

    local out_file="$REPORT_DIR/gobuster_scan_$(date +%F_%H-%M-%S).txt"
    echo -e "${GREEN}[+] Running Gobuster on $target_url...${NC}"
    gobuster dir -u "$target_url" -w "$web_wordlist" -t 30 | tee "$out_file"
    echo -e "\n${CYAN}[i] Report saved to: ${WHITE}$out_file${NC}"
    pause_screen
}

live_host_discovery() {
    clear
    echo -e "\n${YELLOW}[+] Live Host Discovery (Subnet Scan)${NC}"
    local suggested_subnet
    suggested_subnet=$(ip -o -f inet addr show scope global | awk '{print $4}' | head -n 1)
    [ -z "$suggested_subnet" ] && suggested_subnet="192.168.1.0/24"

    read -p "$(echo -e ${CYAN}"[?] Enter Subnet [Detected/Default: $suggested_subnet]: "${NC})" subnet
    [ -z "$subnet" ] && subnet="$suggested_subnet"

    local out_file="$REPORT_DIR/live_hosts_$(date +%F_%H-%M-%S).txt"
    echo -e "${GREEN}[+] Scanning active hosts in $subnet...${NC}"
    nmap -sn "$subnet" | tee "$out_file"
    echo -e "\n${CYAN}[i] Report saved to: ${WHITE}$out_file${NC}"
    pause_screen
}

network_status() {
    clear
    echo -e "\n${YELLOW}[+] Network Interface & IP Configuration${NC}"
    ip -c a
    echo -e "\n${CYAN}[+] Active Routing Table:${NC}"
    ip route
    echo -e "\n${CYAN}[+] Active Listening Ports:${NC}"
    ss -tulnp 2>/dev/null || netstat -tulnp 2>/dev/null
    pause_screen
}

# ==========================================
# 3D MAIN MENU
# ==========================================
show_menu() {
    show_banner
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${GREEN}${BOLD}            SECURITY AUDIT & NETWORK FRAMEWORK v5.0             ${RED}║${NC}"
    echo -e "${RED}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${RED}║${YELLOW}  ⚠  LEGAL DISCLAIMER : Authorized Lab & Educational Use Only  ${RED}║${NC}"
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
    echo -e "${WHITE}  ║${CYAN}  [7]${NC}  Live Host Discovery (Subnet Scan)                   ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${CYAN}  [8]${NC}  Network Interface & Socket Status                   ${WHITE}║${NC}"
    echo -e "${WHITE}  ║${RED}  [9]${NC}  Exit System                                         ${WHITE}║${NC}"
    echo -e "${WHITE}  ╚═══════════════════════════════════════════════════════════╝${NC}"
    read -p "$(echo -e ${GREEN}"\n[?] Select Option [1-9]: "${NC})" choice
}

# ==========================================
# EXECUTION ENGINE
# ==========================================
check_environment
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
        9) cleanup_and_exit ;;
        *) echo -e "${RED}[-] Invalid Option! Please select 1-9.${NC}"; sleep 1 ;;
    esac
done
