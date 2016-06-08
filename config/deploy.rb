# config valid only for Capistrano 3.4
lock '3.4.0'

set :application, 'my_app_name'
set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/APPLICATION_NAME
set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{mysite/_config.php mysite/_config/config.yml _ss_environment.php}

# Default value for linked_dirs is []
set :linked_dirs, %w{silverstripe-cache assets vendor}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Directory to save database backups into. Default db_backup_dir directory is /var/www/APPLICATION_NAME/db_backup
set :db_backup_dir, "#{deploy_to}/db_backup"

# Location for storing temporary files created by Capistrano routines. Default tmp directory is /var/www/APPLICATION_NAME/tmp
set :tmp_dir, "#{deploy_to}/tmp"

namespace :deploy do
  before :started, 'silverstripe:check'
  before :updating, 'silverstripe:db:backup'
  before :updating, 'silverstripe:db:purge'
  after :updated, 'silverstripe:composer:update'
  after :reverted, 'silverstripe:db:restore'
  after :finishing, 'deploy:cleanup'
  after :finishing_rollback, 'silverstripe:composer:update'
  after :finished, 'silverstripe:build'
  after :starting, 'silverstripe:check'
end
