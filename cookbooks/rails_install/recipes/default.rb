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
#include_recipe "ruby_from_source"
# include_recipe 'build-essential'

include_recipe "passenger_apache2::mod_rails"

# Include some useful packages
package 'sqlite3'
package 'libsqlite3-dev'
package 'imagemagick'
package 'curl'
package 'telnet'

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

%w(database uploads).each do |shared_dir|
  directory "/var/apps/#{node.rails_install.app_name}/shared/#{shared_dir}" do
    recursive true
    owner node.apache.user
    group node.apache.group
    mode 0770
  end
end

application node.rails_install.app_name do
  path "/var/apps/#{node.rails_install.app_name}"
  owner node.apache.user
  group node.apache.group

  repository node.rails_install.repository
  revision "master"
  create_dirs_before_symlink ['public', 'config', 'tmp']
  symlink_before_migrate "database" => "database"
  symlinks "uploads" => "public/uploads"

  migrate true

  rails do
    bundler true
    database(
      :adapter => 'sqlite3',
      :database => 'database/production.sqlite3',
      :pool => 5,
      :timeout => 5000
    )
    restart_command "touch /var/apps/#{node.rails_install.app_name}/curent/tmp/restart.txt"
  end

end

web_app node.rails_install.app_name do
  docroot "/var/apps/#{node.rails_install.app_name}/current/public"
  cookbook "passenger_apache2"
  server_name node.rails_install.server_name
  server_aliases [ ]
  rails_env "production"
end