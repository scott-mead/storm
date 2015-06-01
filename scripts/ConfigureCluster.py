#!/bin/env python

import subprocess
import sys

# Hosts definition, this is a python list of tuples
# LIST = [('hostuser@host1name','host1.internal.ip.addr'),
#         ('hostuser@host2name','host2.internal.ip.addr'),
#         etc... ]

HOSTS=[('ec2-user@ec2-54-146-215-30.compute-1.amazonaws.com','10.136.20.218'),
       ('ec2-user@ec2-54-234-22-242.compute-1.amazonaws.com','10.138.15.49')]

# Build HOSTS file for this cluster

counter=1

fo = open ( "hosts","wb")
for HOST in HOSTS:
    # Get the hostname
    thehost=str(HOST[0].split('@')[1])

    # Write this host to the hosts file
    fo.write(str(HOST[1]) + " " + thehost + ' ' + 'cluster' + str(counter) + '\n')

    # Writeout the zookeeper id file
    h = open (thehost +".myid","wb")
    h.write(str(counter))
    h.close()
     
    counter+=1
fo.close()

# Ports are handled in ~/.ssh/config since we use OpenSSH
COMMANDS=['sudo yum -y localinstall https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.0.3-1.x86_64.rpm',
          'sudo yum -y install git',
          'cd /opt/storm && sudo git pull',
          'cd /opt/ && sudo git clone https://github.com/scott-mead/storm.git',
          'cd /opt/storm/chef-repo && sudo chef-solo -c solo.rb -j solo.json']

for HOST in HOSTS:
    thehost=str(HOST[0].split('@')[1])

    print("Now connecting to: " + str(HOST[0]).split('@')[1])

    cathost = subprocess.Popen(["scp", "hosts","%s:" % str(HOST[0])],
                               shell=False,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    print(cathost.stdout.readlines()) 

    cathost = subprocess.Popen(["scp", "placehosts.sh","%s:" % str(HOST[0])], 
                               shell=False,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    print(cathost.stdout.readlines()) 

    cathost = subprocess.Popen(["scp", thehost+".myid","%s:" % str(HOST[0])], 
                               shell=False,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    print(cathost.stdout.readlines()) 

    cathost = subprocess.Popen(["ssh","-t", "%s" % str(HOST[0]), "sudo bash /home/ec2-user/placehosts.sh"],
                               shell=False,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    print(str(cathost.stdout.readlines())) 

    for COMMAND in COMMANDS:
        print("\tNow Executing: " + COMMAND)
        ssh = subprocess.Popen(["ssh","-t", "%s" % str(HOST[0]), COMMAND],
                               shell=False,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
        #result = ssh.stdout.readlines()
        print(str(ssh.stdout.readlines()))
'''        if result == []:
            error = ssh.stderr.readlines()
            print >>sys.stderr, "ERROR: %s" % error
        else:
            print result'''

