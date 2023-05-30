# frozen_string_literal: true

# THIS FILE WAS GENERATED BY `rake regenerate_unamespaced_shims`

# @summary DEPRECATED.  Use the namespaced function [`stdlib::os_version_gte`](#stdlibos_version_gte) instead.
Puppet::Functions.create_function(:os_version_gte) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'os_version_gte', 'This function is deprecated, please use stdlib::os_version_gte instead.')
    call_function('stdlib::os_version_gte', *args)
  end
end
