#
# Cookbook Name:: rails_install
# Recipe:: default
#
# Copyright 2012, Daniel Hahn
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
#

# include_recipe 'mysql'
include_recipe "ruby_from_source"
include_recipe 'build-essential'

package 'sqlite3'
package 'libsqlite3-dev'

# mysql_database node.rails_install.app_name do
#   connection({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
#   action :create
# end
#
# mysql_database_user 'rails' do
#   connection({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
#   password node.rails_install.db_pass
#   database_name node.rails_install.app_name
#   host '%'
#   privileges [:all]
#   action :grant
# end

application node.rails_install.app_name do
  path "/var/apps/#{node.rails_install.app_name}"
  owner "root"
  group "root"

  repository node.rails_install.repository
  revision "master"

  migrate true

  rails do
    bundle_command '/opt/local/bin/bundle'
    bundler true
    database(
      :adapter => 'mysql2',
      :host => 'localhost',
      :database => node.rails_install.app_name,
      :password => node.rails_install.db_pass,
      :username => 'rails'
    )
  end

  unicorn do
    preload_app false
    worker_processes 2
  end
end