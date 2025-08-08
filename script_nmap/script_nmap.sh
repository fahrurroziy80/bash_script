#!/bin/bash

# Define the network range (change this to fit your environment)
NETWORK="192.168.1.0/24"

# Output file
OUTPUT_FILE="nmap_svscan_results.txt"

# Temp file to store live hosts
LIVE_HOSTS="live_hosts.txt"

echo "[*] Scanning for live hosts in $NETWORK..."
nmap -sn $NETWORK -oG - | awk '/Up$/{print $2}' > $LIVE_HOSTS

echo "[*] Found $(wc -l < $LIVE_HOSTS) live host(s)."

# Clear output file before writing
> $OUTPUT_FILE

# Scan each live host for open ports and service versions
while read HOST; do
    echo "[*] Scanning $HOST with service/version detection..."
    echo "====== $HOST ======" >> $OUTPUT_FILE
    nmap -sV $HOST >> $OUTPUT_FILE
    echo -e "\n" >> $OUTPUT_FILE
done < $LIVE_HOSTS

echo "[*] Scan completed. Results saved to $OUTPUT_FILE"
