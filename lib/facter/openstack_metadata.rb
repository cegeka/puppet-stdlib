# A Puppet Facter plugin to create facts from the openstack metadata service
# It will only create facts from actual metadata tags provided to the machine.
#
# Copyright (c) 2017 Cegeka
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

require 'json'
require 'open-uri'

if system('grep -q FEA9FEA9 /proc/net/route')
  begin
    openstack_hash = JSON.parse(open("http://169.254.169.254/openstack/latest/meta_data.json").read)
    openstack_metadata = openstack_hash['meta']
    if openstack_metadata.is_a?(Hash)
    openstack_metadata.each do |key,value|
      Facter.add(key) do
        has_weight 100
        setcode do
          value
        end
      end
    end
  end
  rescue OpenURI::HTTPError
    puts "openstack-metadata url not accessible, metadata not loaded"
  end
end
