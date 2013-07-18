#!/usr/bin/env rspec

require 'spec_helper'

describe 'stdlib::stages' do
  it { should contain_class('stdlib::stages') }

  it { should contain_stage('setup_repo') }
  it { should contain_stage('setup')}

  it { should contain_stage('setup_repo').with_before('Stage[setup]') }
  it { should contain_stage('setup').with_before('Stage[main]') }
end
