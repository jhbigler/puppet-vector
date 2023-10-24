require 'spec_helper'

describe 'vector::source' do 
    let(:pre_condition) { 'include vector' }
    let(:title) {'tcp'}

    context 'type=socket' do 
        let(:params) { {'type' => 'socket', 'parameters' => { 'mode' => 'tcp' },} }

        it do 
            is_expected.to contain_file('/etc/vector/configs/sources/tcp.toml')
                .with({'mode' => '0644'})
                .with_content(/type *= *"socket"/)
                .with_content(/mode *= *"tcp"/)
        end
    end
end