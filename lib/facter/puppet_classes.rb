require 'json'

Facter.add('puppet_classes') do
  confine :osfamily => 'RedHat'
  setcode do
    classes = Array.[]
    fqdn = Facter.value(:fqdn)
    catalog_file = '/var/lib/puppet/client_data/catalog/' + fqdn + '.json'

    if File.file?(catalog_file)
      catalog = JSON.parse( IO.read(catalog_file) )
      catalog_classes = catalog['data']['classes']

      catalog_classes.each do |catalog_class|
        classes.push(catalog_class)
      end
    else
      classes.push('no_classes')
    end
    classes.uniq.sort
  end
end
