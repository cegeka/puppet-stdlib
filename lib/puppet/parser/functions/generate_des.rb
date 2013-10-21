module Puppet::Parser::Functions
  newfunction(:generate_des, :type => :rvalue, :doc => <<-EOS
Converts a string to a salted-des password hash, given an optional salt.
EOS
  ) do |arguments|
    require 'securerandom'

    raise(Puppet::ParseError, "generate_des(): Wrong number of arguments " +
      "given (#{arguments.size} for 1 or 2)") if arguments.size < 1

    raise(Puppet::ParseError, "generate_des(): Wrong number of arguments " +
      "given (#{arguments.size} for 1 or 2)") if arguments.size > 2

    password = arguments[0]
    salt = arguments[1] || nil

    unless password.is_a?(String)
      raise(Puppet::ParseError, 'generate_des(): Requires a ' +
        "String argument, you passed: #{password.class}")
    end

    if salt.nil?
      return password.crypt(SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz'))
    else
      return password.crypt(salt)
    end
  end
end

# vim: set ts=2 sw=2 et :
