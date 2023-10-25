require 'spec_helper'

describe 'vector::transform' do 
    let(:pre_condition) { 'include vector' }
    let(:title) {'modify'}

    context 'type=remap' do 
        let(:params) { {'type' => 'remap', 'inputs' => ['tcp_input'], 'parameters' => {},} }

        it do 
            is_expected.to contain_file('/etc/vector/configs/transforms/modify.toml')
                .with({'mode' => '0644'})
                .with_content(/type *= *"remap"/)
                .with_content(/inputs *= *\["tcp_input"\]/)
        end
    end
end