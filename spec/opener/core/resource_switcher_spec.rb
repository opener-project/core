require 'spec_helper'

describe Opener::Core::ResourceSwitcher do
  before do
    @switcher = described_class.new
    @slop     = Slop.new { run { } }
  end

  context '#bind' do
    example 'overwrite the default run block' do
      @switcher.should_receive(:download_and_extract)

      @switcher.bind(@slop)

      @slop.parse(%w{--resource-path foo --resource-url bar})
    end
  end

  context '#download_and_extract' do
    example 'download and extract a file' do
      url  = 'http://foo/test.zip'
      path = '/foo'
      tmp  = '/foo/test.zip'

      # E_TOO_MANY_STUBS
      @switcher.should_receive(:create_directory)
        .with(path)

      @switcher.should_receive(:filename_from_url)
        .with(url)
        .and_return('test.zip')

      @switcher.should_receive(:download)
        .with(url, tmp)

      Archive.should_receive(:extract)
        .with(tmp, path)

      @switcher.should_receive(:remove_file)
        .with(tmp)

      @switcher.download_and_extract(url, path)
    end
  end

  context '#filename_from_url' do
    before do
      @url = 'http://foo/test.zip'
    end

    example 'raise if no Content-Disposition header is available' do
      @switcher.stub(:get_headers).and_return('Content-Type' => 'foo')

      -> { @switcher.filename_from_url(@url) }.should raise_error
    end

    example 'raise if no filename could be extracted' do
      @switcher.stub(:get_headers)
        .and_return('Content-Disposition' => 'attachment;')

      -> { @switcher.filename_from_url(@url) }.should raise_error
    end

    example 'return the filename' do
      @switcher.stub(:get_headers)
        .and_return('Content-Disposition' => 'attachment; filename=test.zip')

      @switcher.filename_from_url(@url).should == 'test.zip'
    end
  end
end
