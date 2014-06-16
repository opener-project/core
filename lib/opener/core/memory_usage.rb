module Opener
  module Core
    ##
    # Class for returning the memory usage of the current process. This uses
    # the `/proc` filesystem if available and falls back to `ps`.
    #
    class MemoryUsage
      ##
      # Returns the RSS (aka total memory) in bytes.
      #
      # @return [Fixnum]
      #
      def usage
        return has_proc? ? rss_proc : rss_ps
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def has_proc?
        return File.exists?('/proc')
      end

      ##
      # Returns the RSS using the `/proc` filesystem.
      #
      # @return [Fixnum]
      #
      def rss_proc
        kb = File.read('/proc/self/status').match(/VmRSS:\s+(\d+)/)[1].to_i

        return kb * 1024
      end

      ##
      # Returns the RSS using the `ps` command.
      #
      # @return [Fixnum]
      #
      def rss_ps
        kb = `ps -o rss= #{Process.pid}`.strip.to_i

        return kb * 1024
      end
    end # MemoryUsage
  end # Core
end # Opener
