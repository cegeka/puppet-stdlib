# Digs into the facts hash using dot-notation
#
# Example usage:
#
#     fact('osfamily')
#     fact('os.architecture')
#
# Array indexing:
#
#     fact('mountpoints."/dev".options.1')
#
# Fact containing a "." in the name:
#
#     fact('vmware."VRA.version"')
#
Puppet::Functions.create_function(:fact) do
  dispatch :fact do
    param 'String', :fact_name
  end

  dispatch :alternative do
    param 'Hash',   :fact_hash
    param 'String', :fact_name
  end

  def fact(fact_name)
    dot_dig(closure_scope['facts'], fact_name)
  end

  def alternative(alternative_hash, fact_name)
    dot_dig(alternative_hash, fact_name)
  end

  def dot_dig(fact_hash, fact_name)
    # Transform the dot-notation string into an array of paths to walk. Make
    # sure to correctly extract double-quoted values containing dots as single
    # elements in the path.
    path = fact_name.scan(/([^."]+)|(?:")([^"]+)(?:")/).map {|x| x.compact.first }

    walked_path = []
    path.reduce(fact_hash) do |d, k|
      return nil if d.nil? || k.nil?

      case
      when d.is_a?(Array)
        begin
          result = d[Integer(k)]
        rescue ArgumentError => e
          Puppet.warning("fact request for #{fact_name} returning nil: '#{to_dot_syntax(walked_path)}' is an array; cannot index to '#{k}'")
          result = nil
        end
      when d.is_a?(Hash)
        result = d[k]
      else
        Puppet.warning("fact request for #{fact_name} returning nil: '#{to_dot_syntax(walked_path)}' is not a collection; cannot walk to '#{k}'")
        result = nil
      end

      walked_path << k
      result
    end
  end

  def to_dot_syntax(array_path)
    array_path.map do |string|
      string.include?('.') ? %Q{"#{string}"} : string
    end.join('.')
  end
end
