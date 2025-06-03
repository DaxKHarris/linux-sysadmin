#!/bin/bash

FILE_ROOT="/home/daxkharris/Documents/Git/sysadmin/bash-scripts/service-status/status-logger.sh"
LOG=/var/log/service.log
TIMESTAMP=$(date +%Y-%m-%d_%H:%M:%S)
add_service=false
rm_service=false
skip=false
declare -A seen
GREEN='\e[32m'
RED='\e[31m'
NC='\e[0m'

my_services=("sshd" "NetworkManager" "iptables" "cronie")

log() {
    echo -e "$2 $1$NC"
    echo "${1}" | sudo tee -a $LOG > /dev/null
}

if [[ ${#my_services[@]} -eq 1 && -z "${my_services[0]}" ]]; then
    my_services=()
fi

for arg in "$@"; do
    case "$arg" in
        --add)
            if ! $add_service && ! $rm_service; then
                for item in "${my_services[@]}"; do
                    seen["$item"]=1
                done
                add_service=true
            else
                echo "Error. Either you goofed or the code goofed. tbd."
                exit 1
            fi
            ;;
        --remove)
            if ! $add_service && ! $rm_service; then
                for item in "${my_services[@]}"; do
                    seen["$item"]=1
                done
                rm_service=true
            else
                echo "Both flags were added, or duplicate flags this is contradictory"
                exit 1
            fi
            ;;
        --skip-checks)
            skip=true
            ;;
        --*)
            echo "This isn't made yet."
            ;;

        *)
            if $add_service; then
                if [[ -z "${seen[$arg]}" ]]; then
                    my_services+=("$arg")
                    seen["$arg"]=1
                fi
            elif $rm_service; then
                if [[ -n "${seen[$arg]}" ]]; then
                    new_items=()
                    for i in "${my_services[@]}"; do
                        [[ "$i" != "$arg" ]] && new_items+=("$i")
                    done
                    my_services=("${new_items[@]}")
                    unset seen["$arg"]
                fi
            fi
            ;;
    esac
done

if $add_service || $rm_service ; then

    quoted_items=$(printf '"%s" ' "${my_services[@]}")
    quoted_items="${quoted_items%" "}"
    new_array_line="my_services=($quoted_items)"
    sed -i "s/^my_services=.*/$new_array_line/" "$FILE_ROOT"
fi

if ! $skip ; then
    log $TIMESTAMP
    log "----------------------------"
    for item in "${my_services[@]}"; do
        status="$(systemctl is-active ${item})"
        if [ "$status" == "active" ]; then
            log "${item} is ${status}" $GREEN
        elif [ "$status" == "inactive" ]; then
            log "${item} is ${status}" $RED 
        fi
    done
fi
