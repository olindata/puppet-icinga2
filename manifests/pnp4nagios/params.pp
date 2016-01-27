class icinga2::pnp4nagios::params {
  case $::osfamily {
    'RedHat': {
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
       $manage_pkg_dependency  = true
       $monitoring_type        = 'icinga'
       $log_type               = 'syslog'
       $debug_lvl              = '1'
       $system_date            = 'UTC'
       $manage_php_timezone    = true
     }
     default: {
       fail("Module ${module_name} is not supported on ${::osfamily}")
     }
  }

}

