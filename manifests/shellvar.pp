# == Definition: stdlib::shellvar
#
# Manipulates shell variables in files (typically the contents
# of /etc/sysconfig/* or /etc/default/*).
#
# === Parameters:
#
# [*path*] The path of the file containing the shell variables.
#          This must be an absolute path.
#          - Required: yes
#          - Type: String
#
# [*variable*] The variable to manipulate.
#              - Required: yes
#              - Type: String
#
# [*value*] The value to be assigned to the variable.
#           - Required: no
#           - Default: ''
#           - Type: String
#
# [*ensure*] The desired state for the variable/value pair. A value
#            of absent removes the shell variable from the file, a
#            declaration of stdlib::shellvar without the optional
#            parameters creates an empty shell variable.
#            - Required: no
#            - Default: present
#            - Content: present | absent
#
# === Sample Usage:
#
# Adding an extra shell-type variable/value pair:
#
#   stdlib::shellvar { 'Puppet agent log':
#     path     => '/etc/sysconfig/puppet',
#     variable => 'PUPPET_LOG',
#     value    => '/var/log/puppet/puppet.log'
#   }
#
# Removing a shell-type variable/value pair:
#
#   stdlib::shellvar { 'Remove grub forcelba':
#     path     => '/etc/sysconfig/grub',
#     variable => 'forcelba',
#     ensure   => absent
#   }
#
# Clearing the value of a shell-type variable/value pair:
#
#   stdlib::shellvar { 'Clear extra iptables modules':
#     path     => '/etc/sysconfig/iptables-config',
#     variable => 'IPTABLES_MODULES'
#   }
#
define stdlib::shellvar(
                          $path,
                          $variable,
                          $value = '',
                          $ensure = present
                        ) {
  if $path !~ /^\/.*$/ {
    fail("Stdlib::Shellvar[${title}]: parameter path must be an absolute path")
  }

  case $ensure {
    present:
      {
        augeas { $title :
          lens    => 'Shellvars.lns',
          incl    => $path,
          context => "/files${path}",
          onlyif  => "get ${variable} != '${value}'",
          changes => ["set ${variable} '${value}'" ]
        }
      }
    absent:
      {
        augeas { $title :
          lens    => 'Shellvars.lns',
          incl    => $path,
          context => "/files${path}",
          onlyif  => "match ${variable} size > 0",
          changes => [ "rm ${variable}" ]
        }
      }
    default:
      {
        fail("Stdlib::Shellvar[${title}]: parameter ensure must be present or absent")
      }
  }
}
