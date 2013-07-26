#!/usr/bin/env ruby -S rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:packagelock).provider(:yum)

describe provider_class do
  before do
    provider.stubs(:command).with(:rpm).returns 'rpm'
    provider.stubs(:command).with(:yum).returns 'yum'
  end

  let(:resource) { Puppet::Type.type(:packagelock).new(:name => 'foo', :provider => provider_class) }
  let(:provider) { provider_class.new(:name => 'foo') }

  it "supports resource discovery" do
    provider_class.should respond_to(:instances)
  end

  it "supports resource prefetching" do
    provider_class.should respond_to(:prefetch)
  end

  it "is ensurable" do
    provider.feature?(:ensurable)
  end

  [:exists?, :create, :destroy].each do |method|
    it "has a(n) #{method} method" do
      provider.should respond_to(method)
    end
  end
end
