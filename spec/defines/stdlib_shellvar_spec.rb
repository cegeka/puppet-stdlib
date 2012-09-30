require 'spec_helper'

describe 'stdlib::shellvar', :type => :define do
  let(:title) { 'test' }

  context 'with file => \'conf/test.properties\'' do
    let(:params) {
      {
        :file => 'conf/test.properties',
        :key  => 'bar'
      }
    }

    it {
      expect { subject }.to raise_error(
        Puppet::Error, /parameter file must be an absolute path/
      )
    }
  end

  context 'with ensure => installed' do
    let(:params) {
      {
        :file   => '/tmp/foo',
        :key    => 'bar',
        :ensure => 'installed'
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
        :file   => '/tmp/foo',
        :key    => 'bar',
        :ensure => 'absent'
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
        :file  => '/tmp/foo',
        :key   => 'bar',
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
        :file  => '/tmp/foo',
        :key   => 'bar',
        :value => 'baz'
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
