module Opener
  module Core
    ##
    # Class for downloading and extracting external resources such as
    # models/lexicons.
    #
    # Resource paths specified using the `--resource-path` option are stored in
    # the environment variable `RESOURCE_PATH`. This variable should be used in
    # webservice/daemon code instead of said code re-parsing CLI arguments.
    #
    # @!attribute [r] http
    #  @return [HTTPClient]
    #
    class ResourceSwitcher
      attr_reader :http

      def initialize
        @http = HTTPClient.new
      end

      ##
      # Adds extra CLI options to the given Slop instance.
      #
      # @param [Slop] slop
      #
      def bind(slop)
        slop.separator "\nResource Options:\n"

        slop.on :'resource-url=',
          'URL pointing to a .zip/.tar.gz file to download',
          :as => String

        slop.on :'resource-path=',
          'Path where the resources should be saved',
          :as => String

        # Hijack Slop's run block so we can inject our own code before it.  This
        # is quite grotesque, but sadly the only way.
        old_runner = slop.instance_variable_get(:@runner)

        slop.run do |opts, args|
          if opts[:'resource-path'] and opts[:'resource-url']
            download_and_extract(opts[:'resource-url'], opts[:'resource-path'])
          end

          # Allow daemons/webservices to use the path without having to re-parse
          # CLI options.
          ENV['RESOURCE_PATH'] = opts[:'resource-path']

          old_runner.call(opts, args)
        end
      end

      ##
      # @param [String] url
      # @param [String] path
      #
      def download_and_extract(url, path)
        filename  = filename_from_url(url)
        temp_path = File.join(path, filename)

        create_directory(path)

        download(url, temp_path)

        Archive.extract(temp_path, path)

        remove_file(temp_path)
      end

      ##
      # Downloads the given file.
      #
      # @param [String] url
      # @param [String] path
      #
      def download(url, path)
        File.open(path, 'w', :encoding => Encoding::BINARY) do |handle|
          http.get(url) do |chunk|
            handle.write(chunk)
          end
        end
      end

      ##
      # Returns the filename of the file located at `url`.
      #
      # @param [String] url
      # @return [String]
      #
      def filename_from_url(url)
        headers = get_headers(url)

        unless headers['Content-Disposition']
          raise "The URL #{url.inspect} did not return a Content-Disposition " \
            "header. This header is required to figure out the filename"
        end

        matches = headers['Content-Disposition'].match(/filename=(.+)/)

        if !matches or !matches[1]
          raise 'No filename could be found in the Content-Disposition header'
        end

        return matches[1]
      end

      ##
      # Creates the path. This method mainly exists to make testing a bit
      # easier.
      #
      # @param [String] path
      #
      def create_directory(path)
        FileUtils.mkdir_p(path)
      end

      ##
      # Removes the given file, mainly exists to make testing easier.
      #
      # @param [String] path
      #
      def remove_file(path)
        File.unlink(path)
      end

      ##
      # @param [String] url
      # @return [Hash]
      #
      def get_headers(url)
        return http.head(url).headers
      end
    end # ResourceSwitcher
  end # Core
end # Opener
