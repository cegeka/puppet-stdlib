#
# Returns information of the baseboard management controller (BMC) for physical machines.
#
# Facts:
#
# bmc_ipaddress
# Purpose: Returns the BMC Ip Address
#
# bmc_subnetmask
# Purpose: Returns the BMC Subnet Mask
#
# bmc_macaddress
# Purpose: Returns the BMC MAC Address
#
# bmc_defaultgateway
# Purpose: Returns the BMC Default Gateway IP
#

Facter.add("bmc_ipaddress", :timeout => 2) do
  confine :is_virtual => :false
  setcode do
    ipaddress
  end
end

Facter.add("bmc_subnetmask", :timeout => 2) do
  confine :is_virtual => :false
  setcode do
   subnetmask
  end
end

Facter.add("bmc_macaddress", :timeout => 2) do
  confine :is_virtual => :false
  setcode do
    macaddress
  end
end

Facter.add("bmc_defaultgateway", :timeout => 2) do
  confine :is_virtual => :false
  setcode do
   defaultgateway
  end
end

def lanconfig
    @lanconfig ||= parse_laninfo
end

def parse_laninfo
  if ipmitool.empty?
    return {}
  end
  landata = `#{ipmitool} lan print 2>/dev/null`
  laninfo = {}

  landata.lines.each do |line|
    item = line.split(':', 2)
    key = item.first.strip.downcase
    value = item.last.strip
    laninfo[key] = value
  end
  return laninfo
end

def ipmitool
  @ipmitool ||= `which ipmitool 2>/dev/null`.chomp
end

def ipaddress
  lanconfig["ip address"]
end

def macaddress
  lanconfig["mac address"]
end

def subnetmask
  lanconfig["subnet mask"]
end

def defaultgateway
  lanconfig["default gateway ip"]
end

