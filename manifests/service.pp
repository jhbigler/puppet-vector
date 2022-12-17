#
class vector::service {
  service { $vector::service_name:
    ensure => $vector::service_ensure,
    enable => $vector::service_enabled,
  }
}
