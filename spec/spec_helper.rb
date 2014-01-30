$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'web_binder'

require 'pry'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end

