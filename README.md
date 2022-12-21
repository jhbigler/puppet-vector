# vector

This puppet module installs, configures, and runs the [Vector](https://vector.dev/) observability tool. 

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with vector](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with vector](#beginning-with-vector)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The vector module installs, configures, and runs the Vector observability tool. This module is designed for Redhat and Fedora type systems, and also assumes it uses systemd for managing services.

## Setup

### Setup Requirements

This module requires puppet-stdlib.

### Beginning with vector

This module will not configure yum or apt repositories, those should be configured outside of this module.

## Usage

There are two ways to configure topologies:
1. Using class parameters
    - These can be set with Hiera!
1. Using defined types:
    - Especially useful if your modules need to inject their own vector components
    - ```vector::source``` to configure a vector source
    - ```vector::transform``` to configure a vector transform
    - ```vector::sink``` to configure a vector sink
    - ```vector::configfile``` to configure a set of sources, transforms, and sinks

You can even use a mix of both of these strategies.

### Examples

Using ```vector::configfile```

```puppet
require 'vector'

vector::configfile { 'vector':
  data => {
    'sources' => {
        'logfiles' => {
            'type' => 'file',
            'include' => ['/var/log/**/*.log'],
        },
    },
    'sinks' => {
        'kafka' => {
            'type' => 'kafka',
            'inputs' => ['logfiles'],
            'bootstrap_servers' => 'localhost:9092',
            'encoding' => {
                'codec' => 'json',
            },
            'topic' => 'logs',
        },
    }
  },
}
```

Using ```vector::source```, ```vector::transform```, and ```vector::sink```

```puppet
require 'vector'

vector::source { 'logfile_input':
    type       => 'file',
    parameters => {
        'include' => ['/var/log/**/*.log'],
    },
}

vector::transform { 'logfile_transform':
    type       => 'remap',
    inputs     => ['*'],
    parameters => {
        'source' => '.foo = "bar"',
    },
}

vector::sink { 'logfile_kafka':
    type       => 'kafka',
    inputs     => ['logfile_transform'],
    parameters => {
        'bootstrap_servers' => 'localhost:9092',
        'topic'             => 'logs',
        'encoding'          => {
            'codec' => 'json',
        },
    }
}
```

Using class parameters

```puppet
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
```

Using Hiera

```yaml
vector::data_dir: '/data/vector'
vector::sources:
  logfiles:
    type: file
    parameters:
      include: ['/var/log/**/*.log']
      read_from: beginning
  syslogs:
    type: syslog
    parameters:
      mode: tcp
      address: '0.0.0.0:514'
vector::sinks:
  elasticsearch:
    type: elasticsearch
    inputs: ['logfiles','syslogs']
    parameters:
      endpoints: 'elastic1:9200
```

## Reference

See REFERENCE.md

