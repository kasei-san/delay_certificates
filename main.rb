require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require './crawler'
Dir[File.expand_path('./crawler/*.rb')].each do |path|
  require path
  File.basename(path, '.rb').camelize.constantize.new.tap do |crawler|
    crawler.crawl
    crawler.make_html
  end
end
