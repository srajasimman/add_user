#!/bin/bash

# check if ansible install is installed
if ! [ -x "$(command -v ansible)" ]; then
    echo "ansible is not installed"
    sudo apt-get update -y && sudo apt-get install ansible -y || exit 1
fi

user_name="$1"
ssh_key="$2"
password="$3"

if [[ -z "$user_name" ]] || [[ -z "$ssh_key" ]]; then
    echo "Usage: $0 <user_name> <ssh_key> <password>"
    exit 1
fi

if [[ -z "$password" ]]; then
    password=$(date +%s | sha256sum | base64 | head -c 32)
fi

if [[ ! -f "./add_user.yml" ]]; then
    wget -O ./add_user.yml https://raw.githubusercontent.com/srajasimman/add_user/main/add_user.yml || exit 1
fi

ansible-playbook add_user.yml --extra-vars "user_name=$user_name ssh_key='$ssh_key' password=$password"
