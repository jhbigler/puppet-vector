# vector::sink
#
# @summary
#   Creates a vector sink
#
# @param type
#   Sink type. Consult vector documentation for available types
# @param inputs
#   Array of inputs (sources or transforms)
# @param parameters
#   Hash of additional parameters for the sink (besides type and inputs)
# @param format
#   File format to save as, default toml
define vector::sink (
  String                    $type,
  Array[String]             $inputs,
  Hash                      $parameters,
  Vector::ValidConfigFormat $format    = 'toml',
) {
  require vector::setup

  $sink_hash = $parameters + { 'type' => $type, 'inputs' => $inputs }

  $sink_file_name = "${vector::setup::sinks_dir}/${title}.${format}"

  file { $sink_file_name:
    ensure  => file,
    content => vector::dump_config($sink_hash, $format),
    mode    => '0644',
  }
}
