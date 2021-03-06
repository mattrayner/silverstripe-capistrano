# Changelog

### 0.1.1-beta - Feb 29, 2016

* Updated rake task to run `composer install` rather than `composer update`
* Updated rake task to remove `silverstipe-cache` folder contents before `dev/build`
* Updated rake task to cURL specific URL to flush via the browser before `dev/build`
* Updated rake task static string formatting to be consistent
* Updated staging and production deploy sample files to include a per-environment `deploy_to` variable
* Updated staging and production deploy samples to include a more flexible cURL command for front-end flushing
* Updated staging and production deploy samples - commented out 'simple' server syntax
* Revd version number

### 0.1.0-beta - Feb 25, 2016

* Repository transferred to Matthew Rayner
* Updated to work with Capistrano 3.0.4
* Updated capfile to use `*.rake` instead of `*.cap`
* Updated `silverstripe.rake` to use system composer instead of out-of-date repo version.
* Added variable for cache-flushing URL in platform deploy files
* Added branch variable into deploy stage files
* Removed redundant `root_dir` variables from `staging.rb` and `production.rb`
* Added `sliverstripe:check` task to ensure `db_backup_dir` and `tmp_dir` are present on the server
* Added `.ruby-version` file
* Added `LICENSE` file - we're MIT!
* Updated `README.md` file with new instructions and installation scripts

### 0.0.3-beta - Feb 10, 2014

* Added variable for database backup location
* Updated temp directory variable for consistency in formatting
* Refactored SilverStripe tasks file with consistent command formatting
* Commented out curl command till solution to flushing the cache is found
* Updated documentation with information about caching problems

### 0.0.2-beta - Feb 9, 2014

* Added SilverStripe configuration requirements
* Updated MySQL commands to include a custom hostname variable

### 0.0.1-beta - Feb 8, 2014

* Initial release

