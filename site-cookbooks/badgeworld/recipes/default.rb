#
# Cookbook Name:: badgeworld
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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
      adapter 'mysql2'
      database "badgeworld"
      username "badgeworld"
      password node['hetzner_one']['badgeworld_pass']
    end
  end

  passenger_nginx do
  end
end
