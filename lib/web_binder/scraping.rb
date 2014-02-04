class WebBinder
  module Scraping
    def scrape(name, &code)
      define_singleton_method name do |*args|
        download if get(:download_before_scraping) and yet?
        docs.map do |doc|
          code.call(Nokogiri::HTML(doc), *args)
        end.flatten
      end
    end

    def json
      download if get(:download_before_scraping) and yet?
      docs.map do |doc|
        JSON.parse(doc)
      end
    end

    def xml
      download if get(:download_before_scraping) and yet?
      docs.map do |doc|
        REXML::Document.new(doc)
      end
    end

    private

    def yet?
      return false if @yet
      @yet = true
    end

    def glob_path(source)
      File.join(save_directory(source), "*")
    end

    def docs
      pathes.map do |filename|
        File.read(filename)
      end
    end

    def pathes
      get(:sources).map{ |source| Dir.glob(glob_path(source)) }.flatten
    end
  end
end
