#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

# Validate that 'git' package is installed
package 'git' do
    action :install
end

# 
# Create storm user
#
user 'storm' do
   action :create
end

# Install supervisor
execute 'supervisor_install' do
  command 'easy_install supervisor'
end

directory "/etc/supervisord.d" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/var/log/supervisor" do
  owner 'storm'
  group 'storm'
  mode '0755'
  action :create
end

cookbook_file "supervisord.conf" do
  path "/etc/supervisord.conf"
  action :create
end

file "/var/run/supervisord.pid" do
  owner 'storm'
  group 'storm'
  action :touch
end

cookbook_file "supervisord" do
  path "/etc/init.d/supervisord"
  mode '0755'
  action :create
end


# Create the software installation directory
directory "/opt/storm/install" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

###
# Setup Storm 
###
directory "/opt/storm/install/storm" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'extract_storm' do
  command 'tar xzvf /opt/storm/software/apache-storm-0.9.4.tar.gz'
  cwd '/opt/storm/install/storm'
  not_if { File.exists?("/opt/storm/install/storm/0.9.4/LICENSE") }
end

execute 'mv_storm' do
  command 'mv apache-storm-0.9.4 0.9.4'
  cwd '/opt/storm/install/storm'
  not_if { File.exists?("/opt/storm/install/storm/0.9.4") }
end

link "/opt/storm/install/storm/current" do
  to "/opt/storm/install/storm/0.9.4"
end

###
# Setup Zookeeper
###
directory "/opt/storm/install/zookeeper" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/opt/storm/install/zookeeper/log" do
  owner 'storm'
  group 'storm'
  mode '0755'
  action :create
end

directory "/tmp/zookeeper" do
  owner 'storm'
  group 'storm'
  mode '0755'
  action :create
end

execute 'extract_zookeeper' do
  command 'tar xzvf /opt/storm/software/zookeeper-3.4.6.tar.gz'
  cwd '/opt/storm/install/zookeeper'
  not_if { File.exists?("/opt/storm/install/zookeeper/3.4.6") }
end

execute 'mv_zookeeper' do
  command 'mv zookeeper-3.4.6 3.4.6'
  cwd '/opt/storm/install/zookeeper'
  not_if { File.exists?("/opt/storm/install/zookeeper/3.4.6") }
end

link "/opt/storm/install/zookeeper/current" do
  to "/opt/storm/install/zookeeper/3.4.6"
end

cookbook_file "zookeeper.conf" do
  path "/etc/supervisord.d/zookeeper.conf"
  action :create
end

cookbook_file "zoo.cfg" do
  path "/opt/storm/install/zookeeper/current/conf/zoo.cfg"
  action :create
end

###
# Setup Storm
###
directory "/opt/storm/install/storm" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/opt/storm/install/storm/log" do
  owner 'storm'
  group 'storm'
  mode '0755'
  action :create
end

directory "/tmp/zookeeper" do
  owner 'storm'
  group 'storm'
  mode '0755'
  action :create
end

execute 'extract_storm' do
  command 'tar xzvf /opt/storm/software/apache-storm-0.9.4.tar.gz'
  cwd '/opt/storm/install/storm'
  not_if { File.exists?("/opt/storm/install/storm/0.9.4") }
end

execute 'mv_storm' do
  command 'mv apache-storm-0.9.4 0.9.4'
  cwd '/opt/storm/install/storm'
  not_if { File.exists?("/opt/storm/install/storm/0.9.4") }
end

link "/opt/storm/install/storm/current" do
  to "/opt/storm/install/storm/0.9.4"
end

##
# The nimbus is only running on the master
#  Only create the file if myid is a 1
#
bash 'set_nimbus' do
  user 'root'
  cwd '/opt/storm'
  code <<-EOH
  var=`cat /tmp/zookeeper/myid`

  if [ $var -eq 1 ] 
  then
      cp /opt/storm/chef-repo/cookbooks/storm/files/default/storm-nimbus.conf /etc/supervisord.d/
      cp /opt/storm/chef-repo/cookbooks/storm/files/default/storm-ui.conf /etc/supervisord.d/
      
  fi 
  EOH
end

cookbook_file "storm-supervisor.conf" do
  path "/etc/supervisord.d/storm-supervisor.conf"
  action :create
end

cookbook_file "storm.yaml" do
  path "/opt/storm/install/storm/current/conf/storm.yaml"
  action :create
end

link "/opt/storm/install/storm/0.9.4/logs" do
  to "/opt/storm/install/storm/log"
end

directory "/var/storm" do
  owner 'storm'
  group 'storm'
  mode '0755'
  action :create
end


##
#Enable supervisor last
#
service "supervisord" do
  action [:enable, :start]
end
