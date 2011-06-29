#!/usr/bin/env rspec
require 'spec_helper'

describe "the reverse function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("reverse").should == "function_reverse"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_reverse([]) }.should( raise_error(Puppet::ParseError))
  end

end
