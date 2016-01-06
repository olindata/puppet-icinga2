class icinga2::pnp4nagios::config inherits icinga2::pnp4nagios {

  $monitoring_type = 'icinga'
  $log_type = 'syslog'
  $debug_lvl = 1
  $system_date = generate('/usr/bin/date', '+%Z')

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
    notify  => Service['httpd'],
  }

  exec { 'htpasswd':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "htpasswd -db /etc/nagios/passwd $nagios_web_user $nagios_web_pass",
    subscribe   => File["/etc/nagios/passwd"],
    refreshonly => true
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

  file { ['/var/log/pnp4nagios/','/var/lib/pnp4nagios/']:
    owner   => 'icinga',
    group   => 'icinga',
    recurse => true,
  }

}


