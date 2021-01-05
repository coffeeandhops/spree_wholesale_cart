module SpreeWholesaleCart
  module_function

  # Returns the version of the currently loaded SpreeWholesaleCart as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new Version::STRING
  end

  module Version
    MAJOR = 0
    MINOR = 0
    TINY  = 1
    PRE   = 'alpha'.freeze

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
