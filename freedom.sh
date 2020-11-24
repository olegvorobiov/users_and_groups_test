#!/bin/bash
# Sourcing variables
source /scripts/variables.txt
#
#function to create fine report
#
fine_report (){
	echo "########## TASK $1 ##########" | tee -a $short_report
	if (( $2==$3 ))
	then
		echo "Completed successfully, you gained $2 scores" | tee -a $short_report
	else 
		echo "Ooops you failed following parts of the task" | tee -a $short_report
		grep "TASK $1" -A $3 $detailed_report | grep "failed" | tee -a $short_report
		echo "You gained $2 scores" | tee -a $short_report
	fi
	echo "Total score for Task $1 is $2 out of $3" | tee -a $short_report
}
#
#
######################################### TASK # 1 ###########################################################
#
echo "Test submited: $(date)" >> $detailed_report
echo "########## TASK 1 ########## " >> $detailed_report
#checking users
#
test_score=0
task1_score=0
#
#checking if username exists
#
for i in $(cat /scripts/lists/usernames.txt)
do
	grep "$i" /etc/passwd > /dev/null
	if (( $?==0 ))
	then
		echo "User $i was created + 1 point" >> $detailed_report
		((task1_score++))
		((test_score++))
	else
		echo "User $i wasn't created - failed" >> $detailed_report
	fi
done
#
#checking if all of the fields from /etc/passwd match
#
for i in $(cat /scripts/lists/usernames.txt)
do
	for field_name in {3..7}
	do
		field=$(grep "$i" /etc/passwd | cut -d ":" -f "$field_name" && grep "$i" /scripts/lists/etc_passwd_template.txt | cut -d ":" -f "$field_name")
		field_chk=$(echo $field | sed "s/ /\n/g" | sort | uniq -u | wc -l)
		case $field_name in
		3 )
		field_name="uid" ;;
		4 )
		field_name="gid" ;;
		5 )
		field_name="comment" ;;
		6 )
		field_name="home_directory" ;;
		7 )
		field_name="shell" ;;
		esac
		if (( $field_chk==0 ))
		then
			echo "User $i has $field_name set correctly + 1 point" >> $detailed_report
			((task1_score++))
			((test_score++))
		else
			echo "User $i has $field_name set incorrectly - failed" >> $detailed_report
		fi
	done
done
#
#
#checking if passwords are set
#
if [[ $(grep "system-user" /etc/shadow | cut -d ":" -f2) == '!!' ]]
	then
		echo "User system-user doesn't have a password + 1 point" >> $detailed_report
		((task1_score++))
		((test_score++))
	else
		echo "User system-user has a password - failed" >> $detailed_report
fi
#
for i in chantelle jacob vadim oleg alex peter mohammad
do
	if [[ -d /home/$i && /home/$i = $(grep "$i" /etc/passwd | cut -d ":" -f6) ]]
	then
		echo "exit" >> /home/$i/.bashrc
		sshpass -p password ssh $i@127.0.0.1 > /dev/null
		if (( $?==0 ))
		then
			echo "Password is password for user $i + 1 point" >> $detailed_report
			((task1_score++))
			((test_score++))
		else
			echo "Password isn't password for user $i - failed" >> $detailed_report
		fi
		sed -i "s/^exit/ /" /home/$i/.bashrc
	else
		echo "User $i home directory isn't set correct, cannot check password - failed" >> $detailed_report
	fi
done
#
#
#
#
#checking groups
#
#
#checking if groups were created
#
for i in $(cat /scripts/lists/group_list.txt)
do
	grep "$i\>" /etc/group > /dev/null
	if (( $?==0 ))
	then
		echo "Group $i was created + 1 point" >> $detailed_report
		((task1_score++))
		((test_score++))
	else
		echo "Group $i wasn't created - failed" >> $detailed_report
	fi
done
#
#checking if group id matches
#
for i in $(cat /scripts/lists/group_list.txt)
do
	GID=$(grep "$i\b" /etc/group | cut -d ":" -f3 && grep "$i\b" /scripts/lists/etc_group_template.txt | cut -d ":" -f3)
	GID_chk=$( echo $GID | sed "s/ /\n/" | uniq -u | wc -l)
	if (( $GID_chk==0 ))
	then
		echo "Group $i GID set correctly + 1 point" >> $detailed_report
		((task1_score++))
		((test_score++))
	else
		echo "Group $i GID set incorrectly - failed" >> $detailed_report
	fi
done
#
#checking if users are part of hiring and migration groups
#
for i in chantelle alex peter
do
	grep "hiring\b" /etc/group | grep "$i" > /dev/null
	if (( $?==0 ))
	then
		echo "User $i is a part of hiring group + 1 point" >> $detailed_report
		((task1_score++))
		((test_score++))
	else
		echo "User $i isn't a part of hiring group - failed" >> $detailed_report
	fi
