#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the is_string function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("is_string").should == "function_is_string"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_is_string([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return true when a string is passed" do
    result = scope.function_is_string(["bla"])
    result.should(eq(true))
  end

  it "should return false when an integer is passed" do
    result = scope.function_is_string(["7"])
    result.should(eq(false))
  end

  it "should return false when a float is passed" do
    result = scope.function_is_string(["3.14"])
    result.should(eq(false))
  end

  it "should return false when an array is passed" do
    result = scope.function_is_string([["a","b","c"]])
    result.should(eq(false))
  end

  it "should return false when a hash is passed" do
    result = scope.function_is_string([{:a=>"b",:c=>"d"}])
    result.should(eq(false))
  end

  it "should return false when a boolean is passed" do
    result = scope.function_is_string([true])
    result.should(eq(false))
  end
end
