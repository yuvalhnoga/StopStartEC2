#!/bin/bash
function menu {
    printf "\e[31m\e[1m\e[1mMenu to stop an instance:\n\e[0m"
    printf "\e[32m\e[1m1. Search by name\n\e[0m"
    printf "\e[32m\e[1m2. Search by tag\n\e[0m"
    printf "\e[32m\e[1m3. Exit\n\n\e[0m"
    printf "\e[32m\e[1mChoose an option: \e[0m"
    read OPTION
    printf "\n"
}
menu
while [ $OPTION != "3" ]; do
    if [ $OPTION == "1" ]; then
        IFS=$'\n'
        runningNAMES=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" | cut -f2 -d \" | grep '[0-9]'`
        printf "\e[32m\e[1mThis are the instances that are running:\n\e[0m"
        for i in $runningNAMES; do
            INSTANCE_NAME=`aws ec2 describe-instances --instance-ids $i --query 'Reservations[0].Instances[0]' | jq '.Tags[] | select(.Key=="Name") | .Value' | cut -f2 -d \"`
            echo $INSTANCE_NAME;
        done
        printf "\e[32m\e[1mEnter an instance name:\e[0m"
        read NAME
        printf "\e[32m\e[1mStopping the instance: $NAME...\n\e[0m"
	    INSTANCE_ID=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$NAME" --query "Reservations[].Instances[].InstanceId" | cut -f2 -d \" | grep '[0-9]'`
	    aws ec2 stop-instances --instance-ids $INSTANCE_ID
        printf "\e[31m\e[1mInstance $NAME is stopped! \n\e[0m"
    fi

    if [ $OPTION == "2" ]; then
        IFS=$' '
        TAGS=`aws ec2 describe-tags --filters "Name=resource-type,Values=instance" --query 'Tags[].Key[]' | grep "[a-zA-Z]" | cut -f2 -d \" | sort -u`
        printf "\e[32m\e[1mThis are the tags:\n\e[0m"
        echo $TAGS
        printf "\e[32m\e[1m\nEnter a tag: \e[0m"
        read TAG
        printf "\e[32m\e[1mThis are the tag values: \n\e[0m"
        TAG_VALUES=`aws ec2 describe-tags --filters "Name=resource-type,Values=instance" | jq '.Tags[] | select(.Key=="'$TAG'") | .Value' | cut -f2 -d \" | sort -u`
        echo $TAG_VALUES
        printf "\e[32m\e[1mChoose a tag value: \e[0m"
        read TAG_VALUE
        printf "\e[32m\e[1mStopping the instances with the tag value: $TAG_VALUE...\n\e[0m"
        INSTANCE_IDS_TAG=`aws ec2 describe-instances --filters "Name=tag:$TAG,Values="$TAG_VALUE"" --query "Reservations[].Instances[].InstanceId" | grep '[0-9]' | cut -f2 -d \"`
        IFS=$'\n'
        for i in $INSTANCE_IDS_TAG; do                        
            aws ec2 stop-instances --instance-ids $i
        done
        printf "\e[31m\e[1m\nInstances are stopped! \n\n\e[0m"
    fi

    menu
done
