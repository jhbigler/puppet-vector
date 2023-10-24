require 'spec_helper'

describe 'vector::configfile' do 
    let(:pre_condition) { 'include vector' }
    let(:title) {'my_configs'}

    context 'with_content' do 
        content = <<~EOS
            {
                "sources" : {
                    "tcp": {
                        "type": "socket",
                        "mode": "tcp"
                    }
                },
                "sinks" : {
                    "es" : {
                        "type" : "elasticsearch",
                        "inputs": ["tcp"],
                        "endpoints": [ "http://10.24.32.122:9000" ]
                    }
                }
            }
        EOS
        let(:params) do
            {
                'content'   => content,
                'format' => 'json',
            }
        end
        it do 
            is_expected.to contain_file('/etc/vector/configs/my_configs.json')
                .with({'mode' => '0644'})
                .with_content(content)

        end
    end

    context 'with_data' do 
        data = {
            'sources' => {
                'tcp' => {
                    'type' => 'socket',
                    'mode' => 'tcp',
                }
            },
            'sinks' => {
                'es' => {
                    'type' => 'elasticsearch',
                    'inputs' => ['tcp'],
                }
            }
        }
        let(:params) do
            {
                'data'   => data,
                'format' => 'toml',
            }
        end

        it do 
            is_expected.to contain_file('/etc/vector/configs/my_configs.toml')
                .with_content(/type *= *"socket"/)
                .with_content(/type *= *"elasticsearch"/)
        end
    end
end