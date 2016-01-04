class icinga2::pnp4nagios::params {
  $package_name           = 'pnp4nagios'
  $package_ensure         = 'present'
  $service_name           = 'npcd'
  $service_ensure         = 'running'
  $service_enable         = true
  $service_manage         = true
  $htpasswd_config        = 'pnp4nagios.conf'
  $htpasswd_user          = 'root'
  $htpasswd_group         = 'apache'
  $htpasswd_config_ensure = 'present'
  $htpasswd_config_mode   = '0644'
  $httpd_path             = '/etc/httpd/conf.d'
  $nagios_web_user        = 'nagiosadmin'
  $nagios_web_pass        = 'nagios'
  $manage_php_timezone    = true
}

