# ![SilverStripe-Capistrano][logo]

SilverStripe-Capistrano is a collection of [Ruby][ruby] and [Capistrano][capistrano] files, allowing you to easily configure [SilverStripe][silverstripe] for deployments using [Capistrano][capistrano].

[![Version Number][shield-version]][info-version]
[![License][shield-license]][info-license]

## Key Features
- Kept up to date with changes to [SilverStripe][silverstripe] and [Capistrano][capistrano].


## Getting Started
### Installation
#### Ruby
SilverStripe-Capistrano has been tested with version `2.2.3` of ruby. To install `2.2.3` with [RVM][rvm] use the below command

```bash
rvm install 2.2.3
rvm use 2.2.3
```

**Note:** This script *should* work with other versions of Ruby, your results may vary.


#### Capistrano
SilverStripe-Capistrano requires Capistrano version `3.4.0` which can be installed using the below command`

```bash
gem install capistrano -v 3.4.0
```


### Preparing your project
**Commit your code to GIT** - before we can deploy our code it needs to be committed into GIT onto a branch we have access to.

It is also recommended that you add the contents of `gitignore.example` to your `.gitignore` file.


### Copying SilverStripe-Capistrano files into your project
Using the script below, from the root or your project you can automate the download of our [Capistrano][capistrano] config.

**NOTE:** The below script will **OVERWRITE** the contents of the files listed below which already exist in your project.

```bash
mkdir -p config
mkdir -p config/deploy
curl -O https://raw.githubusercontent.com/mattrayner/silverstripe-capistrano/master/Gemfile
curl -O https://raw.githubusercontent.com/mattrayner/silverstripe-capistrano/master/Capfile
cd config
curl -O https://raw.githubusercontent.com/mattrayner/silverstripe-capistrano/master/config/deploy.rb
cd deploy
curl -O https://raw.githubusercontent.com/mattrayner/silverstripe-capistrano/master/config/deploy/staging.rb
curl -O https://raw.githubusercontent.com/mattrayner/silverstripe-capistrano/master/config/deploy/production.rb
cd ../..
```

Alternatively you can copy each of the files into your repository manually. This is the recommended approach if you have any file clashes.


### Configuring Capistrano
If you are unfamiliar with Capistrano, it's recommended that you read over the documentation on the [Capistrano][capistrano] website. This will give you a good overview of how it works as well as details on how to properly configure a Capistrano installation.


#### Server Configuration
Start off by configuring the `staging.rb` and `production.rb` files in the `/config/deploy` directory. Feel free to add or remove server configuration files as needed. Just be sure and set appropriate config names at the top (ie. `set :prod, :production`).

There are a few custom variables at the top that differ from the default Capistrano configuration. These are necessary to allow the SilverStripe tasks to work properly.

Set the `website_url` to the full web address of your application. This is used to recache the homepage of your site after a build.

Set the `curl_command` to the desired flush web address for your application. This will be used in an attempt to flush your application's front-end cache.

Set the four database variables for the database host, name, username, and password of the MySQL database used for your SilverStripe application. This will allow backup and restore tasks to be performed during a deploy or rollback.

It’s recommended that a SSH key be setup rather than adding a password to the config files. Visit the [Github](https://help.github.com/articles/generating-ssh-keys) site for help on generating a SSH key.


#### Deploy Configuration
Continue configuration by updating the `deploy.rb` file in the `/config` directory. If needed, use the [Preparing Your Application](http://capistranorb.com/documentation/getting-started/preparing-your-application/) page on the Capistrano website for reference. The `application`, `repo_url`, and `deploy_to` variables are required by default.

The `deploy_to` variable should point to where you want your Capistrano files to live on the server. If you're managing multiple applications on the same server then you might want to deploy them based on application name. I typically create a `capistrano` directory that's just above where all the site files live. Where and how you wish to manage your Capistrano deploys is entirely up to you though.

Towards the bottom of the `deploy.rb` file there are two variables, `tmp_dir` and `db_backup_dir`. It's recommended that you set these explicitly to avoid errors.

It's also recommended that you check the `linked_files` and `linked_dirs` to ensure that they include the files and directories that are not tracked by the repo. These files and directories will need to be added to the `shared` directory, which we'll get to in a sec.


#### Remote Server Configuration
You'll need to setup the directory where Capistrano files will live on the server. Be sure that this matches what you set for the `deploy_to` variable in the `deploy.rb` config file.

There are a number of directories you should create so that capistrano can work correctly. Run the below command to automate this process

Replace `ENVIRONMENT` with one of your server configurations i.e. `staging` or `production`.


##### `_ss_environment.php` Configuration
In order for `sake` to run a `dev/build` on the server, you'll need to update your `_ss_environment.php` config so that it includes the `_FILE_TO_URL_MAPPING` variable:

```php
// This is used by sake to know which directory points to which URL
global $_FILE_TO_URL_MAPPING;
$_FILE_TO_URL_MAPPING[realpath('/var/www/public_html')] = 'http://www.yoursite.com';
```

You will need to replace `/var/www/public_html` and `http://www.yoursite.com` with the correct details for your setup.

