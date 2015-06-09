<h1>Provisioning Storm</h1><div>&nbsp; This document covers the procedures for bulding a storm cluster using the StormStarter script. &nbsp;When executed against a redhat-based ( yum ) system, this script will give you a working storm cluster.</div><div><br></div><div>Essentially, to get a working cluster, you will:</div><div><ol><li>Setup 5 VM’s ( any <b>odd</b> number will do, but 5 is recommended )</li><li>git clone https://github.com/scott-mead/storm</li><li>Configure the cluster.yml config file</li><li>Configure SSH</li><li>Run the ‘StormStarter’ script</li></ol><h1>Setup VM’s</h1></div><h2>Nodes</h2><div>&nbsp; Building a cluster with 5 VM’s will allow you to withstand two node failures. &nbsp;Always build clusters in odd numbers so that zookeeper’s quorum keeping operations can elect a master.</div><div><br></div><h2>Salt</h2><div>&nbsp; I’m using salt-cloud to quickly provision ec2 nodes for me. &nbsp;You can use whichever method you’d like, but, if you don’t have a tool, I highly recommend using salt-cloud.</div><div><br></div><h1>Clone StormStarter</h1><div>&nbsp; Get a copy of the ‘StormStarter’ git repository from&nbsp;<a href="https://github.com/scott-mead/storm" style="line-height: 1.4;">https://github.com/scott-mead/storm</a>.&nbsp;</div><div><br></div><div>git clone&nbsp;<a href="https://github.com/scott-mead/storm" style="line-height: 1.4;">https://github.com/scott-mead/storm</a></div><div><br></div><h1>Configure cluster.yml</h1><div>&nbsp; This is your primary config file. &nbsp;Look at the example and modify it to your needs.</div><div><br></div><div>The configuration file contains a group of servers that you will be addressing.<br></div>
```yaml
group_name:
   username: "sshusername"
   node1:
      hostname: "externally addressable name"
      int_ip: "host internal ip"
      int_name: "cluster1"
```
Example config
```yaml
dev_cluster:
  username: "ec2-user"
  node1:
    hostname : "c1.example.com"
    int_ip : "192.168.185.1"
    int_name : "cluster1"
node2:
    hostname : "c2.example.com"
    int_ip : "192.168.185.2"
    int_name : "cluster2"
node3:
    hostname : "c3.example.com"
    int_ip : "192.168.185.3"
    int_name : "cluster3"

prod_cluster:
  username: "ec2-user"
  node1:
    hostname : "p1.example.com"
    int_ip : "192.168.185.1"
    int_name : "cluster1"
node2:
    hostname : "p2.example.com"
    int_ip : "192.168.185.2"
    int_name : "cluster2"
node3:
    hostname : "p3.example.com"
    int_ip : "192.168.185.3"
    int_name : "cluster3"
```
<div></div><div><ul><li><span style="line-height: 1.4;">group_name is what you will pass to StormStarter -g</span><br></li><ul><li><span style="line-height: 1.4;">hostname&nbsp;</span></li><ul><li><span style="line-height: 1.4;">should be the externally addressable, ec2 name i.e. (&nbsp;</span>ec2-52-109-12-100.compute-1.amazonaws.com )</li></ul><li>int_ip</li><ul><li>This is the internal ( a.k.a. non-public / private ) ip address. &nbsp;This will be used by the nodes to communicate with one another</li></ul><li>int_name</li><ul><li>This is an internal name to be setup by StormStarter. &nbsp;If you change this, you will need to modify most of the chef-managed configuration files within the package. &nbsp;I do NOT recommend this.</li></ul></ul></ul></div><h1>Configure SSH</h1><div>&nbsp; Edit the $HOME/.ssh/config file and add the key for your aws hosts and disable prompting. &nbsp;</div><div><br></div><div><div>Host *aws*</div><div>&nbsp; &nbsp; &nbsp; &nbsp; IdentityFile /home/user/myawskey.pem</div><div>&nbsp; &nbsp; &nbsp; &nbsp;StrictHostKeyChecking no</div></div><div><br></div><div>You can either use wildcards like I did above, or, list each one individually.</div><div><br></div><div><div><div>Host&nbsp;<span style="line-height: 1.4;">ec2-52-109-12-100.compute-1.amazonaws.com</span></div><div>&nbsp; &nbsp; &nbsp; &nbsp; IdentityFile /home/user/myawskey.pem</div><div>&nbsp; &nbsp; &nbsp; &nbsp;StrictHostKeyChecking no</div></div></div><div><br></div><div><div>Host&nbsp;<span style="line-height: 1.4;">ec2-52-109-12-101.compute-1.amazonaws.com</span></div><div>&nbsp; &nbsp; &nbsp; &nbsp; IdentityFile /home/user/myawskey.pem</div><div>&nbsp; &nbsp; &nbsp; &nbsp;StrictHostKeyChecking no</div></div><div><br></div><div>Once you have set this up, validate that you can ssh to the host with no password.</div><div><br></div><h1>Run StormStarter</h1><div>&nbsp; &nbsp;Required options:</div><div><br></div><div>&nbsp; &nbsp;-c &lt; path to config file&gt;</div><div>&nbsp; &nbsp;-g &lt;group name&gt;</div><div><br></div><div>&nbsp; &nbsp;The group name is the top of the yaml tree, so if we had configured</div>
```yaml
dev_cluster:
  username: "ec2-user"
  node1:
    hostname : "c1.example.com"
    int_ip : "192.168.185.1"
    int_name : "cluster1"
node2:
    hostname : "c2.example.com"
    int_ip : "192.168.185.2"
    int_name : "cluster2"
node3:
    hostname : "c3.example.com"
    int_ip : "192.168.185.3"
    int_name : "cluster3"

prod_cluster:
  username: "ec2-user"
  node1:
    hostname : "p1.example.com"
    int_ip : "192.168.185.1"
    int_name : "cluster1"
node2:
    hostname : "p2.example.com"
    int_ip : "192.168.185.2"
    int_name : "cluster2"
node3:
    hostname : "p3.example.com"
    int_ip : "192.168.185.3"
    int_name : "cluster3"
```
<div><br></div><div>I could use either ‘dev_cluster’ or ‘prod_cluster’ as the group name</div><div><br></div><div>Action:</div><div>&nbsp; &nbsp;You have 4 possible actions:</div><div><ol><li><span style="line-height: 1.4;">provision</span></li><ol><li><span style="line-height: 1.4;">This will copy files, clone the repository and install&nbsp;</span></li><li><span style="line-height: 1.4;">You can run this against a system with an existing install to update configs</span></li></ol><li><span style="line-height: 1.4;">start</span></li><ol><li><span style="line-height: 1.4;">This will connect to each node and run service&nbsp;</span>supervisord start</li></ol><li><span style="line-height: 1.4;">stop</span></li><ol><li><span style="line-height: 1.4;">This will connect to each node and run service&nbsp;</span>supervisord stop</li></ol><li><span style="line-height: 1.4;">restart</span></li><ol><li><span style="line-height: 1.4;">This will connect to each node and run service&nbsp;</span>supervisord restart</li></ol></ol></div>