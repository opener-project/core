module Opener
  module Core
    module LanguageCode
      ##
      # Converts a language code to a valid Ruby constant name.
      #
      # @return [String]
      #
      def self.constant_name(code)
        return code.gsub(/\W+/, '_').upcase
      end
    end # LanguageCode
  end # Core
end # Opener
