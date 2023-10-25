include vector

$content = @(END)
  [sources.tcp]
  type = "socket"
  address = "0.0.0.0:9000"
  mode = "tcp"

  [transforms.parse]
  type = "remap"
  inputs = ["tcp"]
  source = '''
    stuff = del(.)
    .message = stuff.message
    .timestamp = stuff.timestamp
    syslog, err_syslog = parse_syslog(.message)
    if err_syslog != null {
      json, err_json = parse_json(.message)
      if err_json == null {
        .json = json
      }
    } else {
      .syslog = syslog
    }
  '''

  [sinks.output]
  type = "console"
  inputs = ["parse"]
  target = "stdout"

    [sinks.output.encoding]
    codec = "json"
  | END

vector::configfile { 'vector1':
  content => $content,
  format  => 'toml',
}

vector::sink { 'file':
  type       => file,
  inputs     => ['tcp'],
  parameters => {
    path => '/tmp/test.ndjson',
  },
}
