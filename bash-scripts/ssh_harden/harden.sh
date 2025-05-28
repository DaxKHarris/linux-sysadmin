#!/bin/bash

source ./ssh.conf
ssh_conf=/etc/ssh/sshd_config
ssh_backup=/etc/ssh/sshd_config.bak

rollback() {
    sudo cp $ssh_backup $ssh_conf
}

if [ -n "$1" ]; then
    case $1 in
        --rollback)
            rollback
            exit 0
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

sudo cp $ssh_conf $ssh_backup

sed -i "s/#\?Port.*/Port ${SSH_PORT}/" $ssh_conf
sed -i "s/#\?PasswordAuthentication.*/PasswordAuthentication ${PASSWORD_AUTH}/" $ssh_conf
sed -i "s/#\?PermitRootLogin.*/PermitRootLogin ${PERMIT_ROOT_LOGIN}/" ${ssh_conf}

sudo systemctl restart sshd && echo "SSH Hardening Successful!"