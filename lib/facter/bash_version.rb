# Fact: bash_version
#
# Purpose: Returns the version of the bash package currently installed on a node.

Facter.add(:bash_version) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
      if Facter.value(:architecture) == 'x86_64'
        Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}-%{RELEASE}" bash.x86_64')
      else
        Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}-%{RELEASE}" bash')
      end
    end
  end
end
