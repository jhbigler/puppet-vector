# vector::setup
#
# @summary
#   sets up some directories for configurations to go into
class vector::setup {
  assert_private()
  $topology_files_dir = "${vector::config_dir}/configs"
  $sources_dir        = "${topology_files_dir}/sources"
  $transforms_dir     = "${topology_files_dir}/transforms"
  $sinks_dir          = "${topology_files_dir}/sinks"

  file { $vector::data_dir:
    ensure => directory,
    owner  => $vector::user,
    mode   => $vector::data_dir_mode,
  }

  file { $vector::config_dir:
    ensure => directory,
    mode   => $vector::config_dir_mode,
  }
  -> file { $topology_files_dir:
    ensure  => directory,
    mode    => $vector::config_dir_mode,
    recurse => true,
    purge   => true,
    notify  => Class['vector::service'],
  }
  -> file { [$sources_dir, $transforms_dir, $sinks_dir]:
    ensure  => directory,
    mode    => $vector::config_dir_mode,
    recurse => true,
    purge   => true,
    notify  => Class['vector::service'],
  }

  File[$sources_dir, $transforms_dir, $sinks_dir] -> Vector::Source<||> ~> Class['vector::service']
  File[$sources_dir, $transforms_dir, $sinks_dir] -> Vector::Sink<||> ~> Class['vector::service']
  File[$sources_dir, $transforms_dir, $sinks_dir] -> Vector::Transform<||> ~> Class['vector::service']
}
