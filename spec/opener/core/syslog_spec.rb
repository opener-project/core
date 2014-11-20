require 'spec_helper'

describe Opener::Core::Syslog do
  before do
    described_class.stub(:enabled?).and_return(true)
  end

  context 'open' do
    example 'open a Syslog connection' do
      described_class.open('foobar')

      Syslog.ident.should == 'foobar'
    end
  end

  context 'info' do
    example 'log an info message' do
      Syslog.should_receive(:info).with('Testing')

      described_class.info('Testing')
    end

    example 'log an info message with metadata' do
      Syslog.should_receive(:info).with('number=10 Testing')

      described_class.info('Testing', :number => 10)
    end
  end

  context 'err' do
    example 'log an error message' do
      Syslog.should_receive(:err).with('Error!')

      described_class.err('Error!')
    end
  end

  context 'make_pairs' do
    example 'convert a Hash with a number into a key/value pair' do
      described_class.make_pairs(:number => 10).should == 'number=10'
    end

    example 'convert a Hash with a string into a key/value pair' do
      described_class.make_pairs(:name => 'Foo').should == 'name="Foo"'
    end
  end
end
