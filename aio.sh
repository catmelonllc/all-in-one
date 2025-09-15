#!/bin/bash

# AIO Linux Toolkit v2
# WARNING: This script contains extremely destructive commands. Use with extreme caution.

# --- Sudo Check ---
# Ensure the script is running with root privileges. If not, re-execute with sudo.
[ "$(id -u)" -ne 0 ] && { echo "This script needs root privileges. Re-running with sudo..."; exec sudo "$0" "$@"; }

# --- Color Definitions for UI ---
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# --- Helper Functions ---

# Function for a standard countdown
countdown() {
    for i in {5..1}; do
        echo -ne "${YELLOW}>> Action starting in $i seconds... (Press Ctrl+C to cancel)${RESET}\r"
        sleep 1
    done
    echo -e "\n${GREEN}>> Executing now...${RESET}"
}

# Function to check if a command exists and prompt for installation
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "${YELLOW}Command '$1' not found. It is required for this option.${RESET}"
        read -p "Do you want to try and install it? (y/N) " install_choice
        if [[ "$install_choice" =~ ^[Yy]$ ]]; then
            update_system
        else
            echo "${RED}Aborting.${RESET}"
            return 1
        fi
    fi
    return 0
}

# --- Function Definitions ---

# 1. Reboot to UEFI (systemd)
reboot_uefi_systemd() {
    echo "${BLUE}Rebooting to UEFI firmware setup using systemctl.${RESET}"
    countdown
    systemctl reboot --firmware-setup
}

# 2. Reboot to UEFI (efibootmgr)
reboot_uefi_efibootmgr() {
    check_command "efibootmgr" || return
    echo "${BLUE}Rebooting to UEFI firmware setup using efibootmgr.${RESET}"
    countdown
    efibootmgr --reboot-to-firmware-setup
}

# 3. Reboot to BIOS (Helper)
reboot_bios_helper() {
    echo "${YELLOW}######################################################################${RESET}"
    echo "${YELLOW}# ${BOLD}IMPORTANT:${RESET}${YELLOW} Automatic reboot to a legacy BIOS is not possible.   #"
    echo "${YELLOW}# This script will perform a STANDARD REBOOT.                        #"
    echo "${YELLOW}# ==> Common Keys: ${BOLD}Del, F1, F2, F10, Esc${RESET}${YELLOW}                             #"
    echo "${YELLOW}######################################################################${RESET}"
    countdown
    reboot
}

# --- System Info ---
show_os_info() { echo "${CYAN}OS and Kernel Information:${RESET}"; uname -a; lsb_release -a 2>/dev/null || cat /etc/os-release; }
show_uptime() { echo "${CYAN}System Uptime and Load:${RESET}"; uptime; }
show_cpu_info() { echo "${CYAN}CPU Information:${RESET}"; lscpu; }
show_pci_devices() { echo "${CYAN}PCI Devices (VGA, Network, etc.):${RESET}"; lspci; }
show_usb_devices() { echo "${CYAN}USB Devices:${RESET}"; lsusb; }
show_disk_partitions() { echo "${CYAN}Disk Partitions and Block Devices:${RESET}"; lsblk; }

# --- Process Management ---
list_all_processes() { echo "${CYAN}Listing All Running Processes:${RESET}"; ps aux; }
interactive_process_viewer() {
    check_command "htop" || return
    echo "${BLUE}Starting interactive process viewer (htop)... Press 'q' to quit.${RESET}"; sleep 2; htop;
}
find_process_by_name() {
    read -p "Enter process name to find: " name
    echo "${CYAN}Searching for processes matching '$name'...${RESET}"
    pgrep -af "$name"
}
kill_process() {
    read -p "Enter Process ID (PID) or name to kill: " target
    read -p "${RED}${BOLD}Are you sure you want to kill '$target'? (y/N) ${RESET}" confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        pkill -9 "$target" || kill -9 "$target" 2>/dev/null
        echo "${GREEN}Kill signal sent to '$target'.${RESET}"
    else
        echo "${RED}Aborted.${RESET}"
    fi
}

