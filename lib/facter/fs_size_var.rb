# Fact: fs_size_var
#
# Purpose: Returns the size of the var filesystem.

Facter.add(:fs_size_var) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
      Facter::Util::Resolution.exec("lsblk | grep var | awk '{print $4}'")
    end
  end
end
