Facter.add("primary_network_interface") do
  setcode do
        Facter.value('interfaces').split(",")[0]
  end
end
