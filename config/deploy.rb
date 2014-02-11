# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'my_app_name'
set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/my_app'

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

# Directory to save database backups in
set :db_backup_dir, '/var/www/my_app/db_backup'

# Location for storing temporary files created by Capistrano routines
set :tmp_dir, '/var/www/my_app/tmp'

namespace :deploy do
    before :updating, 'silverstripe:db:backup'
    before :updating, 'silverstripe:db:purge'
    after :updated, 'silverstripe:composer:update'
    after :reverted, 'silverstripe:db:restore'
    after :finishing, 'deploy:cleanup'
    after :finishing_rollback, 'silverstripe:composer:update'
    after :finished, 'silverstripe:build'
end
