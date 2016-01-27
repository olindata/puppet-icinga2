class icinga2::pnp4nagios::service {

  $service_manage  = $icinga2::pnp4nagios::service_manage
  $service_name    = $icinga2::pnp4nagios::service_name
  $service_ensure  = $icinga2::pnp4nagios::service_ensure
  $service_enable  = $icinga2::pnp4nagios::service_enable

  if $service_manage == true {
    service {$service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $service_name,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}


