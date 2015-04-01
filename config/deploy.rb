set :application, 'basketball-referee-quiz'
set :deploy_user, 'deploy'
set :deploy_via, :remote_cache
set :repo_url, 'https://github.com/Enucatl/basketball-referee-quiz.git'
set :rvm_roles, [:app, :web]

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/basketball-referee-quiz'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
#set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
set :default_env, { path: "$HOME/.rvm/bin:$PATH" }

# how many old releases do we want to keep
set :keep_releases, 5

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(unicorn_init.sh))


namespace :deploy do

    desc 'Restart application'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            # Your restart mechanism here, for example:
            # execute :touch, release_path.join('tmp/restart.txt')
        end
    end

    %w[start stop restart].each do |command|
        desc "#{command} unicorn server"
        task command do
            on roles(:app), except: {no_release: true} do
                execute "#{current_path}/config/unicorn_init.sh #{command}"
            end
        end
    end

    after :publishing, :restart

    after :restart, :clear_cache do
        on roles(:web), in: :groups, limit: 3, wait: 10 do
            # Here we can do anything such as:
            #within release_path do
            #execute :rake, 'cache:clear'
            #end
        end
    end

end
