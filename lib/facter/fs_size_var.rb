# Fact: fs_size_var
#
# Purpose: Returns the size of the var filesystem.

Facter.add(:fs_size_var) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
      Facter::Util::Resolution.exec("lsblk -o MOUNTPOINT,TYPE,SIZE | grep '/var' | awk '{print $3}' | uniq")
    end
  end
end
