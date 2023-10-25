# vector::configure
#
# @summary
#   Creates configuraton files, and creates systemd files if configured to do so
class vector::configure {
  assert_private()
  $global_opts_file   = "${vector::config_dir}/global.yaml"

  file { $global_opts_file:
    ensure  => file,
    mode    => '0664',
    content => to_yaml($vector::global_options + { 'data_dir' => $vector::data_dir }),
    notify  => Class['vector::service'],
  }

  create_resources(vector::configfile, $vector::config_files)
  create_resources(vector::source,     $vector::sources)
  create_resources(vector::transform,  $vector::transforms)
  create_resources(vector::sink,       $vector::sinks)

  file { $vector::environment_file:
    ensure  => file,
    content => epp('vector/vector_env.epp'),
    notify  => Class['vector::service'],
  }

  if $vector::manage_systemd {
    $systemd_service_file = "/etc/systemd/system/${vector::service_name}.service"

    file { $systemd_service_file:
      ensure  => file,
      content => epp('vector/vector.service.epp'),
      notify  => Class['vector::service'],
    }
  }
}
