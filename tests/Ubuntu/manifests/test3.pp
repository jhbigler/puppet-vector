class { 'vector':
  manage_user => true,
  version     => '0.30.0',
}

vector::configfile { 'config':
  data   => {
    sources => {
      'file' => {
        'type'       => 'file',
        'parameters' => {
          'include' => ['/var/log/**/*.log'],
        },
      },
    },
    sinks   => {
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
  },
}
