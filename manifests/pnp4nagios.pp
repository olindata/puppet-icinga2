class icinga2::pnp4nagios (
  $package_name           = $icinga2::pnp4nagios::params::package_name,
  $package_ensure         = $icinga2::pnp4nagios::params::package_ensure,
  $service_name           = $icinga2::pnp4nagios::params::service_name,
  $service_ensure         = $icinga2::pnp4nagios::params::service_ensure,
  $service_enable         = $icinga2::pnp4nagios::params::service_enable,
  $service_manage         = $icinga2::pnp4nagios::params::service_manage,
  $htpasswd_config        = $icinga2::pnp4nagios::params::htpasswd_config,
  $htpasswd_user          = $icinga2::pnp4nagios::params::htpasswd_user,
  $htpasswd_group         = $icinga2::pnp4nagios::params::htpasswd_group,
  $htpasswd_config_ensure = $icinga2::pnp4nagios::params::htpasswd_config_ensure,
  $htpasswd_config_mode   = $icinga2::pnp4nagios::params::htpasswd_config_mode,
  $httpd_path             = $icinga2::pnp4nagios::params::httpd_path,
  $nagios_web_user        = $icinga2::pnp4nagios::params::nagios_web_user,
  $nagios_web_pass        = $icinga2::pnp4nagios::params::nagios_web_pass,
  $manage_pkg_dependency  = $icinga2::pnp4nagios::params::manage_pkg_dependency,
) inherits icinga2::pnp4nagios::params {

  # Validation
  validate_string($package_name)
  validate_string($package_ensure)
  validate_string($service_name)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_bool($service_manage)
  validate_string($htpasswd_config)
  validate_string($htpasswd_user)
  validate_string($htpasswd_group)
  validate_string($htpasswd_config_ensure)
  validate_string($htpasswd_config_mode)
  validate_absolute_path($httpd_path)
  validate_string($nagios_web_user)
  validate_string($nagios_web_pass)
  validate_bool($manage_pkg_dependency)

  anchor {'icinga2::pnp4nagios::begin':} ->
  class {'icinga2::pnp4nagios::install':} ->
  class {'icinga2::pnp4nagios::config':} ->
  class {'icinga2::pnp4nagios::service':} ->
  anchor {'icinga2::pnp4nagios::end':}

}


