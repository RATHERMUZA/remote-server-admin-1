#!/bin/bash

# Define blue and red color escape codes
BLUE='\033[0;34m'
RED='\033[0;31m'
# Reset color escape code
RESET='\033[0m'

# Function to display colorful headers
display_header() {
    local header_text="$1"
    echo -e "${BLUE}-----------------------------------${RESET}"
    echo -e "${BLUE}$header_text${RESET}"
    echo -e "${BLUE}-----------------------------------${RESET}"
}

# Function to create source files with specified content
create_source_files() {
    echo "Creating source files with content..."
    echo "Hello World Welcome To Automation" > scp_file1
    echo "Hello World Welcome To Automation" > scp_file2
    echo "Hello World Welcome To Automation" > scp_file3
    echo "Hello World Welcome To Automation" > scp_file4
    echo "Hello World Welcome To Automation" > scp_file5
}

# Function to install Apache2 on a remote server
install_apache() {
    local user="$1"
    local ip="$2"

    echo -e "${BLUE}Installing Apache2 on $user@$ip...${RESET}"
    ssh "$user@$ip" 'sudo apt update && sudo apt install -y apache2'
    echo -e "${BLUE}Apache2 installed on $user@$ip${RESET}"
}

# Function to install Nginx on a remote server
install_nginx() {
    local user="$1"
    local ip="$2"
    read -p "Do you want to install Nginx on $user@$ip? (yes/no): " nginx_choice

    if [ "$nginx_choice" = "yes" ]; then
        echo -e "${BLUE}Installing Nginx on $user@$ip...${RESET}"
        ssh "$user@$ip" 'sudo apt update && sudo apt install -y nginx && sudo systemctl enable nginx && sudo systemctl start nginx'
        echo -e "${BLUE}Nginx installed, started, and enabled on $user@$ip${RESET}"
    else
        echo -e "${BLUE}Nginx installation skipped on $user@$ip${RESET}"
    fi
}

# Function to perform SCP to remote servers
perform_scp_to_remote() {
    local destination_dir="$1"
    local user="$2"
    local ip="$3"

    echo -e "${BLUE}Transferring files to $user@$ip:$destination_dir...${RESET}"
    cd "$(dirname "$0")" || exit 1

    if [ -e scp_file1 ] && [ -e scp_file2 ] && [ -e scp_file3 ] && [ -e scp_file4 ] && [ -e scp_file5 ]; then
        ssh "$user@$ip" "mkdir -p $destination_dir"
        scp scp_file1 scp_file2 scp_file3 scp_file4 scp_file5 "$user@$ip:$destination_dir"
        echo -e "${BLUE}Files copied to $user@$ip:$destination_dir${RESET}"
    else
        echo -e "${RED}Source files not found.${RESET}"
    fi
}

# Function to gather system information from a remote server
gather_system_info() {
    local user="$1"
    local ip="$2"
    local logs_dir="$3"

    echo -e "${BLUE}Gathering system information from $user@$ip...${RESET}"

    # Memory (RAM) usage
    echo -e "${RED}Memory (RAM) usage:${RESET}"
    ssh "$user@$ip" 'free -m'
    sleep 3  # Sleep for 3 seconds

    # Disk space usage
    echo -e "${RED}Disk space usage:${RESET}"
    ssh "$user@$ip" 'df -h'
    sleep 3  # Sleep for 3 seconds

    # Block devices
    echo -e "${RED}Block devices:${RESET}"
    ssh "$user@$ip" 'lsblk'
    sleep 3  # Sleep for 3 seconds

    # Uptime and load average
    echo -e "${RED}Uptime and load average:${RESET}"
    ssh "$user@$ip" 'uptime'
    sleep 3  # Sleep for 3 seconds

    # CPU information
    echo -e "${RED}CPU information:${RESET}"
    ssh "$user@$ip" 'lscpu'
    sleep 3  # Sleep for 3 seconds

    # Network information
    echo -e "${RED}Network information:${RESET}"
    ssh "$user@$ip" 'ip addr show'
    sleep 3  # Sleep for 3 seconds

    echo "System information gathered from $user@$ip"
}

# Main script starts here

# Display colorful header with author's name and description
display_header "Automated Deployment Script by Raja Ramees"
echo "Description: This script automates the deployment process by installing Apache2 or Nginx, transferring files using SCP, and gathering system information from remote servers."

# Create source files with specified content
create_source_files

# Define server IPs and corresponding usernames
web01_ip="192.168.33.10"
web02_ip="192.168.33.11"
web01_user="devops"
web02_user="tom"
client_logs_dir="remote_logs"

# Install Apache2 on web01
install_apache "$web01_user" "$web01_ip"

# Install Apache2 on web02
install_apache "$web02_user" "$web02_ip"

# Install Nginx option
display_header "Nginx Installation Option"
install_nginx "$web01_user" "$web01_ip"
install_nginx "$web02_user" "$web02_ip"

# Transfer files using SCP
display_header "SCP File Transfer"
perform_scp_to_remote "scp_dir/" "$web01_user" "$web01_ip"
perform_scp_to_remote "scp_dir/" "$web02_user" "$web02_ip"

# Gather system information from web01
gather_system_info "$web01_user" "$web01_ip" "$client_logs_dir"

# Gather system information from web02
gather_system_info "$web02_user" "$web02_ip" "$client_logs_dir"

