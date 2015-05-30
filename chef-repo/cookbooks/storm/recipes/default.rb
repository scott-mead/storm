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
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file "supervisord.conf" do
  path "/etc/supervisord.conf"
  action :create_if_missing
end

# Create the software installation directory
directory "/opt/storm/install" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

###
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
###
# Setup Zookeeper
###
###
directory "/opt/storm/install/zookeeper" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/var/log/zookeeper" do
  owner 'root'
  group 'root'
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
  action :create_if_missing
end

cookbook_file "zoo.cfg" do
  path "/opt/storm/install/zookeeper/current/conf/zoo.cfg"
  action :create_if_missing
end


