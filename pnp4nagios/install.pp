class icinga2::pnp4nagios::install {
  $ensure = $icinga2::pnp4nagios::params::ensure

  package { 'pnp4nagios':
    ensure => $ensure,
  }

}
