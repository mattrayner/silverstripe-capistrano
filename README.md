# SilverStripe Capistrano v0.0.1-beta

A recipe and configuration for managing a SilverStripe application with Capistrano

## Installation ##

* **Install Capistrano**

    Visit the Capistrano [Installation](http://capistranorb.com/documentation/getting-started/installation/) page for information on how to install Capistrano. If you've used Ruby before, installing it should be just a matter of running '`gem install capistrano`' from the command line.

* **Commit application to Git**

    Be sure and commit your code to a Git repo prior to setting up Capistrano.

* **Move sensitive files out of repo**

    Avoid committing config files and assets to the repo. Those will be added to a shared directory as linked files and directories. Be sure and remove these from being tracked and add their path to your `.gitignore` file. Take a look at the `gitignore.example` file for recommended additions to the `.gitignore` file.

* **Copy all files from the SilverStripe Capistrano repo to your application repo**

    Included is a copy of Composer. To avoid issues with Composer being out of date on the remote server, the tasks used for SilverStripe updates have been configured to use this copy of Composer instead. If you'd like to make sure the version of Composer is up to date, run the following from the root of your repo after copying over the files:

    `curl -sS https://getcomposer.org/installer | php`

* **Configure Capistrano**

    Before going any further, be sure and configure Capistrano using the instructions below.

## Configuration ##

If you are unfamiliar with Capistrano, it's recommended that you read over the documentation on the [Capistrano](http://capistranorb.com/) website. This will give you a good overview of how it works as well as details on how to properly configure a Capistrano installation.

### Server Configuration ###

Start off by configuring the `staging.rb` and `production.rb` files in the `/config/deploy` directory. Feel free to add or remove server configuration files as needed. Just be sure and set appropriate config names at the top (ie. `set :prod, :production`).

There are a few custom variables at the top that differ from the default Capistrano configuration. These are necessary to allow the SilverStripe tasks to work properly.

Set the `root_dir` variable to point to the directory used by your application. This will be used to execute the tasks required to build and recache your application after a successful deploy. This will be the same path that is used for the symbolic link that points to the current Capistrano release (ie. `htdocs`, `public_html`, `www`, etc.).

Set the `website_url` to the full web address of your application. This is used to recache the homepage of your site after a build.

Set the three database variables for the database name, username, and password of the MySQL database used for your SilverStripe application. This will allow backup and restore tasks to be performed during a deploy or rollback.

It’s recommended that a SSH key be setup rather than adding a password to the config files. Visit the [Github](https://help.github.com/articles/generating-ssh-keys) site for help on generating a SSH key.

### Deploy Configuration ###

Continue configuration by updating the `deploy.rb` file in the `/config` directory. If needed, use the [Preparing Your Application](http://capistranorb.com/documentation/getting-started/preparing-your-application/) page on the Capistrano website for reference. The `application`, `repo_url`, and `deploy_to` variables are required by default.

The `deploy_to` variable should point to where you want your Capistrano files to live on the server. If you're managing multiple applications on the same server then you might want to deploy them based on application name. I typically create a `capistrano` directory that's just above where all the site files live. Where and how you wish to manage your Capistrano deploys is entirely up to you though.

Towards the bottom of the `deploy.rb` config is a variable called `tmp_dir`. It's recommended that you set this one explicitly to avoid errors.

It's also recommended that you check the `linked_files` and `linked_dirs` to ensure that they include the files and directories that are not tracked by the repo. These files and directories will need to be added to the `shared` directory, which we'll get to in a sec.

### Remote Server Configuration ###

You'll need to setup the directory where Capistrano files will live on the server. Be sure that this matches what you set for the `deploy_to` variable in the `deploy.rb` config file.

Within this directory, it’s recommended that directories for the `tmp_dir` as well as a `shared` directory be created. Within the `shared` directory, create a `silverstripe-cache` directory, a `vendor` directory (for Composer updates), and upload any shared files and folders that all deploys will share. This will likely include the `assets` directory, config files, and any other files and folders that are not tracked by Git. All of the files and directores within the `shared` directory will need to be added to the `linked_files` and `linked_dirs` variables in the `deploy.rb` config file.

### Final Steps ###

To make sure that Git is setup properly for a successful deploy, it’s recommended that a `git:check` be executed prior to deploying for the first time:

`cap staging git:check`

To run a deploy on either staging or production, simply call Capistrano for the environment of your choice:

`cap production deploy`

In order for the remote server to use the Capistrano deployment, the root web directory of the server (the one set in the `root_dir` variable) must be linked to the `current` folder within the Capistrano deployment directory. To do this, remove the directory that is currently being used as the root folder for the website and then recreate it as a symbolic link to the current folder:

`ln -sf ~/capistrano/current ~/public_html`

***Note**: The paths above are for example purposes and may be different for your configuration.*

Don’t forget to import in any changes to the database! Be sure and test the site to ensure that everything is working as it should.


## Bugtracker ##

Bugs are tracked on [github.com](https://github.com/jeffwhitfield/silverstripe-capistrano/issues). Feel free to offer suggestions and contribute to the codebase.

## Links ##

 * [Capistrano](http://capistranorb.com/)

## Changelog ##

[Changelog](https://github.com/jeffwhitfield/silverstripe-capistrano/blob/master/changelog.md)
