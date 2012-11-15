factsource = "/etc/facts"

if File.exist?(factsource)
    File.readlines(factsource).each do |line|
        if line =~ /^([^#].+)=(.+)$/
            var = $1; val = $2

            Facter.add(var[/(\S+)/]) do
                setcode { val[/(\S+)/] }
            end
        end
    end
end

