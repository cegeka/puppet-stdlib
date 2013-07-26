Puppet::Type.type(:packagelock).provide(:yum) do
  desc "YUM package locking support; uses the versionlock plugin.
    This plugin should be installed and enabled for this to work.
    RHEL5 and derivatives have a very sparse version of the plugin
    without the 'versionlock' subcommand, requiring us to edit
    the versionlock.list file directly."

  LOCKCONF = '/etc/yum/pluginconf.d/versionlock.conf'
  LOCKLIST = '/etc/yum/pluginconf.d/versionlock.list'

  commands :rpm => 'rpm'
  commands :yum => 'yum'

  confine :osfamily => :redhat

  confine :true => begin
    if File.exist?(LOCKCONF)
      File.readlines(LOCKCONF).find { |line| line =~ /^\s*enabled\s*=\s1/ }
    end
  end

  defaultfor :osfamily => :redhat

  def self.instances
    if (Facter[:operatingsystemrelease].value =~ /^5.*/)
      locklist = File.read(LOCKLIST).split("\n").reject do |line|
	line =~ /^\s*#.*/ or line =~ /^\s*$/
      end
    else
      begin
        locklist = yum('versionlock', '-q', 'list').split("\n")
      rescue Puppet::ExecutionFailure => e
        fail("YUM Versionlock is not enabled")
      end
    end

    locklist.collect do |lock|
      pkg = lock_to_pkg(lock)
      new(:name => pkg, :ensure => :present)
    end
  end

  def self.prefetch(resources)
    locks = instances
    resources.keys.each do |name|
      if provider = locks.find { |lock| lock.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    if (Facter[:operatingsystemrelease].value =~ /^5.*/)
      lock = rpm('-q', '--qf', '%|EPOCH?{%{EPOCH}}:{0}|:%{NAME}-%{VERSION}-%{RELEASE}.*\n', resource[:name])

      File.open(LOCKLIST, 'a') { |list| list.puts lock }
    else
      yum('versionlock', '-q', 'add', resource[:name])
    end

    @property_hash[:ensure] = :present
  end

  def destroy
    version = rpm('-q', '--qf', '%{VERSION}-%{RELEASE}', resource[:name])

    if (Facter[:operatingsystemrelease].value =~ /^5.*/)
      lines = File.readlines(LOCKLIST)

      File.open(LOCKLIST, 'w') do |file|
        lines.each { |line| file.puts(line) unless line =~ /^[0-9]+:#{resource[:name]}-#{version}\.\*$/ }
      end
    else
      yum('versionlock', '-q', 'delete', "*:#{resource[:name]}-#{version}.*")
    end

    @property_hash.clear
  end

  private

  def self.lock_to_pkg(lock)
    l = lock.chomp.gsub(/^[0-9]+:(.*)\.\*$/, '\1')
    rpm('-q', '--qf', '%{NAME}', l)
  end
end
