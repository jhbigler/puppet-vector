# frozen_string_literal: true

require 'spec_helper'

describe 'vector' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

  context 'normal' do 
    it do
      #Ensure each sub class is contained
      ['install', 'user', 'setup', 'configure', 'service'].each do |step|
        is_expected.to contain_class("vector::#{step}")
      end
    end
  end
end
