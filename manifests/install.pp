# vector::summary
#
# @summary
#   Installs vector, if configured to do so
class vector::install {
  assert_private()
  if $vector::install_vector {
    $ensure_version = $vector::version ? {
      String  => $vector::version,
      default => 'present',
    };

    package { 'vector':
      ensure => $ensure_version,
    }
  }
}
