# vector::transform
#
# @summary
#   Creates a Vector transform
#
# @param type
#   Transform type. Consult vector documentation for available types.
# @param inputs
#   Array of inputs (source or transform)
# @param parameters
#   Hash of additional parameters for this source (besides type and inputs)
# @param format
#   File format to save as, default toml
define vector::transform (
  String                    $type,
  Array[String]             $inputs,
  Hash                      $parameters,
  Vector::ValidConfigFormat $format = 'toml',
) {
  $transform_hash = {
    'transforms' => {
      $title => $parameters + { 'type' => $type, 'inputs' => $inputs },
    },
  }

  $transform_file_name = "${vector::setup::topology_files_dir}/transform_${title}.${format}"

  file { $transform_file_name:
    ensure  => file,
    content => vector::dump_config($transform_hash, $format),
    mode    => '0644',
    require => File[$vector::setup::topology_files_dir],
    notify  => Service[$vector::service_name],
  }
}
