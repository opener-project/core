module Opener
  module Core
    ##
    # Error class that can be used by components whenever they encounter an
    # unsupported language.
    #
    # @!attribute [r] language
    #  @return [String]
    #
    class UnsupportedLanguageError < StandardError
      attr_reader :language

      ##
      # @param [String] language
      #
      def initialize(language)
        @language = language

        super("The language #{language.inspect} is not supported")
      end
    end # UnsupportedLanguageError
  end # Core
end # Opener
