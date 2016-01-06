class icinga2::pnp4nagios::service {

  include icinga2::pnp4nagios

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

