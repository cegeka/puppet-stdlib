#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the is_absolute_path function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("is_absolute_path").should == "function_is_absolute_path"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_is_absolute_path([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return true when an absolute path is passed" do
    result = scope.function_is_absolute_path(["/tmp/foo"])
    result.should(eq(true))
  end

  it "should return false when a relative path is passed" do
    result = scope.function_is_absolute_path(["tmp/foo"])
    result.should(eq(false))
  end

  it "should return false when an integer is passed" do
    result = scope.function_is_absolute_path(["3"])
    result.should(eq(false))
  end

  it "should return false when an array is passed" do
    result = scope.function_is_absolute_path([["a","b","c"]])
    result.should(eq(false))
  end

  it "should return false when a hash is passed" do
    result = scope.function_is_absolute_path([{:a=>"b",:c=>"d"}])
    result.should(eq(false))
  end

  it "should return false when a boolean is passed" do
    result = scope.function_is_absolute_path([true])
    result.should(eq(false))
  end
end
