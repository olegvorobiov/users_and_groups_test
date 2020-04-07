#!/bin/bash
#
source /scripts/variables.txt
grep "first_name" /root/.bashrc &>/dev/null
if (( $?==0 ))
then
    disaster.sh
    echo
    . /root/.bashrc
    echo "$first_name $last_name started on $(date)" | tee $detailed_report $short_report > /dev/null
    echo "You can start on your test"
else
    disaster.sh
    echo
    echo
    read -p "Please enter your first name then press Enter: " first_name
    echo
    read -p "Please enter your last name then press Enter: " last_name
    echo "$first_name$last_name" > /etc/hostname
    echo "$first_name $last_name started on $(date)" | tee $detailed_report $short_report > /dev/null
    echo "first_name=\"$first_name\"" >> /root/.bashrc
    echo "last_name=\"$last_name\"" >> /root/.bashrc
    echo
    echo "Hello, $first_name $last_name, please reboot your virtual machine"
    echo
    echo "Type reboot and press Enter"
    echo 
    echo "Good luck!"
fi