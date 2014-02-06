current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "averell23"
client_key               "#{current_dir}/averell23.pem"
validation_client_name   "none23-validator"
validation_key           "#{current_dir}/none23-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/none23"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
cookbook_copyright "Daniel Hahn"
cookbook_email     "averell@newgods.org"
cookbook_license   "gplv3"
