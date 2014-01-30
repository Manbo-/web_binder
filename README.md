# WebBinder

## Installation

## Usage
```ruby
requrie "web_binder"

class YahooNews < WebBinder
  sources "http://www.yahoo.co.jp/news"
  download_directory ""

  clear_before_downloading
  download_before_scraping

  scrape :links do |doc|
    doc.search("//a").map do |a|
      { a.inner_text => URI.join("http://www.yahoo.co.jp/news", a[:href]).to_s }
    end
  end
end

YahooNews.links
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
