
 
# Name of the application in scm (GIT)
set :application, "simulador"
 
# Source Control Management
set :scm, :git
 
set :deploy_to, "/var/www/#{application}"
 
# server there the web server is running (nginx)
#role :web, "localhost"
 
# server there the app server is running (unicorn)
role :app, "localhost"
 
# server there the db is running
# This is where Rails migrations will run
role :db, "localhost", :primary => true
 
set :rails_env, :production
 
# user on the server
set :user, "project_user"
set :use_sudo, false
 
# Target ruby version
set :rvm_ruby_string, '1.9.3'
 
# System-wide RVM installation
set :rvm_type, :system
 
# Apply default RVM version for the current account
after "deploy:setup", "deploy:set_rvm_version"
 
namespace :deploy do
 
  task :set_rvm_version, :roles => :app, :except => { :no_release => true } do
    run "source /etc/profile.d/rvm.sh && rvm use #{rvm_ruby_string} --default"
  end
 
  task :start, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/unicorn start"
  end
 
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/unicorn stop"
  end
 
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/unicorn restart"
  end
 
  # Precompile assets
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end
  end
 
end