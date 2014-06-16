require 'spec_helper'

describe Opener::Core::Benchmark do
  before do
    @instance = described_class.new('rspec')
  end

  context '#measure' do
    before do
      @result = @instance.measure { 'Hello world' }
    end

    example 'include the starting memory amount' do
      @result[:memory_start].should > 0
    end

    example 'include the end memory amount' do
      @result[:memory_end].should > 0
    end

    # No guarantee this actually *will* be greater than 0, so lets just test if
    # it's there.
    example 'include the memory usage' do
      @result[:memory_increase].is_a?(Fixnum).should == true
    end

    example 'include the CPU system time' do
      @result[:time_cpu_system].is_a?(Float).should == true
    end

    example 'include the CPU user time' do
      @result[:time_cpu_user].is_a?(Float).should == true
    end

    example 'include the real time' do
      @result[:time_real].is_a?(Float).should == true
    end

    example 'include the total time' do
      @result[:time_total].is_a?(Float).should == true
    end
  end

  context '#write' do
    before do
      input     = '<KAF></KAF>'
      @result   = @instance.measure { 'Hello world' }
      @document = Nokogiri::XML(@instance.write(input, @result))
      @node     = @document.at('benchmarks benchmark')
    end

    example 'include a single <benchmarks> element' do
      @document.css('benchmarks').length.should == 1
    end

    example "don't add a <benchmarks> node if it's already present" do
      input    = @document.to_xml
      output   = @instance.write(input, @result)
      document = Nokogiri::XML(output)

      document.css('KAF benchmarks').length.should == 1
    end

    example 'include the benchmark node' do
      @document.css('benchmarks benchmark').length.should == 1
    end

    example 'set the name of the benchmark node' do
      @node.attr('name').should == 'rspec'
    end

    example 'include the starting memory usage' do
      @node.at('memory_start').text.to_i.should == @result[:memory_start]
    end

    example 'include the end memory usage' do
      @node.at('memory_end').text.to_i.should == @result[:memory_end]
    end

    example 'include the memory increase' do
      @node.at('memory_increase').text.to_i.should == @result[:memory_increase]
    end

    example 'include the CPU system time' do
      @node.at('time_cpu_system').text.to_f.should == @result[:time_cpu_system]
    end

    example 'include the CPU user time' do
      @node.at('time_cpu_user').text.to_f.should == @result[:time_cpu_user]
    end

    example 'include the real time' do
      @node.at('time_real').text.to_f.should == @result[:time_real]
    end

    example 'include the total time' do
      @node.at('time_total').text.to_f.should == @result[:time_total]
    end
  end
end
