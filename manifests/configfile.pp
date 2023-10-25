# vector::configfile
#
# @summary
#   A type to create a vector config file, composing of sources, transforms, and sinks
#
# @param format
#   File format, either yaml, yml, json, toml.
# @param content
#   File content, if specified, format must be specified and this string will be saved directly to disk
# @param data
#   Hash to be converted to specified format (or toml if format is not specified)
define vector::configfile (
  Optional[Vector::ValidConfigFormat] $format  = undef,
  Optional[String]                    $content = undef,
  Optional[Hash]                      $data    = undef,
) {
  if $content == undef and $data == undef {
    fail('Either content or data should be given')
  }

  if $format {
    $file_format = $format
  } elsif $data {
    $file_format = 'toml'
  } else {
    fail('Unable to guess the format to use')
  }

  $file_name = "${title}.${file_format}"

  $config_file_name = "${vector::setup::topology_files_dir}/${file_name}"

  $file_content = $content ? {
    undef => vector::dump_config($data, $file_format),
    default => $content,
  }

  file { $config_file_name:
    ensure  => file,
    content => $file_content,
    mode    => '0644',
    require => File[$vector::setup::topology_files_dir],
    notify  => Class['vector::service'],
  }
}
