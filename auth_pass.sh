#!/bin/bash
sudo usermod -aG root ubuntu
# sudo chmod g+wx /etc/ssh/*
# sudo chmod g+wx /etc/ssh/

File="/etc/ssh/sshd_config"
Temp_file="temp_config"

if [[ -f $Temp_file ]]
then
    rm -f $Temp_file
fi

touch $Temp_file

while read -r line
do
    current_line=$( echo $line | grep "PasswordAuthentication no" )

    if [[ $current_line ]]
    then
        echo "PasswordAuthentication yes" >> $Temp_file
    else
        echo $line >> $Temp_file
    fi
done < $File

sudo cp $File /etc/ssh/sshd_config.bak
sudo rm -f $File
sudo mv $Temp_file $File