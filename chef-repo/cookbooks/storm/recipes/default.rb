#
# Cookbook Name:: storm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

package 'git' do
    action :install
end

directory "/opt/storm/install/storm/0.9.4" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'extract_storm' do
  command 'tar xzvf apache-storm-0.9.4.tar.gz'
  cwd '/opt/storm/install/storm/0.9.4'
  not_if { File.exists?("/opt/storm/install/storm/0.9.4/LICENSE") }
end

link "/opt/storm/install/storm/current" do
  to "/opt/storm/install/storm/0.9.4"
end
