require 'rubygems'
require 'active_support'
require 'active_support/core_ext'

Dir[File.expand_path('./lines/**/*.rb')].each do |file|
  require file
end

Dir[File.expand_path('./lines/*/*.rb')].each do |path|
  File.basename(path, '.rb').camelize.constantize.new.crawl
end
