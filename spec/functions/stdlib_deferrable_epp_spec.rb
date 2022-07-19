require 'spec_helper'

describe 'stdlib::deferrable_epp' do
  context 'call epp on non-deferred input' do
    let(:pre_condition) do
      'function epp($str, $data) { return "rendered"}'
    end

    it {
      is_expected.to run.with_params('mymod/template.epp', { 'foo' => 'bar' }).and_return('rendered')
    }
  end

  context 'defers rendering with deferred input' do
    let(:pre_condition) do
      <<~END
        function epp($str, $data) { fail("should not have invoked epp()") }
        function find_template($str) { return "path" }
        function file($path) { return "foo: <%= foo %>" }
      END
    end

    it {
      foo = Puppet::Pops::Types::TypeFactory.deferred.create('join', [1, 2, 3])
      is_expected.to run.with_params('mymod/template.epp', { 'foo' => foo }) # .and_return(a_kind_of Puppet::Pops::Evaluator::DeferredValue)
    }
  end
end
