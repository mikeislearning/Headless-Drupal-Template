# Set MySQL root password
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'

# Install packages
apt-get update
apt-get -y install mysql-server-5.5 php5-mysql libsqlite3-dev apache2 php5 php5-dev build-essential php-pear ruby1.9.1-dev php5-gd drush

# Install Drupal modules
drush -y dl admin admin_menu adminimal_admin_menu backup_migrate breakpoints ckeditor cors ctools entity entity_translation features i18n instantfilter libraries media metatag pathauto picture restws rules scheduler services services_views services_menu site_map transliteration tmgmt token variable views viewfield views_field_view views_bulk_operations views_contextual_filter_query

# Enable Drupal modules
drush -y en admin admin_menu adminimal_admin_menu backup_migrate breakpoints ckeditor cors ctools entity entity_translation entity_translation_i18n_menu entity_translation_upgrade features i18n i18n_block i18n_contact i18n_field i18n_menu i18n_node i18n_path i18n_select i18n_taxonomy i18n_variable instantfilter libraries media metatag pathauto picture rest_server restws rules rules_admin rules_i18n rules_scheduler scheduler services services_views services_menu site_map tmgmt tmgmt_field tmgmt_language_combination tmgmt_entity tmgmt_entity_ui tmgmt_i18n_string tmgmt_local tmgmt_locale tmgmt_node tmgmt_node_ui tmgmt_ui token transliteration variable variable_admin variable_realm variable_store variable_views views views_field_view views_ui views_bulk_operations views_contextual_filter_query viewfield

# Set timezone
echo "America/New_York" | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Setup database
echo "DROP DATABASE IF EXISTS test" | mysql -uroot -proot
echo "CREATE USER 'devdb'@'localhost' IDENTIFIED BY 'devdb'" | mysql -uroot -proot
echo "CREATE DATABASE devdb" | mysql -uroot -proot
echo "GRANT ALL ON devdb.* TO 'devdb'@'localhost'" | mysql -uroot -proot
echo "FLUSH PRIVILEGES" | mysql -uroot -proot

# Apache changes
echo "ServerName localhost" >> /etc/apache2/apache2.conf
a2enmod rewrite
cat /var/custom_config_files/apache2/default | tee /etc/apache2/sites-available/000-default.conf

# Install Mailcatcher
echo "Installing mailcatcher"
gem install mailcatcher --no-ri --no-rdoc
mailcatcher --http-ip=192.168.56.101

# Configure PHP
sed -i '/;sendmail_path =/c sendmail_path = "/usr/local/bin/catchmail"' /etc/php5/apache2/php.ini
sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
sed -i '/html_errors = Off/c html_errors = On' /etc/php5/apache2/php.ini

# Make sure things are up and running as they should be
mailcatcher --http-ip=192.168.56.101
service apache2 restart
