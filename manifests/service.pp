# vector::service
#
# @summary
#   Manages the systemd service for vector
class vector::service {
  assert_private()
  if $vector::manage_systemd {
    service { $vector::service_name:
      ensure => $vector::service_ensure,
      enable => $vector::service_enabled,
    }
  }
}
