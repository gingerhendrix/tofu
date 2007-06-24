require 'mt-capistrano'

set :site,         "1439"
set :application,  "tofu"
set :webpath,      "tofu.gandrew.com"
set :domain,       "gandrew.com"
set :user,         "serveradmin%gandrew.com"
set :password,     "enichem42"
ssh_options[:password] = "enichem42"
set :svn_password, "enichem42"

# repository on (gs)
set :repository, "svn+ssh://#{user}@#{domain}/home/#{site}/users/.home/repos/tofu/head"

#full path to svn
#set :svn, "/C:/subversion/bin/svn.exe"

# repository elsewhere
#set :repository, "svn+ssh://user@other.com/usr/local/svn/repo/app1/trunk"
#set :repository, "https://other.com/usr/local/svn/repo/app1/trunk"


# these shouldn't be changed
role :web, "#{domain}"
role :app, "#{domain}"
role :db,  "#{domain}", :primary => true
set :deploy_to,    "/home/#{site}/containers/rails/#{application}"

#set :migrate_env, "VERSION=0"

#task :after_update_code, :roles => :app do
#  put(File.read('deploy/database.yml.mt'), "#{release_path}/config/database.yml", :mode => 0444)
#end

task :after_symlink, :roles => :app do
  run "#{mtr} -u #{user} -p #{password} generate_htaccess #{application}"
end

task :after_update_code, :roles => [:web] do
  run "cp /home/#{site}/containers/rails/#{application}/shared/system/config/database.yml #{release_path}/config/database.yml"
end