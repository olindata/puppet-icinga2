class icinga2::pnp4nagios {
  class{'icinga2::pnp4nagios::params':} ->
  class{'icinga2::pnp4nagios::install':} ->
  class{'icinga2::pnp4nagios::service':} ->
  Class["icinga2::pnp4nagios"]

}
