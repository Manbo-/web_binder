class WebBinder
  class Configure
    module Setters
      def sources(*sources)
        @sources += sources 
      end

      def user_agent(user_agent)
        @user_agent = user_agent
      end

      def download_directory(download_directory)
        @download_directory = download_directory
      end

      def clear_before_downloading(boolean = true)
        @clear_before_downloading = !!boolean
      end

      def download_before_scraping(boolean = true)
        @download_before_scraping = !!boolean
      end

      def each_sleep_time(sec)
        @each_sleep_time = sec
      end
    end

    extend Setters
  end
end

