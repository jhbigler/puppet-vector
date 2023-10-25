require 'spec_helper'

describe 'vector::sink' do 
    let(:pre_condition) { 'include vector' }
    let(:title) {'output'}

    context 'type=kafka' do 
        let(:params) { {'type' => 'kafka', 'inputs' => ['input-a'], 'parameters' => {},} }

        it do 
            is_expected.to contain_file('/etc/vector/configs/sinks/output.toml')
                .with({'mode' => '0644'})
                .with_content(/type *= *"kafka"/)
                .with_content(/inputs *= *\["input-a"\]/)
        end
    end

    context 'format=json, type=syslog' do 
        let(:params) { {'type' => 'syslog', 'inputs' => ['input-a'], 'parameters' => {'something' => 'else'}, 'format' => 'json'} }

        it do 
            is_expected.to contain_file('/etc/vector/configs/sinks/output.json')

            require 'json'
                
            json_data_str = catalogue
                .resource('file', '/etc/vector/configs/sinks/output.json')
                .send(:parameters)[:content]
            
            expect { JSON.parse(json_data_str) }.to_not raise_error

            json_data = JSON.parse json_data_str
            
            expect(json_data['something'] ).to eq 'else'
        end
    end
end