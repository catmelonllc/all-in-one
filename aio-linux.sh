#!/bin/bash

# AIO Linux Toolkit v3
# WARNING: This script contains extremely destructive commands. Use with extreme caution.

# --- Sudo Check ---
[ "$(id -u)" -ne 0 ] && { echo "This script needs root privileges. Re-running with sudo..."; exec sudo "$0" "$@"; }

# --- Color Definitions ---
RED=$(tput setaf 1); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); BLUE=$(tput setaf 4); MAGENTA=$(tput setaf 5); CYAN=$(tput setaf 6); BOLD=$(tput bold); RESET=$(tput sgr0)

# --- Helper Functions ---
countdown() { for i in {5..1}; do echo -ne "${YELLOW}>> Action starting in $i seconds... (Ctrl+C to cancel)${RESET}\r"; sleep 1; done; echo -e "\n${GREEN}>> Executing...${RESET}"; }
check_command() { if ! command -v "$1" &> /dev/null; then echo "${YELLOW}Command '$1' not found.${RESET}"; read -p "Try to install it? (y/N) " i; if [[ "$i" =~ ^[Yy]$ ]]; then update_system; else echo "${RED}Aborting.${RESET}"; return 1; fi; fi; return 0; }

# --- Function Definitions ---
# Reboot
reboot_uefi_systemd() { echo "${BLUE}Rebooting to UEFI via systemctl.${RESET}"; countdown; systemctl reboot --firmware-setup; }
reboot_uefi_efibootmgr() { check_command "efibootmgr" || return; echo "${BLUE}Rebooting to UEFI via efibootmgr.${RESET}"; countdown; efibootmgr --reboot-to-firmware-setup; }
reboot_bios_helper() { echo "${YELLOW}### BIOS REBOOT HELPER ###\nThis is a standard reboot. Be ready to press your BIOS key (Del, F2, etc).${RESET}"; countdown; reboot; }

# System Info
show_os_info() { echo "${CYAN}OS and Kernel Info:${RESET}"; uname -a; lsb_release -a 2>/dev/null || cat /etc/os-release; }
show_uptime() { echo "${CYAN}System Uptime and Load:${RESET}"; uptime; }
show_cpu_info() { echo "${CYAN}CPU Information:${RESET}"; lscpu; }
show_pci_devices() { echo "${CYAN}PCI Devices (VGA, Network, etc.):${RESET}"; lspci; }
show_usb_devices() { echo "${CYAN}USB Devices:${RESET}"; lsusb; }
show_disk_partitions() { echo "${CYAN}Disk Partitions:${RESET}"; lsblk; }
run_neofetch() { check_command "neofetch" || return; neofetch; }
run_fastfetch() { check_command "fastfetch" || return; fastfetch; }

# Process Management
list_all_processes() { echo "${CYAN}Listing All Processes:${RESET}"; ps aux; }
interactive_process_viewer() { check_command "htop" || return; echo "${BLUE}Starting htop... (Press 'q' to quit)${RESET}"; sleep 1; htop; }
find_process_by_name() { read -p "Enter process name: " n; echo "${CYAN}Searching for '$n'...${RESET}"; pgrep -af "$n"; }
kill_process() { read -p "Enter PID or name to kill: " t; read -p "${RED}${BOLD}Kill '$t'? (y/N) ${RESET}" c; if [[ "$c" =~ ^[Yy]$ ]]; then pkill -9 "$t" || kill -9 "$t" 2>/dev/null; echo "${GREEN}Kill signal sent.${RESET}"; else echo "${RED}Aborted.${RESET}"; fi; }

# Network Diagnostics
show_ip_addresses() { echo "${CYAN}IP Addresses:${RESET}"; ip addr show; }
test_connectivity() { echo "${CYAN}Pinging google.com...${RESET}"; ping -c 3 google.com; }
trace_network_route() { check_command "traceroute" || return; read -p "Host to trace: " h; traceroute "$h"; }
dns_lookup() { check_command "dig" || return; read -p "Domain to look up: " d; dig "$d"; }
list_open_ports() { echo "${CYAN}Listening Ports:${RESET}"; ss -tuln; }

# Disk & File Management
check_disk_space() { echo "${CYAN}Disk Usage:${RESET}"; df -h; }
check_memory() { echo "${CYAN}Memory Usage:${RESET}"; free -h; }
analyze_dir_size() { read -p "Directory path to analyze: " d; du -sh "$d"; }
find_large_files() { echo "${CYAN}Finding top 10 largest files in / ...${RESET}"; du -ah / 2>/dev/null | sort -rh | head -n 10; }
clean_caches() { echo "${BLUE}Cleaning package caches...${RESET}"; (apt clean 2>/dev/null || dnf clean all 2>/dev/null || pacman -Scc --noconfirm 2>/dev/null) && echo "${GREEN}Done.${RESET}"; }
update_system() { echo "${BLUE}Updating system...${RESET}"; (apt update && apt upgrade -y) || (dnf upgrade -y) || (pacman -Syu --noconfirm) || echo "${RED}Unknown package manager.${RESET}"; }

