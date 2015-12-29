class icinga2::pnp4nagios::config inherits icinga2::pnp4nagios {

  $monitoring_type = 'icinga'
  $log_type = 'syslog'
  $debug_lvl = 1

  file {$htpasswd_config:
    path   => "$httpd_path/$htpasswd_config",
    ensure => $htpasswd_config_ensure,
    owner  => $htpasswd_user,
    group  => $htpasswd_group,
    mode   => $htpasswd_config_mode,
    source => "puppet:///modules/${module_name}/pnp/$htpasswd_config",
    notify => Service['httpd'],
  }

  file { '/etc/nagios/passwd':
    ensure  => file,
    owner   => 'root',
    group   => 'apache',
    source  => "puppet:///modules/${module_name}/pnp/pnp_auth.txt",
    notify  => Service['httpd'],
  }

  file { 'npcdcfg':
    name => '/etc/pnp4nagios/npcd.cfg',
    owner => root,
    group => root,
    notify => Class[icinga2::pnp4nagios::service],
    content => template('icinga2/npcd.cfg.erb'),
  }

  file_line{ 'date.timezone':
    path => '/etc/php.ini',
    line => "date.timezone = Europe/Amsterdam",
    match => "^;date.timezone.*$",
  }

  exec { 'pnp_setup':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "wget https://github.com/Icinga/icingaweb2-module-pnp/archive/master.zip -O /usr/share/icingaweb2/modules/pnp.zip",
    creates => "/usr/share/icingaweb2/modules/pnp.zip",
  } ->

  exec { 'pnp_extract':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "unzip /usr/share/icingaweb2/modules/pnp.zip -d /usr/share/icingaweb2/modules/",
    creates => "/usr/share/icingaweb2/modules/pnp",
  } ->
  
  exec { 'pnp_move':
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "mv /usr/share/icingaweb2/modules/icingaweb2-module-pnp-master /usr/share/icingaweb2/modules/pnp",
    creates => "/usr/share/icingaweb2/modules/pnp",
  } ~>

  file { '/etc/icingaweb2/enabledModules/pnp':
    ensure  => 'link',
    target  => '/usr/share/icingaweb2/modules/pnp',
  }

  file { ['/var/log/pnp4nagios/','/var/lib/pnp4nagios/']:
    owner   => 'icinga',
    group   => 'icinga',
    recurse => true,
  }

}

