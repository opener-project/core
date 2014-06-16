require 'spec_helper'

describe Opener::Core::ArgvSplitter do
  example "empty" do
    described_class.split([]).should eql([[],[]])
  end

  example "no dash" do
    described_class.split(["-foo","-bar"]).should eql([["-foo","-bar"],[]])
  end

  example "dash" do
    described_class.split(["foo","--","bar"]).should eql([["foo"],["bar"]])
  end
end
