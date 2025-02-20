#
# vector
#
# @summary 
#   Vector module for Puppet
#
# Installs, configures, then runs the Vector log and metric tool on RedHat and Debian type systems
# Note - this does not manage the repositories, it is assumed they are already configured
#
# @example
#   include vector
# @example
#   class vector {
#     data_dir => '/data/vector',
#     install_vector => false,
#   }
#
# @param version
#   What version of Vector to install. If left undef, will use default from repositories
# @param install_vector
#   Whether to have this module install Vector. Using this means the version param is ignored
# @param config_dir
#   Base directory for configuration, default /etc/vector
# @param data_dir
#   Directory for vector to store buffer and state data
# @param user
#   What user to run Vector as, default 'vector'
# @param group
#   What group to run Vector as, default 'vector'
# @param manage_user
#   Boolean to determine if puppet should manage the user vector runs as
# @param user_opts
#   Dictionary of options to pass into the user resource, other than 'name' (specified with vector::user) and 'ensure'
# @param manage_group
#   Boolean to determine if puppet should manage the group vector runs as
# @param group_opts
#   Dictionary of options to pass into the group resource, other than 'name' (specified with vector::group) and 'ensure'
# @param service_name
#   Name of the service, default 'vector'
# @param manage_systemd
#   Whether this module should manage the systemd unit file, default true
# @param vector_executable
#   Path to vector executable file
# @param service_ensure
#   Used in the 'service' resource for vector, default true
# @param service_enabled
#   Used in the 'service' resource for vector, default true
# @param service_restart
#   Used in the generated systemd unit file, default always
# @param environment_file
#   Location of the environment file for Vector
# @param global_options
#   Hash of global options for vector, besides data_dir (specifying data_dir here will be ignored)
# @param environment_vars
#   Hash of environment variables to make available to vector
# @param config_files
#   Hash of vector::configfile instances to create
# @param sources
#   Hash of vector::source instances to create
# @param transforms
#   Hash of vector::transform instances to create
# @param sinks
#   Hash of vector::sink instances to create
# @param systemd_dropins
#   Hash of vector::systemd_dropin instances to create
class vector (
  Optional[String]  $version,
  Boolean           $install_vector,
  String            $config_dir,
  String            $data_dir,
  String            $user,
  String            $group,
  Boolean           $manage_user,
  Hash              $user_opts,
  Boolean           $manage_group,
  Hash              $group_opts,
  String            $service_name,
  Boolean           $manage_systemd,
  String            $vector_executable,
  Vector::Ensure    $service_ensure,
  Vector::Enabled   $service_enabled,
  String            $environment_file,
  String            $service_restart    = 'always',
  Hash              $global_options     = {},
  Hash              $environment_vars   = {},
  Hash              $config_files       = {},
  Hash              $sources            = {},
  Hash              $transforms         = {},
  Hash              $sinks              = {},
  Hash              $systemd_dropins    = {},
) {
  contain vector::install
  contain vector::user
  contain vector::setup
  contain vector::configure
  contain vector::service

  Class['vector::install']
  -> Class['vector::user']
  -> Class['vector::setup']
  -> Class['vector::configure']
  -> Class['vector::service']
}
