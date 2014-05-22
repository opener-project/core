require 'tempfile'
require 'uri'
require_relative 'opt_parser'

module Opener
  module Core
    class ResourceSwitcher

      def bind(opts, options)
        OptParser.bind(opts,options)
      end

      def install(options, force=true)
        Installer.new(options).install(force)
      end

      class Installer
        attr_reader :options

        def initialize(options={})
          @options = options
        end

        def install(force=true)
          return if !options[:resource_path] && !options[:resource_url]

          path = options[:resource_path]
          if options[:resource_url] && path.nil? && force
            raise ArgumentError, "No resource-path given"
          end

          if url = options[:resource_url]
            download_and_unzip_resource(url,path)
          end
        end

        def download_and_unzip_resource(url, path)
          filename = download(url, path)
          unzip(filename, path)
        end

        def download(url, path)
          filename = get_filename_from_url(url)
          destination = File.expand_path(filename, path)
          `wget -N -P #{path} #{url}`

          return destination
        end

        def unzip(file, path)
          extname = File.extname(file)
          if extname == ".zip"
            puts `unzip #{file} -o -d #{path}`
          else
            puts `tar -zxvf #{file} --directory #{path}`
          end
        end

        def get_filename_from_url(url)
          URI.parse(url).path[1..-1].split("/").last
        end
      end

      class OptParser < Opener::Core::OptParser
        attr_accessor :option_parser, :options

        def self.bind(opts, options)
          opts.on("--resource-path PATH", "Path where the resources are located. In combination with the --resource-url option this is also the path where the resources will be installed") do |v|
            options[:resource_path] = v
          end

          opts.on("--resource-url URL", "URL where a zip file containing all resources can be downloaded") do |v|
            options[:resource_url] = v
          end
        end
        private

        def construct_option_parser(options, &block)
          OptionParser.new do |opts|
            self.class.bind(opts, options)
          end
        end
      end
    end
  end
end