done
for i in jacob vadim oleg mohammad
do
	grep "migration\b" /etc/group | grep "$i" > /dev/null
	if (( $?==0 ))
	then
		echo "User $i is a part of migration group + 1 point" >> $detailed_report
		((task1_score++))
		((test_score++))
	else
		echo "User $i isn't part of migration group - failed" >> $detailed_report
	fi
done
echo "Total scores for 1st task: $task1_score out of 77" >> $detailed_report
#
#
###########################################################################################################################
###########################################################################################################################
######################################### TASK # 2 ###########################################################
###########################################################################################################################
###########################################################################################################################
#
echo "########## TASK 2 ########## " >> $detailed_report
#
#
#checking sudo privileges
#
#collecting user and group info from possible sources
#
task2_score=0
grep "\%engineering" /etc/sudoers >> /scripts/temp/sudoers_check.txt
grep "\<mohammad\>" /etc/sudoers >> /scripts/temp/sudoers_check.txt
grep "wheel" /etc/group | grep "mohammad" >> /scripts/temp/sudoers_check.txt
cat /etc/sudoers.d/* >> /scripts/temp/sudoers_check.txt
#
#checking if engineering and mohammad is in the file
#
for i in mohammad %engineering
do
	grep "$i" /scripts/temp/sudoers_check.txt > /dev/null
	if (( $?==0 ))
	then
		echo "$i has sudo privileges + 1 point" >> $detailed_report
		((task2_score++))
		((test_score++))
	else
		echo "$i doesn't have sudo privileges - failed" >> $detailed_report
	fi
done
echo "Total scores for 2nd task: $task2_score out of 2" >> $detailed_report
echo "Total scores so far: $test_score" >> $detailed_report
#
#
###########################################################################################################################
###########################################################################################################################
######################################### TASK # 3 ###########################################################
###########################################################################################################################
###########################################################################################################################
#
echo "########## TASK 3 ########## " >> $detailed_report
#
#
#checking 180 days pasword expiration and 10 days notification
#
task3_score=0
for i in chantelle jacob vadim oleg alex peter system-user
do
	max_days=$(grep "$i" /etc/shadow | cut -d ":" -f5)
	warning_days=$(grep "$i" /etc/shadow | cut -d ":" -f6)
	if (( $max_days==180 ))
	then
		echo "Max password days 180 user $i is set + 1 point" >> $detailed_report
		((task3_score++))
		((test_score++))
	else 
		echo "Max password days 180 user $i isn't set - failed" >> $detailed_report
	fi
	if (( $warning_days==10 ))
	then
		echo "Pass warn days 10 for user $i is set + 1 point" >> $detailed_report
		((task3_score++))
		((test_score++))
	else 
		echo "Pass warn days 10 for user $i isn't set - failed" >> $detailed_report
	fi
done
#
#checking Mohammad's account expiration date
#
days_before_exp=$(($(grep "mohammad" /etc/shadow | cut -d ":" -f8)-$(grep "mohammad" /etc/shadow | cut -d ":" -f3)))
if (( $days_before_exp>=88 && $days_before_exp<=92 ))
then
	echo "Mohammad's account expiration set correctly + 1 point" >> $detailed_report
	((task3_score++))
	((test_score++))
else
	echo "Mohammad's account expiration set incorrectly - failed" >> $detailed_report
fi
#
#checking login.defs
#
pass_max=$(grep "^PASS_MAX_DAYS" /etc/login.defs | tr -s " " | cut -d " " -f2)
pass_warn=$(grep "^PASS_WARN_AGE" /etc/login.defs | tr -s " " | cut -d " " -f2)
if (( $pass_max==180 ))
then
	echo "New users have password expiration in 180 days is set + 1 point" >> $detailed_report
	((task3_score++))
	((test_score++))
else
	echo "New users have password expiration in 180 days isn't set - failed" >> $detailed_report
fi
if (( $pass_warn==10 ))
then
	echo "New users have password warning 10 days in a advance is set + 1 point" >> $detailed_report
	((task3_score++))
	((test_score++))
else
	echo "New users have password warning 10 days in a advance isn't set - failed" >> $detailed_report
fi
echo "Total scores for 3rd task: $task3_score out of 17" >> $detailed_report
echo "Total scores so far: $test_score" >> $detailed_report
#
#
###########################################################################################################################
###########################################################################################################################
######################################### TASK # 4 ###########################################################
###########################################################################################################################
###########################################################################################################################
#
echo "########## TASK 4 ########## " >> $detailed_report
#
#
#checking if dcm and hiring directories exist
#
task4_score=0
for i in /projects /projects/hiring /projects/dcm
do 
	if [ -d $i ]
	then
		echo "Directory $i created + 1 point" >> $detailed_report
		((task4_score++))
		((test_score++))
	else
		echo "Directory $i isn't created - failed" >> $detailed_report
	fi
done
#
#checking if PATH variable edited
#
for i in chantelle alex peter
do
	if [ $(grep "^PATH" /home/$i/.bash_profile | awk -F: '{print $NF}') == '/projects/hiring' ]
	then
		echo "Path "/projects/hiring/" is in user's $i .bash_profile file is edited + 1 point" >> $detailed_report
		((task4_score++))
		((test_score++))
	else
		echo "Path "/projects/hiring/" is in user's $i .bash_profile file isn't edited - failed" >> $detailed_report
	fi
done
#
for i in jacob vadim oleg mohammad
do
	if [ $(grep "^PATH" /home/$i/.bash_profile | awk -F: '{print $NF}') == '/projects/dcm' ]
	then
		echo "Path "/projects/dcm/" is in user's $i .bash_profile file is edited + 1 point" >> $detailed_report
		((task4_score++))
		((test_score++))
	else
		echo "Path "/projects/dcm/" is in user's $i .bash_profile file isn't edited - failed" >> $detailed_report
	fi
done
echo "Total scores for 4th task: $task4_score out of 10" >> $detailed_report
echo "Total scores so far: $test_score" >> $detailed_report
#
#
###########################################################################################################################
###########################################################################################################################
######################################### TASK # 5 ###########################################################
###########################################################################################################################
###########################################################################################################################
#
echo "########## TASK 5 ########## " >> $detailed_report
#
#
#checking if contractors were added by mohammad
#
for i in  contractor{1..5}
do
	grep "sudo: mohammad" /var/log/secure | grep "/sbin/useradd $i" > /dev/null
	if (( $?==0 ))
	then
		echo "User $i was created by mohammad + 1 point" >> $detailed_report
		((task5_score++))
		((test_score++))
	else
		echo "User $i was not added by mohammad failed" >> $detailed_report
	fi
done

echo "Total scores for 5th task: $task5_score out of 5" >> $detailed_report
echo "Total scores so far: $test_score" >> $detailed_report

#
#
###########################################################################################################################
###########################################################################################################################
######################################### TASK # 6 ###########################################################
###########################################################################################################################
###########################################################################################################################
#
echo "########## TASK 6 ########## " >> $detailed_report
#
#
task6_score=0
#
#checking if chantelle is an admin of all of the groups besides system
#
for i in hr engineering devops consultants hiring migration
do
	grep "$i\b" /etc/gshadow | cut -d ":" -f3 | grep "chantelle" > /dev/null
	if (( $?==0 ))
	then
		echo "User chantelle is an admin of $i group + 1 point" >> $detailed_report
		((task6_score++))
		((test_score++))
	else
		echo "User chantelle isn't an admin of $i group - failed" >> $detailed_report
	fi
done
#
#checking if contractors were added to consultants group by chantelle
#
for i in contractor{1..5}
do
	grep "user $i added by chantelle to group consultants" /var/log/secure > /dev/null
	if (( $?==0 ))
	then
		echo "User $i was added to group consultants by chantelle + 1 point" >> $detailed_report
		((task6_score++))
		((test_score++))
	else
		echo "User $i was not added to group consultants by chantelle failed" >> $detailed_report
	fi
done
#
echo "Total scores for 6th task: $task6_score out of 11" >> $detailed_report
#
#####################################################################################################################################
#####################################################################################################################################
#####################################################################################################################################
#
#creating a nice and clean report for Katherine
#
fine_report 1 $task1_score $task1_max_score
fine_report 2 $task2_score $task2_max_score
fine_report 3 $task3_score $task3_max_score
fine_report 4 $task4_score $task4_max_score
fine_report 5 $task5_score $task5_max_score
fine_report 6 $task6_score $task6_max_score
echo "Total test scores: $test_score out of 122" | tee -a $detailed_report $short_report
#
#
#showing created groups in report
#
echo "########## Added portion of /etc/group ##########" >> $detailed_report
cut -d ":" -f1 /etc/group > /scripts/temp/etc_group_list.txt
cut -d ":" -f1 /scripts/original_copy/etc_group_orig.txt > /scripts/temp/etc_group_list_orig.txt
cat /scripts/temp/etc_group_list.txt /scripts/temp/etc_group_list_orig.txt | sort | uniq -u > /scripts/temp/group_delete_list.txt
for j in $(cat /scripts/temp/group_delete_list.txt)
do
	grep "^$j" /etc/group >> $detailed_report
done
#
#
#
echo "########## Added portion of /etc/gshadow ##########" >> $detailed_report
cut -d ":" -f1 /etc/group > /scripts/temp/etc_group_list.txt
cut -d ":" -f1 /scripts/original_copy/etc_group_orig.txt > /scripts/temp/etc_group_list_orig.txt
cat /scripts/temp/etc_group_list.txt /scripts/temp/etc_group_list_orig.txt | sort | uniq -u > /scripts/temp/group_delete_list.txt
for j in $(cat /scripts/temp/group_delete_list.txt)
do
	grep "^$j" /etc/gshadow >> $detailed_report
done
#
#showing created users in report
#
echo "########## Added portion of /etc/passwd ##########" >> $detailed_report
cut -d ":" -f1 /etc/passwd > /scripts/temp/etc_passwd_list.txt
cut -d ":" -f1 /scripts/original_copy/etc_passwd_orig.txt > /scripts/temp/etc_passwd_list_orig.txt
cat /scripts/temp/etc_passwd_list.txt /scripts/temp/etc_passwd_list_orig.txt | sort | uniq -u > /scripts/temp/users_delete_list.txt
for i in $(cat /scripts/temp/users_delete_list.txt)
do
	grep "^$i" /etc/passwd >> $detailed_report
done
#
#
#
echo "########## Added portion of /etc/shadow ##########" >> $detailed_report
cut -d ":" -f1 /etc/passwd > /scripts/temp/etc_passwd_list.txt
cut -d ":" -f1 /scripts/original_copy/etc_passwd_orig.txt > /scripts/temp/etc_passwd_list_orig.txt
cat /scripts/temp/etc_passwd_list.txt /scripts/temp/etc_passwd_list_orig.txt | sort | uniq -u > /scripts/temp/users_delete_list.txt
for i in $(cat /scripts/temp/users_delete_list.txt)
do
	grep "^$i" /etc/shadow >> $detailed_report
done
#
#Part of login.defs, that we are interested in
#
echo "########## Part of /etc/login.defs ##########" >> $detailed_report
grep -A 4 "^PASS_MAX*" /etc/login.defs >> $detailed_report
#
#
#grading test
#
#Total score is 122
#
# Grade	Minimum%	Another grading scale
# A+		97		A - Average
# A 		93		B - Below Average
# A-		90		C - Can't drink coffee
# B+		87		D - Don't come onsite 
# B 		83		F - Find a new school
# B-		80		found on the internet
# C+		77		
# C 		73		
# C-		70		
# D+		67		
# D 		63		
# D-		60		
# F 		0		
#
#
#grade=$(echo "scale=2;$test_score*100/122" | bc) # doesn't round up, just shows 2 digits after comma
grade=$(printf "%.0f" $(echo "scale=2;$test_score*100/122" | bc)) #rounds up to integer good stuff here
#
echo
echo "Grade percentage is $grade %" | tee -a $short_report
echo
if (( $grade>=97 ))
then
	echo "You nailed the test, excellent job, you can now go and teach your peers" | tee -a $short_report
elif (( $grade<97 && $grade>=93 ))
then
	echo "You nailed the test, excellent job, you can now go and teach your peers" | tee -a $short_report
elif (( $grade<93 && $grade>=90 ))
then
	echo "You nailed the test, excellent job, you can now go and teach your peers" | tee -a $short_report
elif (( $grade<90 && $grade>=87 ))
then
	echo "Good job, you got it, now you can explain it to your classmates" | tee -a $short_report
elif (( $grade<87 && $grade>=83 ))
then
	echo "Good job, you got it, now you can explain it to your classmates" | tee -a $short_report
elif (( $grade<83 && $grade>=80 ))
then
	echo "Good job, you got it, now you can explain it to your classmates" | tee -a $short_report
elif (( $grade<80 && $grade>=77 ))
then
	echo "You kind of - sort of got it, try to reach out to your friends and see where your mistakes were" | tee -a $short_report
elif (( $grade<77 && $grade>=73 ))
then
	echo "You kind of - sort of got it, try to reach out to your friends and see where your mistakes were" | tee -a $short_report
elif (( $grade<73 && $grade>=70 ))
then
	echo "You kind of - sort of got it, try to reach out to your friends and see where your mistakes were" | tee -a $short_report
elif (( $grade<70 && $grade>=67 ))
then
	echo "You got some parts of the test, try going over the material again" | tee -a $short_report
elif (( $grade<67 && $grade>=63 ))
then
	echo "You got some parts of the test, try going over the material again" | tee -a $short_report
elif (( $grade<63 && $grade>=60 ))
then
	echo "You got some parts of the test, try going over the material again" | tee -a $short_report
elif (( $grade<60 ))
then
	echo "Unfortunately you have trouble, getting this material," | tee -a $short_report
	echo "definitely go over the material again and reach out to your peers" | tee -a $short_report
fi
echo 
#
#sending report
#
mail -s "Users and Groups test $first_name $last_name" -a $detailed_report info@ziyotek.com < $short_report
