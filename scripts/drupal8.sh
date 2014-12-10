# Install Drush 7 (this only works temporarily)
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
export PATH="$HOME/.composer/vendor/bin:$PATH"
source ~/.profile
composer global require drush/drush:dev-master
composer global update
composer global require drush/drush:7.*


# Install latest version of Drupal 8
cd /var/www
git clone https://github.com/drupal/drupal.git drupal
mv /var/www/drupal/* /var/www/
rm -rf /var/www/drupal


mkdir sites/default/files

cp /var/www/sites/default/default.services.yml /var/www/sites/default/services.yml
cp /var/www/sites/default/default.settings.php /var/www/sites/default/settings.php

chmod a+w sites/default/settings.php
chmod a+w sites/default/services.yml
chmod a+w sites/default
chmod a+w sites/default/files

# Install Drupal
drush -y si standard --db-url=mysql://devdb:devdb@localhost/devdb --account-name=admin --account-pass=admin --site-name="Headless Drupal Template"


cd /var/www


# Enables Drupal 8 Modules
drush -y en rest language content_translation


