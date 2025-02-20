# @summary A systemd dropin file for Vector
#
# This defined type allows you to define any artibrary systemd dropin for vector
# User can use either a file source or supply the content directly
#
# @example
#   vector::systemd_dropin { '10-resource-limits': source => 'puppet:///deployment/vector/resource-limits.conf' }
# @param source
#   File source for this dropin config
# @param content
#   File content of this dropin config
define vector::systemd_dropin (
  Optional[String] $source   = undef,
  Optional[String] $content  = undef,
) {
  if $vector::manage_systemd {
    file { "${vector::configure::systemd_dropin_dir}/${title}.conf":
      ensure  => file,
      source  => $source,
      content => $content,
    }
  }
}
