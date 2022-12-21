# Takes a hash and a format string and dumps it in that format
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
