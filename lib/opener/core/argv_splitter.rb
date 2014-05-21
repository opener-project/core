module Opener
  module Core
    class ArgvSplitter

      def self.split(args, char="--")
        if index = args.index(char)
          first = args[0..index-1]
          second = args[index+1..-1]
        else
          first = args
          second = []
        end

        [first,second]
      end
    end
  end
end