# User, Security & Logs
list_logged_in_users() { echo "${CYAN}Logged-In Users:${RESET}"; who; }
show_last_logins() { echo "${CYAN}Last 15 Logins:${RESET}"; last | head -n 15; }
view_cron_jobs() { echo "${CYAN}Root Cron Jobs:${RESET}"; crontab -l; }
view_systemd_timers() { echo "${CYAN}Systemd Timers:${RESET}"; systemctl list-timers; }
view_logs() { echo "${BLUE}Tailing system log... (Ctrl+C to exit)${RESET}"; sleep 1; journalctl -n 50 -f; }

# LAST RESORT
last_resort() {
    CONFIRMATION_PHRASE="I UNDERSTAND THIS IS PERMANENT"
    echo -e "${RED}${BOLD}### EXTREME DANGER: LAST RESORT ###\nThis will execute 'rm -rf /*' and DESTROY ALL DATA.\nTo proceed, type the following phrase exactly:\n  ${YELLOW}${CONFIRMATION_PHRASE}${RESET}"
    read -p "> " user_confirmation
    if [ "$user_confirmation" != "$CONFIRMATION_PHRASE" ]; then echo "${GREEN}Confirmation failed. Aborting.${RESET}"; return; fi
    echo "${RED}${BOLD}\nConfirmation accepted. Final countdown...${RESET}"
    for i in {10..1}; do echo "${RED}${BOLD}SYSTEM DESTRUCTION IN $i... (CTRL+C TO ABORT)${RESET}"; sleep 1; done
    echo "${RED}${BOLD}DESTROYING SYSTEM... GOODBYE.${RESET}"
    # SAFETY LOCK: Uncomment the line below to arm this command.
    sudo rm -rf --no-preserve-root /
}

# --- Main Menu Loop ---
while true; do
    clear; echo "${BOLD}AIO Linux Toolkit v3${RESET}"; echo "===================="
    echo "${MAGENTA}--- Reboot & Power ---${RESET}"; echo " 1) Reboot to UEFI (systemd)"; echo " 2) Reboot to UEFI (efibootmgr)"; echo " 3) Reboot to BIOS (Helper)"
    echo "${MAGENTA}--- System Information ---${RESET}"; echo " 4) OS & Kernel Info"; echo " 5) Uptime"; echo " 6) CPU Info"; echo " 7) PCI Devices"; echo " 8) USB Devices"; echo " 9) Disk Partitions"; echo " 10) Neofetch"; echo " 11) Fastfetch"
    echo "${MAGENTA}--- Process Management ---${RESET}"; echo "12) List Processes"; echo "13) Interactive Viewer (htop)"; echo "14) Find Process"; echo "15) Kill Process"
    echo "${MAGENTA}--- Network Diagnostics ---${RESET}"; echo "16) IP Addresses"; echo "17) Ping Test"; echo "18) Trace Route"; echo "19) DNS Lookup"; echo "20) Open Ports"
    echo "${MAGENTA}--- Disk & File Management ---${RESET}"; echo "21) Disk Space"; echo "22) Memory Usage"; echo "23) Directory Size"; echo "24) Find Large Files"; echo "25) Clean Caches"; echo "26) Update System"
    echo "${MAGENTA}--- User, Security & Logs ---${RESET}"; echo "27) Logged-In Users"; echo "28) Last Logins"; echo "29) Cron Jobs"; echo "30) Systemd Timers"; echo "31) View Live Logs"
    echo "${RED}${BOLD}--- DANGEROUS ---${RESET}"; echo "99) LAST RESORT (DESTROY SYSTEM)"
    echo "0) Exit"; echo "===================="; read -p "Enter choice: " choice
    case $choice in
        1) reboot_uefi_systemd;; 2) reboot_uefi_efibootmgr;; 3) reboot_bios_helper;; 4) show_os_info;; 5) show_uptime;; 6) show_cpu_info;; 7) show_pci_devices;; 8) show_usb_devices;; 9) show_disk_partitions;; 10) run_neofetch;; 11) run_fastfetch;; 12) list_all_processes;; 13) interactive_process_viewer;; 14) find_process_by_name;; 15) kill_process;; 16) show_ip_addresses;; 17) test_connectivity;; 18) trace_network_route;; 19) dns_lookup;; 20) list_open_ports;; 21) check_disk_space;; 22) check_memory;; 23) analyze_dir_size;; 24) find_large_files;; 25) clean_caches;; 26) update_system;; 27) list_logged_in_users;; 28) show_last_logins;; 29) view_cron_jobs;; 30) view_systemd_timers;; 31) view_logs;;
        99) last_resort;; 0) echo "${GREEN}Exiting.${RESET}"; exit 0;; *) echo "${RED}Invalid option.${RESET}";;
    esac
    echo -e "\n${BOLD}Press Enter to return to the menu...${RESET}"; read
done