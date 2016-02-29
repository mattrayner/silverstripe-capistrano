namespace :silverstripe do
  namespace :composer do
    desc 'Run Composer update'
    task :update do
      on roles(:web) do
        within release_path do
          execute :composer, 'install'
        end
      end
    end
  end

  desc 'Run SilverStripe dev/build'
  task :build do
    on roles(:web) do
      within fetch(:deploy_to) do
        execute :rm, '-R shared/silverstripe-cache/*'
        # Need to figure out issues with flushing the cache before enabling curl
        execute :curl, "#{fetch(:curl_command)} -v -L"
      end

      within release_path do
        execute :php, 'framework/cli-script.php dev/build'
      end
    end
  end

  namespace :db do
    desc 'Backup the database'
    task :backup do
      on roles(:db) do
        within fetch(:db_backup_dir) do
          releases = capture(:ls, '-xr', releases_path).split
          if releases.length > 0
            last_release = releases.first
            execute :mysqldump, "-u#{fetch(:db_user)} --password='#{fetch(:db_password)}' --host='#{fetch(:db_host)}' #{fetch(:db_name)} > ./#{last_release}.sql"
          end
        end
      end
    end
    desc 'Purge old backups'
    task :purge do
      on roles(:db) do
        within fetch(:db_backup_dir) do
          backup_files = capture("ls -t #{fetch(:db_backup_dir)}/*").split.reverse
          if backup_files.length > fetch(:keep_releases)
            delete_backups = (backup_files - backup_files.last(fetch(:keep_releases))).join(" ")
            execute :rm, "-rf #{delete_backups}"
          end
        end
      end
    end
    desc 'Restore database'
    task :restore do
      on roles(:db) do
        within fetch(:db_backup_dir) do
          releases = capture(:ls, '-xr', releases_path).split
          if releases.length > 1
            latest_release = releases[0]
            rollback_release = releases[1]
            execute :mysqldump, "-u#{fetch(:db_user)} --password='#{fetch(:db_password)}' --host='#{fetch(:db_host)}' #{fetch(:db_name)} > ../rolled-back-release-#{latest_release}.sql && mysql -u#{fetch(:db_user)} --password='#{fetch(:db_password)}' --host='#{fetch(:db_host)}' #{fetch(:db_name)} < ./#{rollback_release}.sql"
          end
        end
      end
    end
  end

  desc 'Check for silverstrip-capistrano specific files and folders.'
  task :check do
    on roles(:db) do
      within fetch(:deploy_to) do
        execute :mkdir, "-p #{fetch(:db_backup_dir)}"
        execute :mkdir, "-p #{fetch(:tmp_dir)}"
      end
    end
  end
end