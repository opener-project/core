require_relative '../lib/opener/core/argv_splitter'

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
