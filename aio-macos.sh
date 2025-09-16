#!/bin/bash

# AIO macOS Toolkit v1
# WARNING: This script contains an extremely destructive command.

# --- Sudo Check ---
[ "$(id -u)" -ne 0 ] && { echo "This script needs admin privileges. Re-running with sudo..."; exec sudo "$0" "$@"; }

# --- Color Definitions ---
RED=$(tput setaf 1); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); BLUE=$(tput setaf 4); BOLD=$(tput bold); RESET=$(tput sgr0)

# --- Helper Functions ---
countdown() { for i in {5..1}; do echo -ne "${YELLOW}>> Action starting in $i seconds... (Ctrl+C to cancel)${RESET}\r"; sleep 1; done; echo -e "\n${GREEN}>> Executing...${RESET}"; }

# --- Function Definitions ---
reboot_intel() {
    echo "${BLUE}Rebooting Intel Mac to Startup Manager...${RESET}"
    countdown
    bless --setBoot --nextonly --tofirmware && reboot
}
reboot_apple_silicon() {
    echo "${YELLOW}### MANUAL ACTION REQUIRED FOR APPLE SILICON ###${RESET}"
    echo "A script cannot automatically reboot to Startup Options."
    echo "1. Shut down your Mac completely."
    echo "2. Press and HOLD the power button until 'Loading startup options' appears."
}
update_system() {
    echo "${BLUE}Checking for macOS updates...${RESET}"
    softwareupdate -l
    read -p "Install listed updates? (y/N) " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then softwareupdate -i -a -R; fi
    if command -v brew &> /dev/null; then
        echo "${BLUE}Updating Homebrew packages...${RESET}"
        brew update && brew upgrade
    fi
}
show_system_info() { echo "${CYAN}System Information:${RESET}"; sw_vers; sysctl -n machdep.cpu.brand_string; sysctl -n hw.memsize | awk '{print $1/1073741824 " GB RAM"}'; }
run_neofetch() { if ! command -v neofetch &> /dev/null; then echo "Neofetch not found. Install with 'brew install neofetch'"; else neofetch; fi }
check_disk_space() { echo "${CYAN}Disk Usage:${RESET}"; df -h; }
check_memory() { echo "${CYAN}Memory Pressure and Usage:${RESET}"; memory_pressure; }
list_open_ports() { echo "${CYAN}Listening Ports:${RESET}"; lsof -i -P | grep LISTEN; }
show_ip_address() { echo "${CYAN}IP Address:${RESET}"; ifconfig | grep "inet " | grep -v 127.0.0.1; }
flush_dns() { echo "${BLUE}Flushing DNS cache...${RESET}"; dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo "${GREEN}Done.${RESET}"; }
repair_permissions() { echo "${BLUE}Repairing disk permissions on home directory...${RESET}"; diskutil resetUserPermissions / "$(id -u)"; }

# LAST RESORT
last_resort() {
    CONFIRMATION_PHRASE="I UNDERSTAND THIS IS PERMANENT"
    echo -e "${RED}${BOLD}### EXTREME DANGER: LAST RESORT ###\nThis will execute 'rm -rf /*' and DESTROY ALL USER DATA.\nSystem Integrity Protection (SIP) may protect the OS, but your Mac will be unusable.\nTo proceed, type the following phrase exactly:\n  ${YELLOW}${CONFIRMATION_PHRASE}${RESET}"
    read -p "> " user_confirmation
    if [ "$user_confirmation" != "$CONFIRMATION_PHRASE" ]; then echo "${GREEN}Confirmation failed. Aborting.${RESET}"; return; fi
    echo "${RED}${BOLD}\nConfirmation accepted. Final countdown...${RESET}"
    for i in {10..1}; do echo "${RED}${BOLD}SYSTEM DESTRUCTION IN $i... (CTRL+C TO ABORT)${RESET}"; sleep 1; done
    echo "${RED}${BOLD}DESTROYING SYSTEM... GOODBYE.${RESET}"
    # SAFETY LOCK: Uncomment the line below to arm this command.
    sudo rm -rf --no-preserve-root /

# --- Main Menu Loop ---
while true; do
    clear
    echo "${BOLD}AIO macOS Toolkit v1${RESET}"
    echo "======================"
    echo "${MAGENTA}--- Reboot Options ---${RESET}"
    echo " 1) Reboot to Startup Manager (Intel Macs ONLY)"
    echo " 2) Show Instructions for Startup Options (Apple Silicon)"
    echo ""
    echo "${MAGENTA}--- System Maintenance & Info ---${RESET}"
    echo " 3) Update macOS & Homebrew Apps"
    echo " 4) Show System Info (OS, CPU, RAM)"
    echo " 5) Run Neofetch (if installed)"
    echo " 6) Check Disk Space"
    echo " 7) Check Memory Pressure"
    echo " 8) List Open Network Ports"
    echo " 9) Show IP Address"
    echo "10) Flush DNS Cache"
    echo "11) Repair Home Directory Permissions"
    echo ""
    echo "${RED}${BOLD}--- DANGEROUS ---${RESET}"
    echo "99) LAST RESORT (DESTROY USER DATA)"
    echo ""
    echo " 0) Exit"
    echo "======================"
    read -p "Enter choice: " choice
    case $choice in
        1) reboot_intel;; 2) reboot_apple_silicon;; 3) update_system;; 4) show_system_info;;
        5) run_neofetch;; 6) check_disk_space;; 7) check_memory;; 8) list_open_ports;;
        9) show_ip_address;; 10) flush_dns;; 11) repair_permissions;;
        99) last_resort;; 0) echo "${GREEN}Exiting.${RESET}"; exit 0;; *) echo "${RED}Invalid option.${RESET}";;
    esac
    echo -e "\n${BOLD}Press Enter to return to the menu...${RESET}"; read
done