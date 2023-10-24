# frozen_string_literal: true

require 'spec_helper'

describe 'vector::setup' do
    let(:pre_condition) { 'include vector' }

    #This class is easier, just ensure some directories are created
    context 'normal' do 
        it do
            [
                '/etc/vector',
                '/etc/vector/configs',
                '/etc/vector/configs/sinks',
                '/etc/vector/configs/sources',
                '/etc/vector/configs/transforms',
                '/var/lib/vector',
            ].each do |dir|
                is_expected.to contain_file(dir)
                    .with({'ensure' => 'directory'})
            end
        end
    end

end
