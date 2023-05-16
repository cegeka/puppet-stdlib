# frozen_string_literal: true

# THIS FILE WAS GENERATED BY `rake regenerate_unamespaced_shims`

# @summary DEPRECATED.  Use the namespaced function [`stdlib::powershell_escape`](#stdlibpowershell_escape) instead.
Puppet::Functions.create_function(:powershell_escape) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'powershell_escape', 'This function is deprecated, please use stdlib::powershell_escape instead.')
    call_function('stdlib::powershell_escape', *args)
  end
end
