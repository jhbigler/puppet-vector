# frozen_string_literal: true

require 'spec_helper'

describe 'vector::systemd_dropin' do
  let(:pre_condition) { 'include vector' }
  let(:title) { '10-resource-limits' }
  
  context 'with_content' do 
    content = <<~EOS
      [Service]
      LimitNOFILE=65536
      LimitNPROC=4096
      MemoryMax=2G
    EOS

    let(:params) do 
      { 
        'content'  => content,
      }
    end

    it do 
      is_expected.to contain_file('/etc/systemd/system/vector.service.d/10-resource-limits.conf')
        .with_content(content)
    end

  end

  context 'with_source' do
    source = 'puppet:///deployment/vector/systemd_dropins/10-resource-limits.conf'
    let(:params) do
      {
        'source'   => source,
      }
    end

    it do
      is_expected.to contain_file('/etc/systemd/system/vector.service.d/10-resource-limits.conf')
        .with_source(source)
    end
  end

  context 'manage_systemd_false' do

    let(:pre_condition) { 'class{"vector": manage_systemd => false }' }
    let(:params) do 
      {
        'source' => 'foo',
      }
    end

    it do
      is_expected.not_to contain_file('/etc/systemd/system/vector.service.d/10-resource-limits.conf')
    end
  end
end
