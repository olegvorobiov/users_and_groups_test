# Users and Groups test
***
## Task #1
### **Create Users and Groups based on two tables below**
<center><strong><u>Users Table</u></strong></center>
<center>

| Username | Comment | UID | Group | Home Directory | Shell | Max. Pass. Age | Warn Period |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| cmichaels | Cristina Michaels |  2001 | hr | /home/cmichaels | /bin/bash | 180 | 10 |
| jsanders | Jose Sanders | 3001 | engineering | /home/jsanders | /bin/bash | 180 | 10 |
| osmith | Oliver Smith | 3002 | engineering | /home/osmith | /bin/bash | 180 | 10 |
| mjohnson | Mateo Johnson | 3003 | engineering | /home/mjohnson | /bin/bash | 180 | 10 |
| lwilliams | Logan Williams | 4001 | devops | /home/lwilliams | /bin/bash | 180 | 10 |
| nbrown | Noah Brown | 4002 | devops | /home/nbrown | /bin/bash | 180 | 10 |
| jjones | James Jones | 5000 | consultants | /home/jjones | /bin/bash | 180 | 10 |
| system-user | System User | 501 | system | /home/system-user | /sbin/nologin | 180 | 10 |
</center>

<center><strong><u>Group Table</u></strong></center>

<center>

| Group Name | GID | 
| :-: | :-: |
| hr | 2000|
| hiring | 6000 |
| engineering | 3000 |
| migration | 7000 |
| devops | 4000 |
| consultants | 5000 |
| system | 500 |

</center>

***

## Task #2
### **Give engineering group and user "jjones" sudo privileges**

***

## Task #3
### **Make sure that all of the newly created users have maximum password age - 180 days and warning period - 10 days, also set "jjones" account expiration date 90 days from now.**

***

## Task #4
### **Create directories /projects/engineer, /projects/devops, these directories will contain scripts for users to execute. Make sure that Jose, Oliver and Mateo have /projects/engineer in their PATH Make sure that Logan and Noah have /projects/devops in their PATH**

***

## Task #5
### **As new people getting on boarded and new projects approaching, add hiring group as a secondary group for Cristina, Jose and Logan. Also add migration group as a secondary group for Oliver, Mateo, Noah and James**

***

## Task #6
### **New contractors will be hired to work soon. As user James add five users(contractor1...contractor5), no passwords needed, all default parameters**

***

## Task #7
### **Make Cristina an admin of hr, hiring, engineering, migration, devops, consultants groups. As user Cristina add all of the 5 contractors to consultants group**

***

<center><strong><u>I am aiming to overwrite all of the scripts to use Python3 as much as possible as I am learning it more. Also this repo will contain all of the scripts to setup RockyLinux and Ubuntu VMs as well as Ubuntu container image</u></strong></center>