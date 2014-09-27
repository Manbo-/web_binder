require 'spec_helper'

describe WebBinder do
  before :all do
    FileUtils.rm_rf("spec/temp")
  end

  let(:binder) do
    Class.new(WebBinder) do
      sources "http://www.yahoo.co.jp/"
      download_directory "spec/temp"

      r = "http://www.yahoo.co.jp/"
      scrape :links do |doc|
        doc.search("//a").map{ |a| URI.join(r, a[:href]).to_s }
      end
    end
  end

  describe ".download" do
    it do
      VCR.use_cassette "yahoo" do
        expect{ binder.download }.to change{ File.exist?( "spec/temp/www.yahoo.co.jp/index.html" ) }
          .from(false).to(true)
      end
    end

    context "when specify user agent" do 
      let(:binder) do
        Class.new(WebBinder) do
          sources "http://www.yahoo.co.jp/"
          download_directory "spec/temp"
          user_agent "WebBinder"
          
          r = "http://www.yahoo.co.jp/"
          scrape :links do |doc|
            doc.search("//a").map{ |a| URI.join(r, a[:href]).to_s }
          end
        end
      end

      it do
        expect(binder.send(:connection).headers).to eq({ "User-Agent" => "WebBinder" })
      end
    end
  end

  describe ".scrape" do
    it do
      expect(binder.links).to be_a_kind_of Array
    end

    it do
      expect(binder.links).to be_all{ |link| link =~ URI.regexp }
    end
  end

  describe ".clear_before_downloading" do
    before do
      binder.configure do |config|
        config.clear_before_downloading
      end
    end

    it do
      expect(binder).to receive(:clear!)
      VCR.use_cassette "yahoo" do
        binder.download
      end
    end
  end

  describe ".download_before_scraping" do
    before do
      binder.configure do |config|
        config.download_before_scraping
      end
    end

    it do
      expect(binder).to receive(:download)
      VCR.use_cassette "yahoo" do
        binder.links
      end
    end
  end

  after :all do
    FileUtils.rm_rf("spec/temp")
  end
end
