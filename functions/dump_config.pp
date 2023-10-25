# vector::dump_config
#
# @param data
#   A puppet hash representing the configuration of some vector entity (source, transform, sink, etc)
# @param format
#   What format to dump the $data parameter as (json, toml, yaml, yml)
#
# @return
#   A String representing the dumped configuration
function vector::dump_config(
  Hash $data,
  Vector::ValidConfigFormat $format = 'toml',
) >> String {
  case $format {
    /ya?ml/ : { to_yaml($data) }
    'toml'  : { to_toml($data) }
    default : { to_json($data) }
  }
}
