#set :repo_url, 'git@bitbucket.org:traktopro/meuvalor.git'
# config valid only for Capistrano 3.1
lock '3.4'

set :application, "parking-payment-api"
set :repo_url, "https://github.com/jhrocha/parking-payment-ruby.git"
set :ruby_version, "ruby-2.2.1"
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]
set :base_path, "/var/www/parkingpayment-api"
set :ruby_gemset, "@global"
set :user, "passenger"
set :bundle_gemfile, -> { release_path.join('Gemfile') }

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
set :keep_releases, 5

set :ssh_options, { forward_agent: true }

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
