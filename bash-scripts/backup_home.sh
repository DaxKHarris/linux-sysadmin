#!/bin/bash


# === Initial setup ===
user = $1
backup_root="/backups/$user"
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_file="$backup_root/home_${user}_$timestamp.tar.gz"
home_dir="/home/$user"

# === Error handling ===
if [[ -z "$user" ]]; then
    echo "Empty user var"
    echo "Usage $0 username"
fi

if ! id "$user" &>/dev/null; then
    echo "User $user does not exist."
    exit 1
fi

if [[ ! -d "$home_dir" ]]; then
    echo "Home directory $home_dir does not exist."
    exit 1
fi

# === Make directory and backup ===
mkdir -p "$backup_root"

tar -czf "$backup_file" "$home_dir"

echo "Backup for $user complete: $backup_file"