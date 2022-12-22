# vector::source
#
# @summary
#   Creates a Vector source
#
# @param type
#   Source type. Consult vector documentation for available types.
# @param parameters
#   Hash of additional parameters for this source (besides type)
# @param format
#   File format to save as, default toml
define vector::source (
  String                    $type,
  Hash                      $parameters,
  Vector::ValidConfigFormat $format = 'toml',
) {
  $source_hash = {
    'sources' => {
      $title => $parameters + { 'type' => $type },
    },
  }

  $source_file_name = "${vector::setup::topology_files_dir}/source_${title}.${format}"

  file { $source_file_name:
    ensure  => file,
    content => vector::dump_config($source_hash, $format),
    mode    => '0644',
    require => File[$vector::setup::topology_files_dir],
    notify  => Service[$vector::service_name],
  }
}
