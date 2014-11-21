Forked from https://github.com/mwalters/simple-vagrant-lamp

# Simple Vagrant LAMP box

## Features
- Simple administration. This script doesn't require the learning curve of Puppet or Chef, though I recommend you looking into either of those solutions. Instead, it uses a simple shell script to install packages and import the database.
- VM Description
	- 1GB RAM
	- Ubuntu 14.04 LTS (trusty)
	- Apache w/ mod_rewrite
	- MySQL
	- PHP
	- Pear
	- [MailCatcher](http://mailcatcher.me/)
	- MySQL database named `devdb` and a username of `devdb` having access to it with the password `devdb`

## Setup
The `Vagrantfile` shares 4 folders from your host machine into your VM: `./www`, `./sqldump`, `./scripts`, and `./custom_config/files`. If these folders don't exist they will be created when `vagrant up` is run. It is recommended to symlink folders from your current project to these in the vagrant folder and then you can change the symlinks to move between projects - e.g. `ln -fs ~/Sites/dev ./www`. You can do this either before or after `vagrant up`.

These folders are used as follows:
- www
	- This is the web root of the website you want hosted in the VM
- sqldump
	- This is where the database SQL file is stored. Initially it's fine for this to be empty, but if you destory the VM, a sqldump file located here will be imported into the VM's database when it is created. The file should be named `database.sql`
- scripts
	- There is a shell script file called `dumpdb.sh` located here. It can be run from within the vagrant machine (`vagrant ssh` to log in) in order to create a `database.sql` file which can be used for re-importing a database when creating the virtual machine.  You can locate any scripts here that you would like to have available within the virutal machine.
- custom_config_files
	- Inside of here, by default, is an apache2 directory containing the file `default`.  This file is the default virtual host file.  So you can alter it to align with your needs for the site you are attempting to host in the virtual machine.

When you first boot the VM or recreate it, you might see some warning messages from apache about not being able to determine the ServerName. The bootstrap file eventually fixes this as it goes through its process.

Edit your local hosts file to point a domain to `192.168.56.101` then use that domain in your browser to hit the site your VM is serving.

## What is the bootstrap.sh script doing?
- This file is only run when the virtual machine is initially created or recreated after a `vagrant destroy`
- Sets the MySQL root password to `root`
- Updates software on the VM
- Installs necessary packages
- Sets the timezone on the machine to `America/New_York`
- Deletes the `test` database in MySQL
- Creates the `devdb` MySQL database and user
- Sets ServerName for Apache to keep it from complaining
- Enables mod_rewrite
- Places the default Apache virtual host file
- Install MailCatcher
- Sets PHP configuration values:
	- Send mail via MailCatcher
	- Turns on `display_errors`
	- Turns on `error_reporting` and sets to development values (display everything)
	- Turns on `html_errors`
- Starts MailCatcher
- Restarts Apache

## What is the load.sh script doing?
- This file is run every time the virtual machine is started from a `vagrant up`
- Imports `database.sql` into the `devdb` database if the file exists

## Using MailCatcher
- Load [http://192.168.56.101:1080/](http://192.168.56.101:1080/) in your browser to view the MailCatcher interface

## What is MailCatcher?
Check out the [MailCatcher](http://mailcatcher.me/) homepage, but the short description is that it catches email being sent and let's you view it via a web interface (port 1080 on the VM). This way you don't have to actually send email through the internet and wait for it to be delivered, etc. You can check the queue with your browser easily and clear it whenever you'd like. This also means that you could make your VM send thousands of emails (intentionally or unintentionally) and easily see if they would have been delivered.



## How to Drupal

Once you install drupal, do the following:
```
vagrant ssh
cd /var/www
./drupal.sh
```

This repo is set up with Drupal 7, which you can download [here](https://www.drupal.org/project/drupal).

### Modules
	- Admin, Admin menu, Adminimal
		- Much better Toolbar
		> Also must disable Drupal's native toolbar
	- Backup & Migrate
		- Allows you to backup the entire site
	- CKEditor
		- provides a full text editor for body posts
	- CORS
		- allows cross origin resource sharing
	- CTools
		- dependency to many tools
	- Entity & Entity Translation
		- Allows you to translate individual elements in a page or block
	- Features
		- Lets you create custom modules, containing views and content types
	- File Entity
		- Allows files like images to be a field, and editable
	- i18n, i18n Views
		- Also helps with translation
	- Instant Filter
		- Allows you to filter admin data
	- Libraries
		- used for dependency management, and is required by the REST Server
	- Media
		- permits use of different types of elements, and allows the use of pictures and videos in textareas
	- Metatag
		- allows you to adds metatags to pages
	- Pathauto
		- Allows the user to rename URLs
	- REST Server (restws)
		- actual server that throws the API calls
	- Rules, Rules UI, Rules Scheduler
		- required by the Entity module
	- Services, Services Menu, Services Views, Services Tools
		- Allows to create an API
	- Scheduler
		- Set a time for content to be published and/or unpublished
	- TMGMT
		- Translation management, allowing you to cleanly manage multiple languages
	- Token
		- require for small pieces of data, like metatags
	- Transliteration
		- converts non-latin text to US-ASCII and sanitizes file names
	- Variable
		- required by absolutely everything to do translations
	- Views
		- Allows you to create Views, and Drupal's most important module. Essentially custom SQL calls
	- Viewfield & Views_field_view
		- allows views to be selected as fields in creation of new content types
	- Views Bulk Operations
		- allows you to do the same task on multiple views (required for translation)
	- Views_Contextual_Filter_Query
		- allows customized query strings in the API calls


## Architecture Strategy

Key Content Types, which will correspond to a View and Content Type
- Unique page (Home page, About us page)
- Product Page
- Individual components
- Articles


## Initial Configuration for Multilingual and API support

1. Create Rest Service
Structure > Services > Add
Create a new rest server with whatever name and endpoint you like
- beside your service, click 'edit resources'
- enable 'menu' to be queried
People > Permissions
- under 'Services Menu', check off 'Get menu' under the 'anonymous user' list

2. Set secondary language
Configuration > Regional and language > Languages > +Add Language > French (Français)
Click 'save'
When the full list is shown, select 'edit' in the English table row
Under 'Path Language Prefix Code', enter 'en'
Under the tab 'Detection and Selection', enable 'URL' as a detection method
* Make sure you do the final 2 step in creating/customizing a content type

For Menus being translatable
- select 'edit menu' for the menu you want translatable
- under 'Multilingual options', select 'Translate and Localize'
- Generally, you need to make the English text 'language neutral', and then translate that into French
- If you make it English, it will create a second link in french. ONLY do this if the two menu items have different URLs

3. Create your custom Content Type
Structure > Content Types
Customize whatever fields you want it to have
Add a field called 'Language' with the type 'Language Combination' to enable Languages completely
Publishing options > Enable with field translation
Each field you want translatable must be enabled individual.
For example, for 'Body', select 'edit' under Operations, scroll to bottom, click 'Enable translation'

4. Create a View
Structure > Views > Add New View
SHOW: Show content type of [your content type here]
DISPLAY FORMAT: Unformatted list of [fields]
Click 'Continue & edit'
Set the fields you would like shown, then filters like language
Beside the 'Page' tab at the top, click +Add, select 'Services'
Under 'Service Settings', click the '/' beside 'Path'
Type in a URL, which will become the API endpoint for this view
Click 'Save'
Under the Page tab:
Fields:
- add all the content you would like the api call to reveal
Filter criteria:
- add Content: Language > 'is one of' -> Default site language
Contextual filters:
- add Content: title (or however you'd like to query the view)
Provide default value >
	Type: Query parameter from URL
	Parameter name: [insert parameter name here]

5. Return to Rest Service
Structure > Services
- beside your service, click 'edit resources'
- select whatever views you would like exposed

6. Create Content
- with your custom content type, create a piece of content


Theme
	- Adminimal theme (make sure to set this for administration view)


## How to Schedule Content to be Publish and Unpublished
Config:
1. Get the Scheduler module and enable it
2. Under Content type settings for a particular type, scroll down to the bottom list of options
3. Under 'Publish Options', disable 'Published' as a default option
4. Under 'Scheduler settings', enable what you like, such as 'enable scheduled publishing' and 'enable scheduled unpublishing'
