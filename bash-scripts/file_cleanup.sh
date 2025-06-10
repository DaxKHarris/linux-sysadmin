#!/bin/bash

if [ -z "$1" ]; then
    echo "No directory passed in: exiting."
    exit 1
fi

cd "$1"
if [ $? -ne 0 ]; then
    echo "Error: Directory not found."
    exit 1
fi 

mkdir -p duplicates
declare -A file_hash

while IFS= read -r file; do
    hash=$(sha256sum "$file" | awk '{print $1}')
    if [[ -n "${file_hash[$hash]}" ]]; then
        echo "Duplicate found: $file"
        mv "$file" duplicates/
    else
        echo "Not a dup"
        file_hash["$hash"]="$file"
    fi
done < <(find -type f)
