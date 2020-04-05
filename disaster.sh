#!/bin/bash
#
#simple deleting of created things
#
#deleting groups, retuning to original state 
#
cut -d ":" -f1 /etc/group > /scripts/temp/etc_group_list.txt
cut -d ":" -f1 /scripts/original_copy/etc_group_orig.txt > /scripts/temp/etc_group_list_orig.txt
cat /scripts/temp/etc_group_list.txt /scripts/temp/etc_group_list_orig.txt | sort | uniq -u > /scripts/temp/group_delete_list.txt
for j in $(cat /scripts/temp/group_delete_list.txt)
do
	groupdel -f $j
done
#
#deleting users, returning to original state
#
cut -d ":" -f1 /etc/passwd > /scripts/temp/etc_passwd_list.txt
cut -d ":" -f1 /scripts/original_copy/etc_passwd_orig.txt > /scripts/temp/etc_passwd_list_orig.txt
cat /scripts/temp/etc_passwd_list.txt /scripts/temp/etc_passwd_list_orig.txt | sort | uniq -u > /scripts/temp/users_delete_list.txt
for i in $(cat /scripts/temp/users_delete_list.txt)
do
	userdel -r $i
done
#
#
#deleting directories
#
rm -rf /projects
#
#deleting sudo privilages
#
sed -i "s/^oleg.*/ /" /etc/sudoers
sed -i "s/^vadim.*/ /" /etc/sudoers
sed -i "s/^alex.*/ /" /etc/sudoers
sed -i "s/^mohammad.*/ /" /etc/sudoers
sed -i "s/^\%engineering.*/ /" /etc/sudoers
rm -rf /etc/sudoers.d/*
#
#deleting temporary files
#
rm -rf /scripts/temp/*
rm -rf /scripts/reports/*
#
#deleting logs
#
cat /dev/null > /var/log/secure
cat /dev/null > /var/log/messages
cat /dev/null > /root/.bash_history
#
#returning /etc/login.defs to original state
#
sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 99999/" /etc/login.defs
sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/" /etc/login.defs
#
#finish
#
#
#
