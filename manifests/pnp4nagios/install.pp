class icinga2::pnp4nagios::install inherits icinga2::pnp4nagios {
  package {$package_name:
    ensure => $package_ensure,
  }

  package { ['wget','unzip']:
    ensure => present,
  }

}
