require 'spec_helper'

describe 'stdlib::shellvar', :type => :define do
  let(:title) { 'test' }

  context 'with path => \'test.properties\'' do
    let(:params) {
      {
        :path     => 'test.properties',
        :variable => 'bar'
      }
    }

    it {
      expect { subject }.to raise_error(
        Puppet::Error, /parameter path must be an absolute path/
      )
    }
  end

  context 'with ensure => installed' do
    let(:params) {
      {
        :path     => '/tmp/foo',
        :variable => 'bar',
        :ensure   => 'installed'
      }
    }

    it {
      expect { subject }.to raise_error(
        Puppet::Error, /parameter ensure must be present or absent/
      )
    }
  end

  context 'with ensure => absent' do
    let(:params) {
      {
        :path     => '/tmp/foo',
        :variable => 'bar',
        :ensure   => 'absent'
      }
    }

    it {
      should contain_augeas('test').with(
        {
          :lens    => 'Shellvars.lns',
          :incl    => '/tmp/foo',
          :context => '/files/tmp/foo',
          :onlyif  => 'match bar size > 0',
          :changes => [ 'rm bar' ]
        }
      )
    }
  end

  context 'without optional parameters' do
    let(:params) {
      {
        :path     => '/tmp/foo',
        :variable => 'bar',
      }
    }

    it {
      should contain_augeas('test').with(
        {
          :lens    => 'Shellvars.lns',
          :incl    => '/tmp/foo',
          :context => '/files/tmp/foo',
          :onlyif  => 'get bar != \'\'',
          :changes => [ 'set bar \'\'' ]
        }
      )
    }
  end

  context 'with value => \'baz\'' do
    let(:params) {
      {
        :path     => '/tmp/foo',
        :variable => 'bar',
        :value    => 'baz'
      }
    }

    it {
      should contain_augeas('test').with(
        {
          :lens    => 'Shellvars.lns',
          :incl    => '/tmp/foo',
          :context => '/files/tmp/foo',
          :onlyif  => 'get bar != \'baz\'',
          :changes => [ 'set bar \'baz\'' ]
        }
      )
    }
  end
end
