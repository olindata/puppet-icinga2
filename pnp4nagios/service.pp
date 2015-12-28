class icinga2::pnp4nagios::service {

  $servicename = 'npcd'

  service { 'npcd':
    name => $servicename,
    ensure => $ensure,
    hasstatus => true,
    hasrestart => true,
  }

}

