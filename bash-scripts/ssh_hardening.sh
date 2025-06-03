#!/bin/bash

SSH_MAIN=/etc/ssh/sshd_config
SSH_BAK=/etc/ssh/sshd_config.bak
PORT=$(( (RANDOM % 10000) + 30000 ))
RESTORE=false
PASSWORDAUTH="no"

for arg in "$@" do
    if [ -n "$arg" ]; then
        case $arg in
            --restore)
                PORT=22
                PASSWORDAUTH="yes"
                ;;
            --port=*)
                PORT="${arg#*=}"
                ;;
            -*)
                echo "Invalid argument"
                exit 1
                ;;
            *)
                echo "Invalid argument"
                exit 1
                ;;
        esac
    fi
done



sudo cp $SSH_MAIN $SSH_BAK

echo "sshd was copied with code: $?"

sudo sed -i "s/^#\?[[:space:]]*PasswordAuthentication.*/PasswordAuthentication ${PASSWORDAUTH}/" "$SSH_MAIN"
echo "Password Authentication was changed to no with code $?"
sudo sed -i "s/^#\?[[:space:]]*Port.*/Port ${PORT}/" "$SSH_MAIN"
echo "Port was changed to $PORT with code $?"

sudo systemctl restart sshd && echo "SSH hardening was successful and exited with code $?"

echo "New port is: ${PORT}" > ~/ssh_info.txt
