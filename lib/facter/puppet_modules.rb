require 'json'

Facter.add('puppet_modules') do
  confine :osfamily => 'RedHat'
  setcode do
    modules = Array.[]
    fqdn = Facter.value(:fqdn)
    catalog_file = '/var/lib/puppet/client_data/catalog/' + fqdn + '.json'

    if File.file?(catalog_file)
      catalog = JSON.parse( IO.read(catalog_file) )
      catalog_classes = catalog['data']['classes']

      catalog_classes.each do |catalog_class|
        module_name = /^([a-z]+)(?:){2}/.match(catalog_class)
        modules.push(module_name[0])
      end
    else
      modules.push('no_modules')
    end
    modules.uniq.sort
  end
end