# --- Network Diagnostics ---
show_ip_addresses() { echo "${CYAN}Network Interfaces and IP Addresses:${RESET}"; ip addr show; }
test_connectivity() { echo "${CYAN}Pinging google.com (3 packets)...${RESET}"; ping -c 3 google.com; }
trace_network_route() {
    check_command "traceroute" || return
    read -p "Enter hostname or IP to trace (e.g., google.com): " host
    echo "${CYAN}Tracing route to $host...${RESET}"; traceroute "$host";
}
dns_lookup() {
    check_command "dig" || return
    read -p "Enter domain name to look up (e.g., github.com): " domain
    echo "${CYAN}Performing DNS lookup for $domain...${RESET}"; dig "$domain";
}
list_open_ports() { echo "${CYAN}Listening TCP/UDP Ports:${RESET}"; ss -tuln; }

# --- Disk & File Management ---
check_disk_space() { echo "${CYAN}Disk Space Usage:${RESET}"; df -h; }
check_memory() { echo "${CYAN}Memory Usage:${RESET}"; free -h; }
analyze_dir_size() {
    read -p "Enter directory path to analyze (e.g., /var/log): " dir_path
    echo "${CYAN}Calculating size of '$dir_path'...${RESET}"
    du -sh "$dir_path"
}
find_large_files() {
    echo "${CYAN}Searching for the 10 largest files in / (this may take a while)...${RESET}"
    du -ah / 2>/dev/null | sort -rh | head -n 10
}
clean_caches() {
    echo "${BLUE}Cleaning package manager caches...${RESET}"
    (apt clean 2>/dev/null || dnf clean all 2>/dev/null || pacman -Scc --noconfirm 2>/dev/null) && echo "${GREEN}Caches cleaned.${RESET}"
}
update_system() {
    echo "${BLUE}Updating system packages...${RESET}"
    (apt update && apt upgrade -y) || (dnf upgrade -y) || (pacman -Syu --noconfirm) || echo "${RED}Could not find a known package manager.${RESET}"
}

# --- User & Security ---
list_logged_in_users() { echo "${CYAN}Currently Logged-In Users:${RESET}"; who; }
show_last_logins() { echo "${CYAN}Last 15 User Logins:${RESET}"; last | head -n 15; }
view_cron_jobs() { echo "${CYAN}Scheduled Cron Jobs for root:${RESET}"; crontab -l; }
view_systemd_timers() { echo "${CYAN}Active Systemd Timers:${RESET}"; systemctl list-timers; }
view_logs() {
    echo "${BLUE}Showing last 50 system log entries (Press Ctrl+C to exit)...${RESET}"; sleep 2; journalctl -n 50 -f;
}

