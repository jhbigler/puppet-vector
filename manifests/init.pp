type Vector::Ensure  = Variant[Enum['running','stopped'],Boolean]
type Vector::Enabled = Variant[Enum['manual','mask','delayed'],Boolean]
type Vector::ValidConfigFormat = Enum['json','yaml','yml','toml']
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
#   What user to run Vector as, default 'vector'. Note - this module does not yet create the user
# @param group
#   What group to run Vector as, default 'vector'
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
class vector (
  Optional[String]  $version,
  Boolean           $install_vector,
  String            $config_dir,
  String            $data_dir,
  String            $user,
  String            $group,
  String            $service_name,
  Boolean           $manage_systemd,
  String            $vector_executable,
  Vector::Ensure    $service_ensure,
  Vector::Enabled   $service_enabled,
  String            $environment_file,
  Hash              $global_options     = {},
  Hash              $environment_vars   = {},
  Hash              $config_files       = {},
  Hash              $sources            = {},
  Hash              $transforms         = {},
  Hash              $sinks              = {},
) {
  contain vector::install
  contain vector::setup
  contain vector::configure
  contain vector::service

  Class['vector::install']
  -> Class['vector::setup']
  -> Class['vector::configure']
  -> Class['vector::service']
}
