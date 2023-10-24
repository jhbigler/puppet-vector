# frozen_string_literal: true

require 'spec_helper'

describe 'vector::user' do
    let(:pre_condition) { 'include vector' }

    #Test that we do not manage vector user/group by default
    context 'normal' do 
        it do
            expect(catalogue.resource('user', 'vector')).to be_nil
            expect(catalogue.resource('group', 'vector')).to be_nil
        end
    end

    #Test that we can create vector user and group
    context 'enable user and group management' do
        let(:pre_condition) do
            <<-EOS
                class {'vector':
                    manage_user => true,
                    manage_group => true,
                }
            EOS
        end

        it do
            is_expected.to contain_user('vector')
                .with({ 'system' => true, 'shell' => '/sbin/nologin' })

            is_expected.to contain_group('vector')
                .with({})
            
        end
    end

    #Test that vector user and group opts are enforced
    context 'user and group opts' do
        let(:pre_condition) do 
            <<-EOS
                class {'vector':
                    manage_user => true,
                    manage_group => true,
                    user_opts => {
                        system => false,
                        shell  => '/bin/bash',
                    },
                    group_opts => {
                        gid => 200,
                    },
                }
            EOS
        end

        it do
            is_expected.to contain_user('vector')
                .with({ 'system' => false, 'shell' => '/bin/bash' })

            is_expected.to contain_group('vector')
                .with({'gid' => 200})
            
        end

    end
end
