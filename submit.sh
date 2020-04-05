#!/bin/bash
#
if [[ -a /scripts/reports/teachers_report.txt ]]
then
    echo "You already submitted your test before, you will have to start over again"
    echo "Would you like to start over again?"
    while :
    do
        echo "Please type \"yes\" or \"no\" "
        read answer
        if [[ $answer == "yes" ]]
        then
            echo
            echo
            echo "Restoring your box"
            disaster.sh
            echo "Your box is restored to the original state"
            echo "Now you can start over again!"
            break
        elif [[ $answer == "no" ]]
        then
            echo
            echo
            echo "OK, not touching anything!"
            break
        fi
    done
else
    echo
    echo
    echo "Checking your test"
    freedom.sh 2>/dev/null
fi