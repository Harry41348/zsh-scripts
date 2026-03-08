#!/usr/bin/env zsh
# network-info.sh
# Display a summary of network information: interfaces, IPs, default gateway,
# DNS servers, and (optionally) a basic connectivity check.

set -euo pipefail

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

section() {
    echo -e "\n${BOLD}${CYAN}=== $1 ===${RESET}"
}

# ── Network Interfaces & IP Addresses ────────────────────────────────────────
section "Network Interfaces"
if command -v ip &>/dev/null; then
    ip -brief address show
else
    ifconfig 2>/dev/null || echo "Neither 'ip' nor 'ifconfig' found."
fi

# ── Default Gateway ───────────────────────────────────────────────────────────
section "Default Gateway"
if command -v ip &>/dev/null; then
    ip route show default 2>/dev/null | head -3 || echo "No default route found."
else
    netstat -rn 2>/dev/null | grep -E '^(default|0\.0\.0\.0)' | head -3 \
        || echo "Could not determine default gateway."
fi

# ── DNS Servers ───────────────────────────────────────────────────────────────
section "DNS Servers"
if [[ -f /etc/resolv.conf ]]; then
    grep '^nameserver' /etc/resolv.conf | awk '{print $2}' \
        || echo "No nameservers found in /etc/resolv.conf."
else
    echo "/etc/resolv.conf not found."
fi

# ── Public IP Address ─────────────────────────────────────────────────────────
section "Public IP Address"
PUBLIC_IP=""
for service in "https://api.ipify.org" "https://ifconfig.me" "https://icanhazip.com"; do
    PUBLIC_IP=$(curl -s --max-time 5 "$service" 2>/dev/null || true)
    [[ -n "$PUBLIC_IP" ]] && break
done
if [[ -n "$PUBLIC_IP" ]]; then
    echo "$PUBLIC_IP"
else
    echo "Could not determine public IP (no internet access or curl unavailable)."
fi

# ── Connectivity Check ────────────────────────────────────────────────────────
section "Connectivity Check"
HOSTS=("8.8.8.8" "1.1.1.1" "google.com")
for host in "${HOSTS[@]}"; do
    if ping -c1 -W2 "$host" &>/dev/null; then
        echo -e "${GREEN}✔${RESET} $host is reachable"
    else
        echo -e "${RED}✘${RESET} $host is unreachable"
    fi
done
