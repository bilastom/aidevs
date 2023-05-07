require 'active_support/all'

# This class could be used to optimize the number of API tokens
# by removing diacritic characters from a given string.
class FilterAccents
  class << self
    def for(content)
      ActiveSupport::Inflector.transliterate(content)
    end
  end
end
