# frozen_string_literal: true

# THIS FILE WAS GENERATED BY `rake regenerate_unamespaced_shims`

# @summary DEPRECATED.  Use the namespaced function [`stdlib::validate_email_address`](#stdlibvalidate_email_address) instead.
Puppet::Functions.create_function(:validate_email_address) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'validate_email_address', 'This function is deprecated, please use stdlib::validate_email_address instead.')
    call_function('stdlib::validate_email_address', *args)
  end
end
