# Fact: puppet_modules_version
#
# Purpose: Returns the version of the package cegeka-puppet-modules currently installed on a puppetmaster.

Facter.add(:puppet_modules_version) do
  confine :kernel => "Linux"
  setcode do
    if Facter.value(:cfgtype) == 'puppetmaster'
      case Facter.value(:osfamily)
      when /RedHat/
       Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}" cegeka-puppet-modules')
      end
    end
  end
end
