require 'spec_helper'

describe 'vector::dump_config' do
    context '' do
        it do
            is_expected.to run.with_params({'test' => 2}, 'json')
        end 
    end
end