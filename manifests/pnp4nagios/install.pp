class icinga2::pnp4nagios::install {

  $package_name           = $icinga2::pnp4nagios::params::package_name
  $package_ensure         = $icinga2::pnp4nagios::params::package_ensure
  $manage_pkg_dependency  = $icinga2::pnp4nagios::params::manage_pkg_dependency

  package {$package_name:
    ensure => $package_ensure,
  }

  if $manage_pkg_dependency == true {
    package { ['wget','unzip']:
      ensure => present,
    }
  }

}

