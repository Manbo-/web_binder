require "fileutils"

require "faraday"
require "faraday_middleware"
require "nokogiri"
require "filename"

require "json"
require 'rexml/document'

require "web_binder/configure"
require "web_binder/downloading"
require "web_binder/scraping"
require "web_binder/version"

class WebBinder
  extend Configure::Setters
  extend Downloading
  extend Scraping

  class << self
    def inherited(subclass)
      subclass.instance_variable_set("@sources", [])
    end

    def configure
      yield Configure
    end

    private

    def get(name)
      instance_variable_get("@#{name}") || Configure.instance_variable_get("@#{name}")
    end
  end
end
