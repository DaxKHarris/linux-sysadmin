#!/bin/bash

# Assuming admin-team already exists, and has sudo privilege. 

admin_flag=false
username=""
company_name="Megacorp"
default_pass="${company_name}$(date +%Y)"

# === Parse arguments ===

for arg in "$@"; do
    case $arg in
        --admin)
            admin_flag=true
            ;;
        --help)
            echo "Usage: $0  [--admin] username"
            exit 0
            ;;
        -*)
            echo "Uknown option '$arg'"
            exit 1
        *)
            username=$arg
            ;;
    esac
done

read -p "Are you sure you want to create user: $username [Y/n]" confirm
confirm=${confirm,,}

if [[ $confirm == "n" ]]; then
    echo "User creation cancelled"
    exit 0
fi


if [[ -z $username ]]; then
    echo "No username provided."
    echo "Usage: $0 [--admin] username"
    exit 1
fi

# === Create user ===
echo "Creating user: $username"
sudo useradd -m "$username"

# === Set default pass and force change at first login ===
echo "$username:${default_pass}" | sudo chpasswd
sudo chage -d 0 "$username"

# === Add to admin group if requested ===
if [[ $admin_flag == true ]]; then
    echo "Adding $username to the admin-team"
    sudo usermod -aG admin-team "$username"
fi

echo "User '$username' create successfully."
[[ $admin_flag == true ]] && echo "Granted sudo access via admin-team"
