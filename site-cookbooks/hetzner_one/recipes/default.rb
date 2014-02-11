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

package "openssl"
package "libssl-dev"

swap_file '/swapfile' do
  size      2048    # MBs
end

user "joana" do
  comment "Joana"
  home '/home/joana'
  shell '/bin/bash'
  supports :manage_home => true
end

directory '/home/joana/.ssh' do
  owner 'joana'
  mode '0700'
  recursive true
end

file "/home/joana/.ssh/authorized_keys" do
  owner 'joana'
  mode '0600'
  content Chef::DataBagItem.load('ssh_keys', 'joana')['key']
end
