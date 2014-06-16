require 'spec_helper'

describe Opener::Core::ResourceSwitcher::Installer do
  before do
    @installer = described_class.new(["--resource-path", "~/tmp"])
  end

  it "parse name out of url" do
    url = "http://foo.bar/some.model.tar.gz"

    @installer.get_filename_from_url(url).should eql("some.model.tar.gz")
  end

  it "parse name out of url and leave dir behind" do
    url = "http://foo.bar/some-folder/some.model.tar.gz"

    @installer.get_filename_from_url(url).should eql("some.model.tar.gz")
  end
end
