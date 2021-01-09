#!/bin/bash
#
source /var/scripts/variables.txt
if (( $(cat $short_report | wc -l)>1 ))
then
    echo
    echo
    echo "You already submitted your test before, you will have to start over again"
    echo
    echo "Would you like to start over again?"
    while :
    do
        echo
        echo "Please type \"yes\" or \"no\" "
        echo
        read answer
        if [[ $answer == "yes" ]]
        then
            echo
            echo
            echo "Restoring your box"
            disaster.sh
            echo
            echo "Your box is restored to the original state"
            echo
            echo "Run start.sh script again and you can start on your test again"
            echo
            echo
            break
        elif [[ $answer == "no" ]]
        then
            echo
            echo
            echo "OK, not touching anything!"
            echo
            echo
            break
        fi
    done
else
    echo
    echo
    echo "Checking your test"
    freedom.sh 2>/dev/null
fi