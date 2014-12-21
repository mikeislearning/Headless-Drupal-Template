# Install Drupal
cd /var/www && drush dl drupal-7.34
mv /var/www/drupal-7.34/* /var/www/ && rm -rf /var/www/drupal-7.34

cp /var/www/sites/default/default.settings.php /var/www/sites/default/settings.php

chmod a+w /var/www/sites/default/settings.php
chmod a+w /var/www/sites/default
chmod a+w /var/www/sites/default/files

mkdir /var/www/backups
chmod a+w /var/www/backups

# Install latest version of Drupal 7
cd /var/www && drush -y si standard --db-url=mysql://devdb:devdb@localhost/devdb --account-name=admin --account-pass=admin --site-name="Headless Drupal"

# Get the adminimal theme
drush dl adminimal_theme

# Download the beta modules
drush dl media-7.x-2.x-dev


# Enable Drupal modules
drush -y en admin admin_devel admin_menu adminimal_admin_menu addressfield backup_migrate better_exposed_filters breakpoints ckeditor coffee conditional_fields cors ctools date date_popup dba devel enterprise_base entity entity_translation entity_translation_i18n_menu entity_translation_upgrade entityconnect entityqueue entityreference feeds field_group geolocation gmap i18n i18n_block i18n_contact i18n_field i18n_menu i18n_node i18n_path i18n_select i18n_taxonomy i18n_variable instantfilter libraries location link media metatag pathauto picture rest_server restws rules rules_admin rules_i18n rules_scheduler scheduler services services_views services_menu site_map strongarm tablefield tmgmt tmgmt_field tmgmt_language_combination tmgmt_entity tmgmt_entity_ui tmgmt_i18n_string tmgmt_local tmgmt_locale tmgmt_node tmgmt_node_ui tmgmt_ui token transliteration variable variable_admin variable_realm variable_store variable_views views views_field_view views_fieldset views_json views_ui views_bulk_operations views_contextual_filter_query viewfield

# Allows ctools css caching (currently not working)
# mkdir /var/www/sites/default/files/ctools/css
# chmod a+w /var/www/sites/default/files/ctools/css


















