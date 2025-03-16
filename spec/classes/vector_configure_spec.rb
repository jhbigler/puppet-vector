# frozen_string_literal: true

require 'spec_helper'

describe 'vector::configure' do
  let(:pre_condition) { 'include vector' }

  # Stuff that should exist by default
  context 'normal' do
    it do
      is_expected.to contain_file('/etc/vector/global.yaml')
        .with_ensure('file')
        .with_content(%r{data_dir *: *"?/var/lib/vector"?})

      is_expected.to contain_file('/etc/sysconfig/vector')
        .with_ensure('file')

      is_expected.to contain_file('/etc/systemd/system/vector.service')
        .with_ensure('file')
        .with_content(
              <<~EOS,
                    [Unit]
                    Description=Vector log and metric shipping
                    Documentation=https://vector.dev
                    After=network-online.target
                    Requires=network-online.target

                    [Service]
                    User=vector
                    Group=vector
                    ExecStartPre=/usr/bin/vector validate -C /etc/vector/configs /etc/vector/global.yaml
                    ExecStart=/usr/bin/vector -c /etc/vector/global.yaml -C /etc/vector/configs
                    ExecReload=/usr/bin/vector validate -C /etc/vector/configs /etc/vector/global.yaml
                    ExecReload=/bin/kill -HUP $MAINPID
                    Restart=always
                    AmbientCapabilities=CAP_NET_BIND_SERVICE
                    EnvironmentFile=-/etc/sysconfig/vector

                    [Install]
                    WantedBy=multi-user.target
                    EOS
            )

      is_expected.to contain_file('/etc/systemd/system/vector.service.d')
        .with_ensure('directory')
        .with_purge(true)
    end
  end

  context 'debian' do
    let(:facts) { { os: { 'family' => 'Debian' } } }
    let(:pre_condition) do
      <<~EOS
                class { 'vector':#{' '}
                    environment_vars => {
                        'HTTPS_PROXY' => 'http://my_proxy.com:3800'
                    }
                }
            EOS
    end

    it do
      is_expected.to contain_file('/etc/default/vector')
        .with_ensure('file')
        .with_content(%r{HTTPS_PROXY="?http://my_proxy.com:3800"?})
    end
  end

  context 'no manage systemd' do
    let(:pre_condition) do
      <<~EOS
                class { 'vector':
                    manage_systemd => false,
                }
            EOS
    end

    it do
      expect(catalogue.resource('file', '/etc/systemd/system/vector.service')).to be_nil
    end
  end

  context 'different_restart' do
    let(:pre_condition) do
      <<~EOS
        class {'vector':
          service_restart => 'on-failure',
        }
      EOS
    end

    it do
      is_expected.to contain_file('/etc/systemd/system/vector.service')
        .with_content(%r{^Restart=on-failure$})
    end
  end

  context 'provided resources' do 
    let(:pre_condition) do 
      <<~EOS
        class{ 'vector':
          systemd_dropins => {
            '01-resource-limits' => {
              'content' => 'foo'
            }
          },
          sources => {
            'logfiles' => {
              'type'       => 'file',
              'parameters' => {
                'include'   => ['/var/log/**/*.log'],
                'read_from' => 'beginning',
              },
            }
          },
          sinks => {
            'elasticsearch' => {
              'type'       => 'elasticsearch',
              'inputs'     => ['*'],
              'format'     => 'json',
              'parameters' => {
                'endpoints' => 'elastic1:9200',
                'pipeline'  => 'logs',
              },
            }
          } 
        }
      EOS
    end

    it do 
      is_expected.to contain_vector__systemd_dropin('01-resource-limits')
        .with_content('foo')
        .that_notifies('Service[vector]')
        .that_requires('File[/etc/systemd/system/vector.service.d]')
        
      is_expected.to contain_vector__source('logfiles')
        .with_type('file')
        .that_notifies('Service[vector]')

      is_expected.to contain_vector__sink('elasticsearch')
        .with_type('elasticsearch')
        .with_format('json')
        .that_notifies('Service[vector]')

      is_expected.to contain_file('/etc/systemd/system/vector.service.d/01-resource-limits.conf')
      is_expected.to contain_file('/etc/vector/configs/sources/logfiles.toml')
      is_expected.to contain_file('/etc/vector/configs/sinks/elasticsearch.json')
    end
  end

  # Want to test the notify_on_config_change boolean
  context 'no notify on change' do
    let(:pre_condition) do 
      <<~EOS
        class {'vector':
          notify_on_config_change => false,  
        }

        vector::source {'logs':
          type => 'file',
          parameters => {},
        }
      EOS
    end

    it do
      is_expected.to contain_file('/etc/vector/configs/sources/logs.toml')
        .with_notify(nil)
    end
  end
end
