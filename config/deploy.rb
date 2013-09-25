require File.expand_path('../application', __FILE__)

raise 'Deployment is only available in production and sandbox.' unless ['production', 'sandbox'].include? Rails.env

set :application, $globals.application
set :repository, $globals.deployment.repository
set :rails_env, Rails.env
set :scm, :git
set :branch, "master"
set :scm_verbose, true
set :user, $globals.deployment.user
set :use_sudo, false
set :deploy_to, $globals.deployment.dir
set :default_environment, {'USER' => ENV['USER']}
set :deploy_subdir, "site"

server $globals.deployment.host, :app, :web, :db, :primary => true

def copy(source, destination, options={})
  source = File.join Rails.root, "config", source
  unless destination[0] == '/'
    destination = File.join deploy_to, 'current', destination
  end

  # Using different files for local and remote staging in case of deployment on the local machine.
  local_staging = File.join "/tmp", Guid.new.to_s
  remote_staging = File.join "/tmp", Guid.new.to_s

  if options[:preprocess]
    processed_source = ERB.new(File.read source).result
    File.open(local_staging, "w") do |f|
      f.write processed_source
    end

    upload local_staging, remote_staging, :via => :scp
    File.delete local_staging
  else
    upload source, remote_staging, :via => :scp
  end

  run "#{sudo} cp --no-preserve all #{remote_staging} #{destination}; rm #{remote_staging}"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    ;
  end

  task :stop do
    ;
  end

  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, "tmp", "restart.txt")}"
  end

  task :configs do
    copy "support/globals.yml", "config/globals.yml", :preprocess => true
    copy "support/database.yml", "config/database.yml", :preprocess => true
  end
end


desc "Deploy and restart apache."
namespace :apache do
  task :default do
    run "#{sudo} apachectl stop || true"
    copy "support/apache/$name;format="camel,lower"$", "/etc/apache2/sites-available/$name;format="camel,lower"$", :preprocess => true
    run "#{sudo} a2ensite $name;format="camel,lower"$"
    run "#{sudo} apachectl start"
  end
end

desc "Deploy and restart ejabberd."
namespace :ejabberd do
  task :default do
    run "#{sudo} /etc/init.d/ejabberd stop || true"
    copy "support/ejabberd/ejabberd.cfg", "/etc/ejabberd/ejabberd.cfg", :preprocess => true
    copy "support/ejabberd/ejabberdctl.cfg", "/etc/ejabberd/ejabberdctl.cfg", :preprocess => true
    run "#{sudo} /etc/init.d/ejabberd start"
  end
end

after "deploy", "deploy:migrate"
after "deploy", "apache"
