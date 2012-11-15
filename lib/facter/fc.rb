fc_host = "/sys/class/fc_host"

if File.directory?(fc_host)
    adapters = []
    Dir[fc_host + "/host*"].each do |adapter|
        adapters.push(adapter[/host\d+/])

        Facter.add("wwpn_" + adapter[/host\d+/]) do
            confine :kernel => :linux
            setcode do
                file = File.new(adapter + "/port_name")
                wwpn = file.readlines[0].sub!(/0x/,"").upcase.scan(/.{2}/)
                wwpn.join(":")
            end
        end
    end

    Facter.add(:fc_interfaces) do
        confine :kernel => :linux
        setcode { adapters.sort.join(",") }
    end
end
