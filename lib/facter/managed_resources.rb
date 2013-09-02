# Fact: managed_resources
#
# Purpose: Return the number of resources managed by Puppet.
#
# The resources managed by Puppet are listed in a file in the
# Puppet statedir. The file can be configured by the $resourcefile
# setting, and defaults to /var/lib/puppet/state/resources.txt.
#
# This file is available since commit 7a39ca7, solving issue #8667,
# which is included in version 2.7.4.

version = Facter.value(:puppetversion).split('.').map { |v| v.to_i }

if version[0] >= 3 or (version[0] == 2 and version[1] == 7 and version[2] >= 4)
  Facter.add(:managed_resources) do
    setcode do
      require 'puppet'

      begin
        resourcefile = Puppet.settings[:resourcefile]
      rescue Puppet::Settings::InterpolationError
        Puppet.initialize_settings
        retry
      end

      if File.exist?(resourcefile)
        File.read(resourcefile).each.inject(0) { |n, _| n + 1 }
      end
    end
  end
end
