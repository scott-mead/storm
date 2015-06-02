#!/bin/sh


# Read each line in the cluster config 
cat /home/ec2-user/hosts | sed '/^$/d' | while read line
do
    grep -q "$line" /etc/hosts

    if [ "$?" -ne 0 ] 
    then
        printf "Adding $line "
        sudo echo $line >> /etc/hosts
        printf " DONE\n"
    fi
done


test -d /tmp/zookeeper
if [ "$?" -ne 0 ] 
then
    sudo mkdir /tmp/zookeeper
fi

diff /home/ec2-user/$1.myid /tmp/zookeeper/myid
if [ "$?" -ne 0 ] 
then
    sudo cp /home/ec2-user/$1.myid /tmp/zookeeper/myid
fi

