module Opener
  module Core
    ##
    # Class for measuring and adding benchmarking information to KAF documents.
    #
    # Basic usage is as following:
    #
    #     benchmark = Opener::Core::Benchmark.new('opener-property-tagger')
    #     document  = nil
    #     results   = benchmark.measure do
    #       document = some_stuff_that_emits_kaf
    #     end
    #
    #     # Add the data to the document. This method returns the new XML as a
    #     # String.
    #     xml = benchmark.write(document, results)
    #
    # ## Metrics
    #
    # The following metrics are gathered:
    #
    # * Starting memory usage
    # * End memory usage
    # * Memory increase (if any)
    # * CPU system time
    # * CPU user time
    # * Real time
    # * Total time
    #
    # @!attribute [r] name
    #  @return [String]
    #
    # @!attribute [r] results
    #  @return [Hash]
    #
    class Benchmark
      attr_reader :name

      ##
      # @param [String] name The name of the benchmark.
      #
      def initialize(name)
        @name = name
      end

      ##
      # Measures the block and returns the results as a Hash.
      #
      # @example
      #  measure do
      #    sleep(5)
      #  end
      #
      # @return [Hash]
      #
      def measure
        mem_usage = MemoryUsage.new
        mem_start = mem_usage.usage
        timings   = ::Benchmark.measure do
          yield
        end

        mem_end = mem_usage.usage

        return {
          :memory_start    => mem_start,
          :memory_end      => mem_end,
          :memory_increase => mem_end - mem_start,
          :time_cpu_system => timings.stime,
          :time_cpu_user   => timings.utime,
          :time_real       => timings.real,
          :time_total      => timings.total
        }
      end

      ##
      # Writes benchmarking results to the specified document.
      #
      # @param [String] xml The XML document.
      # @param [Hash] results The benchmarking results to write.
      # @return [String]
      #
      def write(xml, results)
        document   = Nokogiri::XML(xml)
        root       = document.at('KAF')
        benchmarks = root.at('benchmarks')

        unless benchmarks
          benchmarks = Nokogiri::XML::Node.new('benchmarks', document)

          root.add_child(benchmarks)
        end

        benchmark = create_benchmark_node(document)

        results.each do |name, val|
          benchmark.add_child(create_node(name, val, document))
        end

        benchmarks.add_child(benchmark)

        return document.to_xml(
          :indent   => 2,
          :encoding => document.encoding || 'UTF-8'
        )
      end

      private

      ##
      # @param [Nokogiri::XML::Document] document
      # @return [Nokogiri::XML::Node]
      #
      def create_benchmark_node(document)
        node = Nokogiri::XML::Node.new('benchmark', document)

        node.set_attribute('name', name)

        return node
      end

      ##
      # @param [String|Symbol] name
      # @param [Mixed] text
      # @param [Nokogiri::XML::Document] document
      # @return [Nokogiri::XML::Node]
      #
      def create_node(name, text, document)
        node = Nokogiri::XML::Node.new(name.to_s, document)

        node.inner_html = text.to_s

        return node
      end
    end # Benchmark
  end # Core
end # Opener
