class { 'vector':
  data_dir => '/data/vector',
  sources  => {
    'logfiles' => {
      'type'       => 'file',
      'parameters' => {
        'include'   => ['/var/log/**/*.log'],
        'read_from' => 'beginning',
      },
    },
    'syslogs'  => {
      'type'       => 'syslog',
      'parameters' => {
        'mode'    => 'tcp',
        'address' => '0.0.0.0:514',
      },
    },
  },
  sinks    => {
    'elasticsearch' => {
      'type'       => 'elasticsearch',
      'inputs'     => ['logfiles', 'syslogs'],
      'parameters' => {
        'endpoints' => 'elastic1:9200',
      },
    },
  },
}
