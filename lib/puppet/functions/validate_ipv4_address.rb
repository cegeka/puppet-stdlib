Puppet::Functions.create_function(:validate_ipv4_address, Puppet::Functions::InternalFunction) do
  dispatch :deprecation_gen do
    scope_param
    optional_repeated_param 'Any', :args
  end
  def deprecation_gen(scope, *args)
    call_function('deprecation', 'validate_ipv4_address', "This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Ipv4_Address. There is further documentation for validate_legacy function in the README.")
    scope.send("function_validate_ipv4_address", args)
  end
end