# 99. LAST RESORT
last_resort() {
    CONFIRMATION_PHRASE="I UNDERSTAND THIS IS PERMANENT"
    echo "${RED}${BOLD}######################################################################${RESET}"
    echo "${RED}${BOLD}#                          EXTREME DANGER ZONE                         #${RESET}"
    echo "${RED}${BOLD}#  You have selected the LAST RESORT. This will execute: rm -rf /*   #${RESET}"
    echo "${RED}${BOLD}#  This will PERMANENTLY DESTROY ALL DATA on this system.            #${RESET}"
    echo "${RED}${BOLD}######################################################################${RESET}"
    echo -e "\n${BOLD}To proceed, you MUST type the following phrase exactly:"
    echo "  ${YELLOW}${CONFIRMATION_PHRASE}${RESET}"
    read -p "> " user_confirmation
    if [ "$user_confirmation" != "$CONFIRMATION_PHRASE" ]; then
        echo "${GREEN}Confirmation failed. Aborting.${RESET}"; return;
    fi
    echo "${RED}${BOLD}\nConfirmation accepted. There is no going back.${RESET}"
    for i in {10..1}; do echo "${RED}${BOLD}SYSTEM DESTRUCTION IN $i SECONDS... (CTRL+C TO ABORT)${RESET}"; sleep 1; done
    echo "${RED}${BOLD}DESTROYING SYSTEM... GOODBYE.${RESET}"
    sudo rm -rf --no-preserve-root /
    

# --- Main Menu Loop ---
while true; do
    clear
    echo "${BOLD}======================================================================${RESET}"
    echo "${BOLD}                    All-in-One (AIO) Linux Toolkit v2                 ${RESET}"
    echo "${BOLD}======================================================================${RESET}"
    
    # Menu Layout
    {
        echo "${MAGENTA}--- Reboot & Power ---${RESET}"
        echo " 1) Reboot to UEFI (systemd)"
        echo " 2) Reboot to UEFI (efibootmgr)"
        echo " 3) Reboot to BIOS (Helper)"
        echo
        echo "${MAGENTA}--- System Information ---${RESET}"
        echo " 4) Show OS & Kernel Info"
        echo " 5) Show System Uptime"
        echo " 6) Show CPU Info"
        echo " 7) Show PCI Devices (GPU, etc)"
        echo " 8) Show USB Devices"
        echo " 9) Show Disk Partitions"
        echo
        echo "${MAGENTA}--- Process Management ---${RESET}"
        echo "10) List All Processes"
        echo "11) Interactive Process Viewer (htop)"
        echo "12) Find Process by Name"
        echo "13) Kill a Process by Name/PID"
    } | column -t -s '#'

    {
        echo "#${MAGENTA}--- Network Diagnostics ---${RESET}"
        echo "#14) Show IP Addresses"
        echo "#15) Test Internet Connectivity (ping)"
        echo "#16) Trace Network Route"
        echo "#17) DNS Lookup (dig)"
        echo "#18) List Open Network Ports"
        echo "#"
        echo "#${MAGENTA}--- Disk & File Management ---${RESET}"
        echo "#19) Check Disk Space Usage"
        echo "#20) Check Memory Usage"
        echo "#21) Analyze Directory Size"
        echo "#22) Find Top 10 Largest Files"
        echo "#23) Clean Package Caches"
        echo "#24) Update All System Packages"
        echo "#"
        echo "#${MAGENTA}--- User, Security & Logs ---${RESET}"
        echo "#25) List Logged-In Users"
        echo "#26) Show Last Logins"
        echo "#27) View Scheduled Cron Jobs"
        echo "#28) View Systemd Timers"
        echo "#29) View Live System Logs"
    } | column -t -s '#' -o' | ' | sed 's/^/   /'

    echo
    echo "${RED}${BOLD}--- DANGEROUS ---${RESET}"
    echo " 99) ${BOLD}LAST RESORT (PERMANENTLY DESTROY SYSTEM DATA)${RESET}"
    echo
    echo "  0) Exit"
    echo "${BOLD}======================================================================${RESET}"

    read -p "Enter your choice: " choice

    case $choice in
        1) reboot_uefi_systemd ;; 2) reboot_uefi_efibootmgr ;; 3) reboot_bios_helper ;;
        4) show_os_info ;; 5) show_uptime ;; 6) show_cpu_info ;; 7) show_pci_devices ;;
        8) show_usb_devices ;; 9) show_disk_partitions ;; 10) list_all_processes ;;
        11) interactive_process_viewer ;; 12) find_process_by_name ;; 13) kill_process ;;
        14) show_ip_addresses ;; 15) test_connectivity ;; 16) trace_network_route ;;
        17) dns_lookup ;; 18) list_open_ports ;; 19) check_disk_space ;; 20) check_memory ;;
        21) analyze_dir_size ;; 22) find_large_files ;; 23) clean_caches ;; 24) update_system ;;
        25) list_logged_in_users ;; 26) show_last_logins ;; 27) view_cron_jobs ;;
        28) view_systemd_timers ;; 29) view_logs ;;
        99) last_resort ;;
        0) echo "${GREEN}Exiting.${RESET}"; exit 0 ;;
        *) echo "${RED}Invalid option. Please try again.${RESET}" ;;
    esac

    echo -e "\n${BOLD}Press Enter to return to the menu...${RESET}"
    read
done