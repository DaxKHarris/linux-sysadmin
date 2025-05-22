#!/bin/bash

# === Setup ===
config="/etc/ssh/sshd_config"
backup="/etc/ssh/sshd_config.bak"
port="2222"

# === Backup sshd_config file ===
sudo cp "$config" "$backup"
echo "Backed up $config to $backup"

# === Modify sshd_config for security ===
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' $config
echo 'Root secured'
sudo sed -i "s/^#\?Port .*/Port ${port}/" $config
echo "Port changed to $port"
sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' $config
echo 'Brute force protected'
sudo systemctl restart sshd
echo 'SSH hardened. You are safe.'