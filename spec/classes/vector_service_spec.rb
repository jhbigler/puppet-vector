# frozen_string_literal: true

require 'spec_helper'

describe 'vector::service' do
    let(:pre_condition) { 'include vector' }

    #Ensure vector service defined with default
    context 'normal' do 
        it do
            is_expected.to contain_service('vector')
                .with({'ensure' => true, 'enable' => true})
        end
    end

    #Ensure that the ensure and enable flags can be overridden
    context 'overrides' do 
        let(:pre_condition) do 
            <<-EOS
                class {'vector':
                    service_ensure  => false,
                    service_enabled => false,
                    service_name    => 'vector',
                }
            EOS
        end
        it do 
            is_expected.to contain_service('vector')
                .with({'ensure' => false, 'enable' => false})
        end
    end

end
