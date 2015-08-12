#
# Cookbook Name:: kubernetes-mesos
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'kubernetes-mesos::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    before do
      stub_command("false").and_return(true)
    end
    
    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