More information about this can be found on the [SilverStripe Documentation](http://doc.silverstripe.org/framework/en/topics/commandline) site.

###### **OPTIONAL** environment $_GET config
This is an **optional** and not very secure addition you can make to your `_ss_environment.php` file. It will allow you to use `?flush=all` in dev move even on production installations. This is a less error-prone way of flushing the front-end cache on a production server.

It is important however that you also consider the downsides. Useing the below code makes deploying a bit easier but also opens your website up to possible vulnerabilities.

Any page can be viewed in `dev` mode. This is done entirely at your own risk and is not strictly required.

```php
$env_type = isset($_GET['env_type']) ? $_GET['env_type'] : 'test';
define('SS_ENVIRONMENT_TYPE', $env_type);
```


#### Final Steps
To make sure that Git (and your server) is setup properly for a successful deploy, it’s recommended that a `deploy:check` be executed prior to deploying for the first time:

`cap staging deploy:check`

To run a deploy on either staging or production, simply call Capistrano for the environment of your choice:

`cap production deploy`

Don’t forget to import in any changes to the database! Be sure and test the site to ensure that everything is working as it should.


## Changelog
The full-ish changelog is available in [CHANGELOG.md][changelog]


## Requirements
SilverStripe-Capistrano requires the following:
* [Ruby][ruby] (tested with 2.2.3)
* [Capistrano][capistrano] (designed for 3.4.0)
* [Curl][curl] (for install script automation)
* [Composer][composer] (required server-side to install SilverStripe)


## Roadmap
A list (in no particular order) or future feature ideas:
* Automation script.
    * Some kind of php/ruby/sh script that will automatically setup SilverStripe-Capistrano within a project.
* Custom GEM.
    * Instead of adding Capistrano to your GEMFILE, we'll use our own which depends on a certain Capistrano version.


## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Clone it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Maintainers
Originally created by [Jeff Whitfield][jeffwhitfield], now maintained by [Matt Rayner][mattrayner].


## License
SilverStripe-Capistrano is licensed under the [MIT License][info-license].

[logo]: https://raw.github.com/mattrayner/silverstripe-capistrano/master/silverstripe-capistrano-logo.png

[ruby]: https://www.ruby-lang.org/en/
[capistrano]: http://capistranorb.com/
[silverstripe]: https://www.silverstripe.org/
[rvm]: https://rvm.io/
[composer]: https://getcomposer.org/

[changelog]: CHANGELOG.md

[info-version]: https://github.com/mattrayner/silverstripe-capistrano
[info-license]: LICENSE
[shield-version]: https://img.shields.io/badge/Version-0.1.1--beta-brightgreen.svg
[shield-license]: https://img.shields.io/badge/license-MIT-blue.svg

[jeffwhitfield]: https://github.com/jeffwhitfield
[mattrayner]: https://github.com/mattrayner