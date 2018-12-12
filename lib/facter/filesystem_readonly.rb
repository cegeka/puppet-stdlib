# Fact: filesystem_readonly
#
# Purpose: Check if a filesystem is readonly or not

Facter.add(:filesystem_readonly) do
  confine :kernel => "Linux"
  setcode do
    case Facter.value(:osfamily)
    when /RedHat/
      ro_fs = Facter::Util::Resolution.exec("grep '\sro[\s,]' /proc/mounts |grep -Ev 'tmpfs|nfs'")
      if ro_fs.empty?
        ro_fs = false
      else
        ro_fs = true
      end
    end
    ro_fs
  end
end
