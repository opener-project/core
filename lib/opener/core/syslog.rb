module Opener
  module Core
    ##
    # Wrapper around `Syslog` that makes it easier to disable loggers and to log
    # custom key/value pairs in message.
    #
    module Syslog
      ##
      # Returns `true` if Syslog should be enabled.
      #
      # @return [TrueClass|FalseClass]
      #
      def self.enabled?
        return !!ENV['ENABLE_SYSLOG']
      end

      ##
      # Configures Syslog.
      #
      # @see [Syslog.open]
      # @param [String] name The name of the program.
      # @param [Fixnum] facility
      #
      def self.open(name, facility = nil)
        ::Syslog.open(name, facility) if enabled?
      end

      # methods defined using define_method() are slower than those defined
      # using eval() on JRuby and Rubinius.
      [:debug, :err, :fatal, :info, :warn, :unknown].each do |method|
        eval <<-EOF, nil, __FILE__, __LINE__ + 1
        def self.#{method}(message, meta = {})
          add(:#{method}, message, meta)
        end
        EOF
      end

      ##
      # Adds a new log message.
      #
      # @example
      #  add(:info, 'Testing Syslog', :user_id => 19)
      #
      # @param [Symbol] type The type of log message to add, corresponds to the
      #  logger method that will be called.
      #
      # @param [String] message The message to log.
      # @param [Hash] meta Extra meta data to log.
      #
      def self.add(type, message, meta = {})
        return unless enabled?

        pairs = make_pairs(meta)

        ::Syslog.send(type, "#{pairs} #{message}".strip)
      end

      ##
      # @param [Hash] meta
      # @return [String]
      #
      def self.make_pairs(meta)
        return meta.map { |(key, value)| "#{key}=#{value.inspect}" }.join(' ')
      end
    end # Syslog
  end # Core
end # Opener
