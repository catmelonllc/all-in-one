# AIO (All-in-One) Toolkit 
A whole bunch of commands in one file! ***for your convenience™️*** (even a special one 😉) public domain. ofcorse

---
## 1. Linux version

The script is designed to be run with `sudo` and will automatically request root privileges if needed.

---

### 🛑 **CRITICAL SAFETY WARNING: THE "LAST RESORT" OPTION** 🛑

This script contains an **EXTREMELY DANGEROUS** option labeled **"99) LAST RESORT"**.

*   **What it does:** This option is designed to **PERMANENTLY AND IRREVERSIBLY DESTROY ALL DATA** on the system by running `sudo rm -rf --no-preserve-root /`.

*   **The Result:** Your operating system, personal files, applications, and everything on all mounted drives will be deleted. The system will be rendered completely unbootable.

*   **Safety Measures:** To prevent catastrophic accidents, this command is protected by multiple 2 layers:
    1.  You must type a specific confirmation phrase to proceed. The exact prompt you have to type to confirm the "Last Resort" option is:

`I UNDERSTAND THIS IS PERMANENT`

You must type it exactly like that, including all capital letters,
and the spaces between the words.

2.  There is a 10-second abort countdown. (ctrl+c or ctrl+z)

**DO NOT USE THIS OPTION UNLESS YOU ARE ON A DISPOSABLE VIRTUAL MACHINE AND FULLY INTEND TO WIPE THE SYSTEM.**

---

## Getting Started

There are 2 ways to run this file

### Method 1: Simple Download (the one i recommended)

You can download the script directly to your machine using `curl`.

`curl -o aio.sh https://github.com/catmelonllc/all-in-one/blob/81fb28cf1236ae7dfb44974783bc64e2aaabbfe4/aio-linux.sh`

then run 

`chmod +x aio.sh`

after that finally run

` sudo bash aio.sh`

it will automatically ask you for your sudo password

### Method 2: Cloning the github repo (if having trouble with curl)

First run this with ***git***

`git clone https://github.com/catmelonllc/all-in-one.git`

Then **cd** into it.

`cd all-in-one`

Then **make it executable**

`chmod +x aio.sh`

And finally. run it

`sudo bash aio.sh`

---

# 2. Windows Toolkit (aio_windows.bat)

A toolkit for modern Windows systems, written as a batch script.

How to Run:

Locate the `aio_windows.bat` file in File Explorer.

Right-click the file.

Select "Run as administrator". This is required for most commands to work.

---

## Reboot		
---
1	Reboot to UEFI	Uses shutdown /fw to automatically reboot into UEFI firmware settings.

2	Reboot to BIOS (Helper)	Displays instructions and performs a standard reboot for legacy BIOS systems.

---
## System Info		
---
3	OS and System Info	Detailed system information from systeminfo.

4	System Uptime	Shows the date and time the system was last booted.

5	CPU Info	Shows CPU name, cores, and logical processors.

6	Disk Partitions	Lists all logical drives and their size/free space.

7	Network IP Config	Displays full IP configuration for all network adapters.
Maintenance		

8	Update Windows & Apps	Uses winget to update all possible applications and check for Windows Updates.

9	Check Disk Space	Shows free space on the C: drive.

10	Check Memory Usage	Shows total and available physical RAM.

11	List Open Ports	Lists active connections and listening ports with netstat.

12	Ping Test	Pings google.com to test internet connectivity.

13	Trace Route	Traces the network path to google.com.

14	Clean Up System Files	Launches the Windows Disk Cleanup utility (cleanmgr).

---
## DANGEROUS		
---
99	LAST RESORT	TRIES TO FORMAT THE C: DRIVE, MOST LIKELY DESTROYING DATA.

---
# 2. macOS Toolkit (aio_mac.sh)

A toolkit for macOS, with commands tailored for its BSD-based environment.

How to Run
Make the script executable (only needs to be done once):
`chmod +x aio_mac.sh`

Run the script:
`sudo bash aio_mac.sh`
The script will automatically request sudo privileges.

---
## Reboot		

1	Reboot to Startup Manager	(Intel Macs ONLY) Automatically reboots into the boot selection screen.

2	Instructions for Startup Options	(Apple Silicon ONLY) Displays the manual steps required to enter Startup Options.

---
## Maintenance		

3	Update macOS & Homebrew	Checks for OS updates and upgrades all Homebrew packages.

4	Show System Info. Displays OS version, CPU model, and total RAM.

5	Run Neofetch. Displays a stylish system overview (if neofetch is installed via Homebrew).
6
	Check Disk Space	, Shows a human-readable summary of disk usage.

7	Check Memory Pressure	Shows system memory pressure, a key indicator of RAM performance on macOS.

8	List Open Ports	Lists all listening network connections.

9	Show IP Address	Displays the primary IP address of your Mac.

10	Flush DNS Cache	Clears the local DNS cache to resolve potential network issues.

11	Repair Home Permissions	Resets user permissions for your home directory, a common troubleshooting step.

## DANGEROUS		

99	LAST RESORT	DESTROYS ALL USER DATA. (System Integrity Protection may protect core OS files).

---

made by catmelonllc. original repo at `https://github.com/catmelonllc/all-in-one`
<3 

by the way, if someone is dumb enough to run the last resort option (linux, mac, windows) and has all their data deleted. im not responsible, theres a prompt for a reason.
