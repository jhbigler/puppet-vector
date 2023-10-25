include vector

vector::source { 'file':
  type       => 'file',
  parameters => {
    include => ['/var/log/**/*.log'],
  },
}

vector::sink { 'kafka':
  type       => 'kafka',
  inputs     => ['file'],
  parameters => {
    bootstrap_servers => '10.14.22.123:9092,10.14.23.332:9092',
    topic             => 'topic-1234',
    encoding          => {
      codec => 'json',
    },
  },
}
