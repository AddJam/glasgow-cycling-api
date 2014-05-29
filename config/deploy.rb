require "bundler/capistrano"
require "rvm/capistrano"

# server "188.226.184.33", :web, :app, :db, primary: true # Digital Ocean
server "activetravel.cloudapp.net", :web, :app, :db, primary: true # Azure

set :application, "journey_api"
# set :user, "fcd" # Digital Ocean
set :user, "app" # Azure
set :port, 22
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:chrissloey/journey-api.git"
set :branch, "master"
set :foreman_sudo, "export rvmsudo_secure_path=1 && rvmsudo -p 'sudo password: '"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "cd #{current_path} && #{foreman_sudo} bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -e ~/.env"
  end

  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "#{foreman_sudo} start #{application} || #{foreman_sudo} restart #{application}"
  end
end

after "deploy:update", "foreman:export"
after "deploy:update", "foreman:restart"
