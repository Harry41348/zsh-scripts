#!/usr/bin/env zsh
# system-info.sh
# Display a summary of key system information: OS, CPU, memory, disk, and uptime.

set -euo pipefail

BOLD='\033[1m'
CYAN='\033[0;36m'
RESET='\033[0m'

section() {
    echo -e "\n${BOLD}${CYAN}=== $1 ===${RESET}"
}

section "Operating System"
if command -v lsb_release &>/dev/null; then
    lsb_release -d | sed 's/Description:\s*//'
elif [[ -f /etc/os-release ]]; then
    grep -E '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '"'
else
    uname -s
fi
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Hostname: $(hostname)"

section "CPU"
if [[ -f /proc/cpuinfo ]]; then
    model=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | xargs)
    cores=$(grep -c '^processor' /proc/cpuinfo)
    echo "Model: ${model}"
    echo "Cores: ${cores}"
else
    sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "CPU info unavailable"
fi

section "Memory"
if [[ -f /proc/meminfo ]]; then
    total=$(grep MemTotal /proc/meminfo | awk '{printf "%.1f GB", $2/1024/1024}')
    avail=$(grep MemAvailable /proc/meminfo | awk '{printf "%.1f GB", $2/1024/1024}')
    echo "Total:     ${total}"
    echo "Available: ${avail}"
else
    vm_stat 2>/dev/null | head -5 || echo "Memory info unavailable"
fi

section "Disk Usage"
df -h --output=source,size,used,avail,pcent,target 2>/dev/null \
    | grep -E '^(/dev|Filesystem)' \
    || df -h | grep -E '^(/dev|Filesystem)'

section "Uptime"
uptime -p 2>/dev/null || uptime

section "Logged-in Users"
who 2>/dev/null || echo "No users found"
