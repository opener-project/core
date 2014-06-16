require 'spec_helper'

describe Opener::Core::ResourceSwitcher::Installer do
  let(:i) { Opener::Core::ResourceSwitcher::Installer.new(["--resource-path","~/tmp"]) }

  it "parse name out of url" do
    url = "http://foo.bar/some.model.tar.gz"
    i.get_filename_from_url(url).should eql("some.model.tar.gz")
  end

  it "parse name out of url and leave dir behind" do
    url = "http://foo.bar/some-folder/some.model.tar.gz"
    i.get_filename_from_url(url).should eql("some.model.tar.gz")
  end

end
