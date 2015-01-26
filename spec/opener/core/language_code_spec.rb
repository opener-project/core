require 'spec_helper'

describe Opener::Core::LanguageCode do
  context 'to_constant_name' do
    example 'return the constant name for language code "en"' do
      described_class.constant_name('en').should == 'EN'
    end

    example 'return the constant name for language code "nl"' do
      described_class.constant_name('nl').should == 'NL'
    end

    example 'return the constant name for language code "zh-cn"' do
      described_class.constant_name('zh-cn').should == 'ZH_CN'
    end

    example 'return the constant name for language code "zh_cn"' do
      described_class.constant_name('zh_cn').should == 'ZH_CN'
    end

    example 'return the constant name for language code "zh cn"' do
      described_class.constant_name('zh cn').should == 'ZH_CN'
    end
  end
end
