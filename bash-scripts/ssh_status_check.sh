#!/bin/bash

# === setup ===
config=/etc/ssh/sshd_config
backup=/etc/ssh/sshd_config.bakC
concern=0

# === backup ssh conf ===

sudo cp $config $backup

# === Check if ssh is running ===
if [ ! systemctl is-active --quiet sshd ]; then
    echo "SSH is not running"
    exit 1
fi

if [ awk '/^#?\s*PasswordAuthentication/ { print $2 }' $config == 'yes' ]; then
    ((concern++))
    echo "Password Authentication is on."
fi

if [ grep -E '']
