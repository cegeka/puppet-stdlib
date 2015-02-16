# Fact: fs_type_var
#
# Purpose: Returns the type of the var filesystem.

Facter.add(:fs_type_var) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
      Facter::Util::Resolution.exec("lsblk | grep var | awk '{print $6}'")
    end
  end
end
