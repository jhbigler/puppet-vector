# frozen_string_literal: true

require 'spec_helper'

describe 'vector::install' do
    let(:pre_condition) { 'include vector' }

    #Test that we install vector by default
    context 'normal' do 
        it do
            is_expected.to contain_package('vector')
                .with({'ensure' => 'present'})
        end
    end

    #Test that we can set the vector verion
    context 'specific vector version' do
        let(:pre_condition) do
            <<-EOS
                class {'vector':
                    version => '1.0.0',
                }
            EOS
        end

        it do
            is_expected.to contain_package('vector')
                .with({'ensure' => '1.0.0'})
        end
    end

    #Test that no 'vector' package present when install_vector is false
    context 'no install vector' do
        let(:pre_condition) do 
            <<-EOS
                class {'vector':
                    install_vector => false,
                }
            EOS
        end

        it { expect(catalogue.resource('package', 'vector')).to be_nil }

    end
end
