
require 'mt-capistrano'

set :site,         "1439" #Media-temple user-id thingy as in /home/1439/containers etc.
set :application,  "tofu"
set :webpath,      "tofu.gandrew.com"
set :domain,       "gandrew.com"
set :user,         "serveradmin@gandrew.com"
set :password,     "enichem42"

ssh_options[:username] = 'serveradmin@gandrew.com'
ssh_options[:password] = "enichem42"

set :repository, "svn+ssh://#{user}@#{domain}/home/#{site}/users/.home/repos/#{application}/trunk"
set :deploy_to,  "/home/#{site}/containers/rails/#{application}"

set :checkout, "export"

role :web, "#{domain}"
role :app, "#{domain}"
role :db,  "#{domain}", :primary => true

task :after_update_code, :roles => :app do
  put(File.read('config/database.yml'), "#{release_path}/config/database.yml", :mode => 0444)
end

task :restart, :roles => :app do
  run "mtr restart #{application} -u #{user} -p #{password}"
  run "mtr generate_htaccess #{application} -u #{user} -p #{password}"
  migrate
end