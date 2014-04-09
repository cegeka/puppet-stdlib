# Fact: openssl_version
#
# Purpose: Returns the version of the OpenSSL package currently installed on a node.

Facter.add(:openssl_version) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
     Facter::Util::Resolution.exec('rpm -q --queryformat "%{VERSION}" openssl')
    end
  end
end
