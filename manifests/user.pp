# vector::user
#
# @summary
#   Private class that manages the user and group vector runs as
class vector::user {
  assert_private()
  if $vector::manage_group {
    group { $vector::group:
      ensure => present,
      name   => $vector::group,
      *      => $vector::group_opts,
    }
  }
  if $vector::manage_user {
    user { $vector::user:
      ensure => present,
      name   => $vector::user,
      *      => $vector::user_opts,
    }
  }
}
