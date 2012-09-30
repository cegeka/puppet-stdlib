# == Definition: stdlib::shellvar
#
# Manipulates shell variables in files (typically the contents
# of /etc/sysconfig/* or /etc/default/*).
#
# === Parameters:
#
# [*file*] The file containing the shell variables. This should
#          be an absolute path.
#          - Required: yes
#          - Type: String
#
# [*key*] The variable to manipulate.
#              - Required: yes
#              - Type: String
#
# [*value*] The value to be assigned to the key.
#           - Required: no
#           - Default: ''
#           - Type: String
#
# [*ensure*] The desired state for the key/value pair. A value of
#            absent removes the shell variable from the file, a
#            declaration of stdlib::shellvar without the optional
#            parameters creates an empty shell variable.
#            - Required: no
#            - Default: present
#            - Content: present | absent
#
# === Sample Usage:
#
# Adding an extra shell-type key/value pair:
#
#   stdlib::shellvar { 'Puppet agent log':
#     file  => '/etc/sysconfig/puppet',
#     key   => 'PUPPET_LOG',
#     value => '/var/log/puppet/puppet.log'
#   }
#
# Removing a shell-type key/value pair:
#
#   stdlib::shellvar { 'Remove grub forcelba':
#     file   => '/etc/sysconfig/grub',
#     key    => 'forcelba',
#     ensure => absent
#   }
#
# Clearing the value of a shell-type key/value pair:
#
#   stdlib::shellvar { 'Clear extra iptables modules':
#     file   => '/etc/sysconfig/iptables-config',
#     key    => 'IPTABLES_MODULES'
#   }
#
define stdlib::shellvar(
                          $file,
                          $key,
                          $value = '',
                          $ensure = present
                        ) {
  if $file !~ /^\/.*$/ {
    fail("Stdlib::Shellvar[${title}]: parameter file must be an absolute path")
  }

  case $ensure {
    present:
      {
        augeas { $title :
          lens    => 'Shellvars.lns',
          incl    => $file,
          context => "/files${file}",
          onlyif  => "get ${key} != '${value}'",
          changes => ["set ${key} '${value}'" ]
        }
      }
    absent:
      {
        augeas { $title :
          lens    => 'Shellvars.lns',
          incl    => $file,
          context => "/files${file}",
          onlyif  => "match ${key} size > 0",
          changes => [ "rm ${key}" ]
        }
      }
    default:
      {
        fail("Stdlib::Shellvar[${title}]: parameter ensure must be present or absent")
      }
  }
}
