# Fact: openssl_version
#
# Purpose: Returns the version of the OpenSSL package currently installed on a node.

Facter.add(:openssl_version) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
      if Facter.value(:architecture) == 'x86_64'
        Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}-%{RELEASE}" openssl.x86_64')
      else
        Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}-%{RELEASE}" openssl')
      end
    end
  end
end
