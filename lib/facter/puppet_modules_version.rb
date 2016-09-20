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

Facter.add(:puppet_modules_version_dev) do
  confine :kernel => "Linux"
  setcode do
    if Facter.value(:cfgtype) == 'puppetmaster'
      case Facter.value(:osfamily)
      when /RedHat/
       Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}" cegeka-puppet-modules-dev')
      end
    end
  end
end

Facter.add(:puppet_modules_version_acc) do
  confine :kernel => "Linux"
  setcode do
    if Facter.value(:cfgtype) == 'puppetmaster'
      case Facter.value(:osfamily)
      when /RedHat/
       Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}" cegeka-puppet-modules-acc')
      end
    end
  end
end

Facter.add(:puppet_modules_version_prd) do
  confine :kernel => "Linux"
  setcode do
    if Facter.value(:cfgtype) == 'puppetmaster'
      case Facter.value(:osfamily)
      when /RedHat/
       Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}" cegeka-puppet-modules-prd')
      end
    end
  end
end

Facter.add(:puppet_modules_version_drp) do
  confine :kernel => "Linux"
  setcode do
    if Facter.value(:cfgtype) == 'puppetmaster'
      case Facter.value(:osfamily)
      when /RedHat/
       Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}" cegeka-puppet-modules-drp')
      end
    end
  end
end
