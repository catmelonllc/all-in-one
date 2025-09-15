# AIO (All-in-One) Linux Toolkit
A whole bunch of commands in one file! (even a special one 😉) public domain. ofcorse

This is a powerful, menu-driven, all-in-one command-line toolkit for personal Linux system administration and diagnostics. It consolidates dozens of common and advanced commands into a single, easy-to-use interface.

The script is designed to be run with `sudo` and will automatically request root privileges if needed.

---

### 🛑 **CRITICAL SAFETY WARNING: THE "LAST RESORT" OPTION** 🛑

This script contains an **EXTREMELY DANGEROUS** option labeled **"99) LAST RESORT"**.

*   **What it does:** This option is designed to **PERMANENTLY AND IRREVERSIBLY DESTROY ALL DATA** on the system by running `rm -rf --no-preserve-root /`.

*   **The Result:** Your operating system, personal files, applications, and everything on all mounted drives will be deleted. The system will be rendered completely unbootable.

*   **Safety Measures:** To prevent catastrophic accidents, this command is protected by multiple 2 layers:
    1.  You must type a specific confirmation phrase to proceed. The exact prompt you have to type to confirm the "Last Resort" option is:

`I UNDERSTAND THIS IS PERMANENT`

You must type it exactly like that, including:

All capital letters.
The spaces between the words.

2.  There is a 10-second abort countdown.

**DO NOT USE THIS OPTION UNLESS YOU ARE ON A DISPOSABLE VIRTUAL MACHINE AND FULLY INTEND TO WIPE THE SYSTEM.**

---

## Getting Started

There are 2 ways to run this file

### Method 1: Simple Download (the one i recommended)

You can download the script directly to your machine using `curl`.

`curl -o aio.sh https://github.com/catmelonllc/all-in-one/blob/main/aio.sh`
then run 

`chmod +x aio.sh`

after that finally run

`./aio.sh`
it will automatically ask you for your sudo password

### Method 2: Cloning the github repo (if having trouble with curl)

First run this with ***git***

`git clone https://github.com/catmelonllc/all-in-one.git`

Then **cd** into it.

`cd all-in-one`

Then **make it executable**

`chmod +x aio.sh`

And finally. run it

`./aio.sh`
---
ok bye <3
remember. this is public domain. infact, all my work is. i believe all people should have the right to modify this.
okay bye! 
made by catmelonllc. original repo at `https://github.com/catmelonllc/all-in-one`
<3 
