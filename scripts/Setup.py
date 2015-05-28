import subprocess
import sys

HOST="ec2-user@ec2-54-146-215-30.compute-1.amazonaws.com"
# Ports are handled in ~/.ssh/config since we use OpenSSH
COMMANDS=['sudo yum -y localinstall https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.0.3-1.x86_64.rpm',
          'sudo yum -y install git',
          'cd /opt/storm && sudo git pull',
          'cd /opt/ && sudo git clone https://github.com/scott-mead/storm.git',
          'cd /opt/storm/chef-repo && sudo chef-solo -c solo.rb -j solo.json']

for COMMAND in COMMANDS:
    ssh = subprocess.Popen(["ssh","-t", "%s" % HOST, COMMAND],
                           shell=False,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE)
    result = ssh.stdout.readlines()
    if result == []:
        error = ssh.stderr.readlines()
        print >>sys.stderr, "ERROR: %s" % error
    else:
        print result

