#
# Cookbook Name:: hetzner_one
# Recipe:: default
#
# Copyright 2014, Daniel Hahn
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

include_recipe "database::mysql"

swap_file '/swapfile' do
  size      2048    # MBs
end

user "joana" do
  comment "joana"
  home '/home/joana'
  shell '/bin/bash'
  supports :manage_home => true
end

directory '/home/joana/.ssh' do
  owner 'joana'
  mode '0700'
end

file "/home/joana/.ssh/authorized_keys" do
  owner 'joana'
  mode '0600'
  content Chef::DataBagItem.load('ssh_keys', 'joana')['key']
end

connection_info =  {:host => "localhost", :username => 'root', :password => node.mysql.server_root_password }
node.set_unless['hetzner_one']['badgeworld_pass'] = secure_password
app_password = node['hetzner_one']['badgeworld_pass']

mysql_database 'badgeworld' do
  connection connection_info
  action :create
end

mysql_database_user 'badgeworld' do
  connection connection_info
  password app_password
  database_name 'badgeworld'
  host 'localhost'
  privileges [:all]
  action :grant
end

directory '/var/www/.passenger' do
  owner node.nginx.user
  recursive true
end

application "badgeworld" do
  path "/var/apps/badgeworld"
  owner node.nginx.user

  repository "https://github.com/averell23/badgeworld.git"

  rails do
    rbenv_version '2.1.0'
    gems ['bundler']
    database do
      adapter 'mysql2'
      database "badgeworld"
      username "badgeworld"
      password app_password
    end
  end

  passenger_nginx do
  end
end
