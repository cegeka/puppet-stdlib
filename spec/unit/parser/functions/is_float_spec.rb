#!/usr/bin/env rspec
require 'spec_helper'

describe "the is_float function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("is_float").should == "function_is_float"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_is_float([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return true if a float" do
    result = @scope.function_is_float([0.12])
    result.should(eq(true))
  end

  it "should return false if a string" do
    result = @scope.function_is_float(["asdf"])
    result.should(eq(false))
  end

  it "should return false if not an integer" do
    result = @scope.function_is_float([3])
    result.should(eq(false))
  end

end
