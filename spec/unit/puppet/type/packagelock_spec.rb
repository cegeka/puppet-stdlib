#!/usr/bin/env ruby -S rspec

require 'spec_helper'

packagelock = Puppet::Type.type(:packagelock)

describe packagelock do
  before do
    @class = packagelock
  end

  it "has a 'name' parameter" do
    @class.attrtype(:name).should == :param
  end

  it "has documentation" do
    @class.doc.should_not be_empty
  end

  it "has the 'name' attribute as its namevar" do
    @class.key_attributes.should == [:name]
  end

  it "has documentation for the 'name' attribute" do
    @class.paramdoc(:name).should_not be_empty
  end

  it "has an 'ensure' property" do
    @class.attrtype(:ensure).should == :property
  end

  context "" do
    before do
      @pkg_foo = Puppet::Type.type(:package).new(:name => 'foo', :ensure => :present)
      @catalog = Puppet::Resource::Catalog.new
      @catalog.add_resource @pkg_foo

      @lock_foo = Puppet::Type.type(:packagelock).new(:name => 'foo', :ensure => :present)
      @catalog.add_resource @lock_foo

      @req = @lock_foo.autorequire
    end

    it "has an autorequire relationship" do
      @req.size.should == 1
    end

    it "with a package resource as source" do
      @req[0].source.eql? @pkg_foo
    end

    it "and the packagelock resource as target" do
      @req[0].target.eql? @lock_foo
    end
  end

  context "when validating attributes" do
    it "supports 'present' as a value to 'ensure'" do
      @class.new(:name => "bla", :ensure => :present)
    end

    it "supports 'absent' as a value to 'ensure'" do
      @class.new(:name => "bla", :ensure => :absent)
    end
  end
end
