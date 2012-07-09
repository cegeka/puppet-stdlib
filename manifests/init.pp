# Class: stdlib
#
# This module manages stdlib
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class stdlib {

  @file { '/usr/local/scripts':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

}
