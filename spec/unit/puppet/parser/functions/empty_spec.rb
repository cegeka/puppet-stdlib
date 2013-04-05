#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe "the empty function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("empty").should == "function_empty"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_empty([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return true when an empty string is passed" do
    result = scope.function_empty([''])
    result.should(eq(true))
  end

  it "should return false when a non-empty string is passed" do
    result = scope.function_empty(['bla'])
    result.should(eq(false))
  end
end
