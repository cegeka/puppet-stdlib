Puppet::Type.newtype(:packagelock) do

  desc <<-EOT
    Lock a package to the specific version installed. This resource
    type supplements the package resource type, to lock a package
    to the version that is installed with the corresponding package
    resource.

    **Autorequires:** If Puppet is managing the package with the same
    name as the packagelock name, the packagelock resource will
    autorequire the package.
  EOT

  ensurable do
    desc "What state the packagelock should be in."

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc "The name of the software package to lock."
  end

  autorequire(:package) do
    self[:name]
  end
end
