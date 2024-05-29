# frozen_string_literal: true

require 'spec_helper'

describe 'vector::configure' do
    let(:pre_condition) { 'include vector' }

    #Stuff that should exist by default
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
                    <<~EOS
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
                    Restart=no
                    AmbientCapabilities=CAP_NET_BIND_SERVICE
                    EnvironmentFile=-/etc/sysconfig/vector
                    
                    [Install]
                    WantedBy=multi-user.target
                    EOS
                )
        end
    end

    context "debian" do
        let(:facts) { {:os => {'family' => 'Debian'}} }
        let(:pre_condition) do
            <<~EOS
                class { 'vector': 
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

end
