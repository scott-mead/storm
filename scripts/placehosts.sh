#!/bin/sh


# Read each line in the cluster config 
cat /home/ec2-user/hosts | sed '/^$/d' | while read line
do
    printf "Checking if $line exists already\n"

    grep -q "$line" /etc/hosts

    if [ "$?" -ne 0 ] 
    then
        printf "\t$line not configured, adding...."
        sudo echo $line >> /etc/hosts
        printf " DONE\n"
    else
        printf "\t$line already configured\n"
    fi
done

sudo diff /home/ec2-user/*.myid /tmp/zookeeper/myid

if [ "$?" -ne 0 ] 
then
    sudo cp /home/ec2-user/*.myid /tmp/zookeeper/myid
fi
