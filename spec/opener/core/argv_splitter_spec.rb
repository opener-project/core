require 'spec_helper'

describe Opener::Core::ArgvSplitter do
  let(:s) { Opener::Core::ArgvSplitter }

  example "empty" do
    s.split([]).should eql([[],[]])
  end

  example "no dash" do
    s.split(["-foo","-bar"]).should eql([["-foo","-bar"],[]])
  end

  example "dash" do
    s.split(["foo","--","bar"]).should eql([["foo"],["bar"]])
  end

end
