# Fact: glibc_version
#
# Purpose: Returns the version of the glibc package currently installed on a node.

Facter.add(:glibc_version) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
      if Facter.value(:architecture) == 'x86_64'
        Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}-%{RELEASE}" glibc.x86_64')
      else
        Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}-%{RELEASE}" glibc')
      end
    end
  end
end
