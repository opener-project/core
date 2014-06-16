module Opener
  module Core
    class OptParser
      attr_accessor :option_parser, :options

      def initialize(&block)
        @options = {}
        @option_parser = construct_option_parser(options, &block)
      end

      def parse(args)
        process(:parse, args)
      end

      def parse!(args)
        process(:parse!, args)
      end

      def pre_parse!(args)
        delete_double_dash = false
        process(:parse!, args, delete_double_dash)
      end

      def pre_parse(args)
        delete_double_dash = false
        process(:parse, args, delete_double_dash)
      end

      def self.parse(args)
        new.parse(args)
      end

      def self.parse!(args)
        new.parse!(args)
      end

      def self.pre_parse!(args)
        new.pre_parse!(args)
      end

      def self.pre_parse(args)
        new.pre_parse(args)
      end

      private

      def process(call, args, delete_double_dash=true)
        args.delete("--") if delete_double_dash
        option_parser.send(call, args)
        return options
      end

      def construct_option_parser(options, &block)
        raise NotImplementedError
      end
    end

  end
end

