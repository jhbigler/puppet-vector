class { 'vector':
  config_dir => '/opt/vector',
  user       => 'root',
  group      => 'root',
  sources    => {
    'file' => {
      'type'       => 'file',
      'parameters' => {
        'include' => ['/var/log/**/*.log'],
      },
    },
  },
  sinks      => {
    'output_file' => {
      'format'     => 'yml',
      'type'       => 'file',
      'inputs'     => ['*'],
      'parameters' => {
        'path'     => '/tmp/vector-%Y-%m-%d.log',
        'encoding' => {
          'codec' => 'json',
        },
      },
    },
  },
}
