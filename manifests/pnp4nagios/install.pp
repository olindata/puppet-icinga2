class icinga2::pnp4nagios::install inherits icinga2::pnp4nagios {

  package {$package_name:
    ensure => $package_ensure,
  }

  if $manage_pkg_dependency == true {
    package { ['wget','unzip']:
      ensure => present,
    }
  }

}
