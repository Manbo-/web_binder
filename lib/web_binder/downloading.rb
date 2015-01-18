class WebBinder
  module Downloading
    DEFAULT_EACH_SLEEP_TIME = 5

    def download
      clear! if get(:clear_before_downloading)
      get(:sources).each.with_index(0) do |source, idx|
        open(save_path(source), "wb").write(connection.get(source).body)
        if idx < get(:sources).size
          sleep get(:each_sleep_time) || DEFAULT_EACH_SLEEP_TIME
        end
      end
    end

    def clear!
      FileUtils.rm_rf(get(:download_directory))
      @yet = false
    end

    private

    UNSAFE_FILENAME_CHARS = /<|>|:|"|\\|\||\?|\*/

    def connection
      return @connection if @connection
      @connection = Faraday.new do |builder|
        builder.use FaradayMiddleware::FollowRedirects
        builder.adapter :net_http
      end
      @connection.headers = { "User-Agent" => get(:user_agent) } if get(:user_agent)
      @connection
    end

    def save_directory(source)
      split = URI.split(source)
      File.join(get(:download_directory), split[2], split[5].gsub(UNSAFE_FILENAME_CHARS, "_"))
    end

    def save_filename(source)
      uri = URI.parse(source)
      basename = File.basename(source)
      basename = "index.html" if uri.host == basename
      basename += ".html" if basename !~ /\./
      basename.gsub(UNSAFE_FILENAME_CHARS, "_")
    end

    def save_path(source)
      _ = File.join(save_directory(source), save_filename(source))
      filename = FileName.new(_[0, 100], :add => :auto, :type => :time, :directory => :parent)
      filename.create
    end
  end
end
