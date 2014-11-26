require 'spec_helper'

describe Opener::Core::UnsupportedLanguageError do
  context '#initialize' do
    example 'set the language of the error' do
      described_class.new('en').language.should == 'en'
    end

    example 'set the message of the error' do
      error = described_class.new('en')

      error.message.should == 'The language "en" is not supported'
    end
  end
end
