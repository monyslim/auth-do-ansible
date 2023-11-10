#!/bin/bash
declare -a users
sudo su
users=("james:password1" 
       "john:password2")

# Run the command with sudo

sudo bash -c
for item in "${users[@]}"
    do
    user=$(echo "$item" | cut -d: -f1)
    password=$(echo "$item" | cut -d: -f2)

    user_home="/home/$user"

    # Check if the user already exists
    if id "$user" &>/dev/null; then
        echo "User $user already exists. Skipping creation."
    else
        sudo useradd -m -s /bin/bash "$user"
        echo "$user:$password" | sudo chpasswd
        sudo chmod -R 700 "/home/$user" # Sets permissions for the user's home directory
        echo "User $user created."
    fi
done


exit


