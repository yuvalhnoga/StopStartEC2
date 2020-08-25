#!/bin/bash
function menu {
    printf "\e[32m\e[1mMenu to start or stop an instance:\n\e[0m"
    printf "\e[32m1. \e[1mStart \e[32man instance\n\e[0m"
    printf "\e[32m2. \e[31m\e[1mStop an instance\n\e[0m"
    printf "\e[33m\e[1m3. Exit\n\n\e[0m"
    printf "\e[33m\e[1mChoose an option: \e[0m"
    read OPTION
    printf "\n"
}
menu
while [ $OPTION != "3" ]; do
    if [ $OPTION == "1" ]; then
		./awsScripts/start-instances.sh
	fi 
	if [ $OPTION == "2" ]; then
		./awsScripts/stop-instances.sh
	fi
	menu
done

