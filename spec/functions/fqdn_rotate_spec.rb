# frozen_string_literal: true

require 'spec_helper'

describe 'fqdn_rotate' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects at least 1 argument, got none}) }
  it { is_expected.to run.with_params(0).and_raise_error(ArgumentError, %r{parameter 'input' expects a value of type String or Array, got Integer}) }
  it { is_expected.to run.with_params({}).and_raise_error(ArgumentError, %r{parameter 'input' expects a value of type String or Array, got Hash}) }
  it { is_expected.to run.with_params('').and_return('') }
  it { is_expected.to run.with_params('a').and_return('a') }
  it { is_expected.to run.with_params('ã').and_return('ã') }

  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(['a']).and_return(['a']) }

  it 'rotates a string and the result should be the same size' do
    expect(fqdn_rotate('asdf').size).to eq(4)
  end

  it 'rotates a string to give the same results for one host' do
    val1 = fqdn_rotate('abcdefg', host: 'one')
    val2 = fqdn_rotate('abcdefg', host: 'one')
    expect(val1).to eq(val2)
  end

  it 'allows extra arguments to control the random rotation on a single host' do
    val1 = fqdn_rotate('abcdefg', extra_identifier: [1, 'different', 'host'])
    val2 = fqdn_rotate('abcdefg', extra_identifier: [2, 'different', 'host'])
    expect(val1).not_to eq(val2)
  end

  it 'considers the same host and same extra arguments to have the same random rotation' do
    val1 = fqdn_rotate('abcdefg', extra_identifier: [1, 'same', 'host'])
    val2 = fqdn_rotate('abcdefg', extra_identifier: [1, 'same', 'host'])
    expect(val1).to eq(val2)
  end

  it 'rotates a string to give different values on different hosts' do
    val1 = fqdn_rotate('abcdefg', host: 'one')
    val2 = fqdn_rotate('abcdefg', host: 'two')
    expect(val1).not_to eq(val2)
  end

  it 'accepts objects which extend String' do
    result = fqdn_rotate(AlsoString.new('asdf'))
    expect(result).to eq('dfas')
  end

  it 'uses the Puppet::Util.deterministic_rand function' do
    expect(Puppet::Util).to receive(:deterministic_rand).with(44_489_829_212_339_698_569_024_999_901_561_968_770, 4)
    fqdn_rotate('asdf')
  end

  it 'does not leave the global seed in a deterministic state' do
    fqdn_rotate('asdf')
    rand1 = rand
    fqdn_rotate('asdf')
    rand2 = rand
    expect(rand1).not_to eql(rand2)
  end

  def fqdn_rotate(value, args = {})
    host = args[:host] || '127.0.0.1'
    extra = args[:extra_identifier] || []

    # workaround not being able to use let(:facts) because some tests need
    # multiple different hostnames in one context
    allow(subject.func.closure_scope).to receive(:[]).with('facts').and_return({ 'networking' => { 'fqdn' => host } })

    function_args = [value] + extra
    scope.call_function('fqdn_rotate', function_args)
  end
end
