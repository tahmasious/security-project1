#!/bin/bash

# Check if nmap is installed
command -v nmap >/dev/null 2>&1 || { echo >&2 "Nmap is not installed. Please install it and try again."; exit 1; }

# Get subnet from user
read -p "Enter the subnet (e.g., 127.10.20.0/24): " subnet

# Perform nmap scan and save results to a CSV file
nmap -p 22 --open $subnet -oG - | awk '/^Host/{print $2}' | sort -u > host_ips.csv

echo "Scan completed. Host IPs saved to host_ips.csv"

