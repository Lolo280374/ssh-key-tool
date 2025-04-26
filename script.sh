#!/bin/bash

# amogus's SSH key manager
#
# This script is used as a way to help users as fast as possible by instead of sharing their server's password, they add my SSH key, and I have access to their server.
# Idea inspired by Virtfusion, GPT-4o helped with this lol
# This is the new version of the script, accessible via:
#   $ wget -qO- https://ssh.amogus.works/script.sh | bash
#
# We also have a legacy version of the script, which is no longer maintained, accessible via:
#   $ wget -qO- https://ssh.amogus.works/old.sh | bash
# 
# Have fun! Made with ❤️ by amogus

help() {
    echo -e "\033[92m● Usage:\e[0m"
    echo -e "  ssh.sh [add|remove|check|help]"
    echo ""
    echo -e "\033[92m● Options:\e[0m"
    echo -e "  \e[33m○ add\e[0m     - Installs the SSH key."
    echo -e "  \e[33m○ remove\e[0m  - Removes the SSH key."
    echo -e "  \e[33m○ check\e[0m   - Checks if the SSH key is installed."
    echo -e "  \e[33m○ help\e[0m    - Displays this help message."
    echo ""
    echo -e "\033[92m● GitHub Repository:\e[0m"
    echo -e "  \e[33m○ https://github.com/Lolo280374/ssh-key-tool/\e[0m"
    exit 0
}

add() {
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/authorized_keys

    grep -F -e "lolodotzip@pm.me" -e "lolodotzip's personal key" ~/.ssh/authorized_keys >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "\033[93m● already installed!\e[0m"
    else
        echo -e "\e[36m○ downloading...\e[0m"
        wget https://cdn.lolodotzip.lol/keys/master.pub -O "${TMP_DOWNLOAD_LOCATION}/__tmp___lolodotzip___key" >/dev/null 2>&1

        echo -e "\e[36m○ downloading checksum...\e[0m"
        wget https://cdn.lolodotzip.lol/keys/master-key.checksum -O "${TMP_DOWNLOAD_LOCATION}/__tmp___lolodotzip__key___check" >/dev/null 2>&1

        echo -e "\e[36m○ checking key using SHA-1...\e[0m"
        CHECKSUM=$(awk '{ print $1 }' "${TMP_DOWNLOAD_LOCATION}/__tmp___lolodotzip__key___check")
        KEYSUM=$(sha1sum "${TMP_DOWNLOAD_LOCATION}/__tmp___lolodotzip___key" | awk '{ print $1 }')

        if [ "${CHECKSUM}" == "${KEYSUM}" ]; then
            echo -e "\033[92m● successfully installed!\e[0m"
            echo -e "\e[36m○ installing ssh key...\e[0m"
            SSH_KEY=$(cat "${TMP_DOWNLOAD_LOCATION}/__tmp___lolodotzip___key")
            echo "${SSH_KEY}" >> ~/.ssh/authorized_keys
            rm -f "${TMP_DOWNLOAD_LOCATION}/__tmp___lolodotzip___key"
            rm -f "${TMP_DOWNLOAD_LOCATION}/__tmp___lolodotzip__key___check"
            echo -e "\033[92m● successfully installed!\e[0m"
            echo ""
            next_steps
            echo ""
            save_next_steps
        else
            echo -e "\e[1;31m● installation failed. - checksums did not match. your file might be corrupted.\e[0m"
        fi
    fi

    echo -e "\e[36m○ setting ssh permissions...\e[0m"
    chmod 600 ~/.ssh/authorized_keys
}

remove_ssh_key() {
    grep -F -e "lolodotzip@pm.me" -e "lolodotzip's personal key" ~/.ssh/authorized_keys >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo -e "\e[1;31m● key wasn't found. you can't delete it if it's not installed.\e[0m"
    else
        sed -i '/lolodotzip@pm.me/d' ~/.ssh/authorized_keys
        sed -i "/lolodotzip's personal key/d" ~/.ssh/authorized_keys
        echo -e "\033[92m● successfully removed the key!\e[0m"
    fi
}

check_ssh_key() {
    grep -F -e "lolodotzip@pm.me" -e "lolodotzip's personal key" ~/.ssh/authorized_keys >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "\033[92m● key is currently installed.\e[0m"
        echo -e "\033[92m○ to remove it, run the following command:\e[0m"
        echo -e "  \e[33mwget -qO- https://cdn.lolodotzip.lol/ssh.sh | bash -s -- remove\e[0m"
    else
        echo -e "\033[93m● currently not installed.\e[0m"
        echo -e "\033[92m○ to install my SSH key, run the following command:\e[0m"
        echo -e "  \e[33mwget -qO- https://cdn.lolodotzip.lol/ssh.sh | bash -s -- add\e[0m"
    fi
}

next_steps() {
    echo -e "\e[36m=========================================\e[0m"
    echo -e "\033[92m            what now?                  \e[0m"
    echo -e "\e[36m=========================================\e[0m"
    echo -e "\033[92m● What you can do next:\e[0m"
    echo -e "  \e[33m○ give me your ip:\e[0m if you needed support and I gave you this command, please send me your server's IP and ssh port. I will need it to help you."
    echo -e "    \e[1;31m○ Please, do not share your server's password, as I will not use it. If you are still using passwords, I recommend migrating to SSH Keys. It's safer.\e[0m"
    echo -e "  \e[33m○ Remove the SSH key:\e[0m Use \`wget -qO- https://cdn.lolodotzip.lol/ssh.sh | bash -s -- remove\` if you no longer need the key."
    echo -e "  \e[33m○ Check key status:\e[0m Use \`wget -qO- https://cdn.lolodotzip.lol/ssh.sh | bash -s -- check\` to confirm if the key is installed."
    echo -e "  \e[33m○ Visit the repository:\e[0m Check out the GitHub repo at \e[33mhttps://github.com/Lolo280374/ssh-key-tool\e[0m for updates."
    echo -e "\e[36m=========================================\e[0m"
}

save_next_steps() {
    cat <<EOF > ~/next_steps.txt
=========================================
            what now?                  
=========================================
● What you can do next:
  ○ give me your ip:
    If you need support and I asked you to run this script, please share your server's IP address, as well as your SSH port.
    ○ Please, do not share your server's password, as I will not use it. If you are still using passwords, I recommend migrating to SSH Keys. It's safer.
  ○ Remove the SSH key:
    Use \`wget -qO- https://cdn.lolodotzip.lol/ssh.sh | bash -s -- remove\` if you no longer need the key.
  ○ Check key status:
    Use \`wget -qO- https://cdn.lolodotzip.lol/ssh.sh | bash -s -- check\` to confirm if the key is installed.
  ○ Visit the repository:
    Check out the GitHub repo at https://github.com/Lolo280374/ssh-key-tool for updates.
=========================================
EOF
    echo -e "\033[92m● this message has also been saved to the next_steps.txt file.\e[0m"
}

SSH_KEY=''
TMP_DOWNLOAD_LOCATION=$(mktemp -d)
OPTION=$1

case "$OPTION" in
    add)
        add
        ;;
    remove)
        remove_ssh_key
        ;;
    check)
        check_ssh_key
        ;;
    --help|help|-h)
        help
        ;;
    *)
        echo -e "\e[1;31m● i don't know that argument or command. check help for more information.\e[0m"
        ;;
esac
