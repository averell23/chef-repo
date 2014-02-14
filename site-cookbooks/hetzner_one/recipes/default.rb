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

user "rails_runner" do
  home '/home/rails_runner'
  shell '/bin/bash'
  supports :manage_home => true
end

file "/home/joana/.ssh/authorized_keys" do
  owner 'joana'
  mode '0600'
  content Chef::DataBagItem.load('ssh_keys', 'joana')['key']
end

application "badgeworld" do
  path "/var/apps/badgeworld"
  owner "rails_runner"

  environment(
    "PATH" => ['/usr/local/rbenv/shims', ENV['PATH']].join(':'),
    "RBENV_VERSION" => "2.1.0"
  )

  repository "https://github.com/averell23/badgeworld.git"

  rails do
    gems ['rake', 'bundler']
    database do
      database "badgeworld"
      username "badgeworld"
    end
  end

  passenger_nginx do
  end
end
