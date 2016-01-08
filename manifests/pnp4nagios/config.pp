class icinga2::pnp4nagios::config {

  $package_name           = $icinga2::pnp4nagios::package_name
  $package_ensure         = $icinga2::pnp4nagios::package_ensure
  $service_name           = $icinga2::pnp4nagios::service_name
  $service_ensure         = $icinga2::pnp4nagios::service_ensure
  $service_enable         = $icinga2::pnp4nagios::service_enable
  $service_manage         = $icinga2::pnp4nagios::service_manage
  $htpasswd_config        = $icinga2::pnp4nagios::htpasswd_config
  $htpasswd_user          = $icinga2::pnp4nagios::htpasswd_user
  $htpasswd_group         = $icinga2::pnp4nagios::htpasswd_group
  $htpasswd_config_ensure = $icinga2::pnp4nagios::htpasswd_config_ensure
  $htpasswd_config_mode   = $icinga2::pnp4nagios::htpasswd_config_mode
  $httpd_path             = $icinga2::pnp4nagios::httpd_path
  $nagios_web_user        = $icinga2::pnp4nagios::nagios_web_user
  $nagios_web_pass        = $icinga2::pnp4nagios::nagios_web_pass
  $manage_pkg_dependency  = $icinga2::pnp4nagios::manage_pkg_dependency
  $monitoring_type        = $icinga2::pnp4nagios::monitoring_type
  $log_type               = $icinga2::pnp4nagios::log_type
  $debug_lvl              = $icinga2::pnp4nagios::debug_lvl
  $system_date            = $icinga2::pnp4nagios::system_date 

  file { "$httpd_path/$htpasswd_config":
    ensure  => $htpasswd_config_ensure,
    owner   => $htpasswd_user,
    group   => $htpasswd_group,
    mode    => $htpasswd_config_mode,
    content => template('icinga2/pnp4nagios.conf.erb'),
    notify  => Service['httpd'],
  }

  file { '/etc/nagios/passwd':
    ensure  => file,
    owner   => $htpasswd_user,
    group   => $htpasswd_group,
    content => template('icinga2/passwd.erb'),
    notify  => Service['httpd'],
  }

  file { '/etc/pnp4nagios/npcd.cfg':
    owner   => $htpasswd_user,
    group   => $htpasswd_group,
    notify  => Class[icinga2::pnp4nagios::service],
    content => template('icinga2/npcd.cfg.erb'),
  }

  ini_setting { "phptimezone":
    ensure  => present,
    path    => '/etc/php.ini',
    section => 'Date',
    setting => 'date.timezone',
    value   => $system_date,
  }

  exec { 'pnp_setup':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "/usr/bin/wget https://github.com/Icinga/icingaweb2-module-pnp/archive/master.zip -O /usr/share/icingaweb2/modules/pnp.zip",
    creates => "/usr/share/icingaweb2/modules/pnp.zip",
  } ->

  exec { 'pnp_extract':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "/usr/bin/unzip /usr/share/icingaweb2/modules/pnp.zip -d /usr/share/icingaweb2/modules/",
    creates => "/usr/share/icingaweb2/modules/pnp",
  } ->
  
  exec { 'pnp_move':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "/usr/bin/mv /usr/share/icingaweb2/modules/icingaweb2-module-pnp-master /usr/share/icingaweb2/modules/pnp",
    creates => "/usr/share/icingaweb2/modules/pnp",
  } ~>

  file { '/etc/icingaweb2/enabledModules/pnp':
    ensure  => 'link',
    target  => '/usr/share/icingaweb2/modules/pnp',
  }

  file { ['/var/log/pnp4nagios','/var/lib/pnp4nagios']:
    ensure  => 'directory',
    owner   => 'icinga',
    group   => 'icinga',
    recurse => true,
  }

}


