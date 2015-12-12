require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'aws-sdk'
require "slack-notifier"
require './crawler'

s3 = Aws::S3::Resource.new
bucket = s3.bucket(ENV['BUCKET'])

Dir[File.expand_path('./crawler/*.rb')].each do |path|
  require path
  File.basename(path, '.rb').camelize.constantize.new(bucket).instance_eval do |crawler|
    puts "#{line_name}: make_screenshots..."
    make_screenshots

    puts "#{line_name}: upload_screenshots..."
    upload_screenshots

    puts "#{line_name}: create index.html..."
    make_html

    puts "#{line_name}: upload index.html..."
    upload_html
  end
end

if ENV['WEBHOOK_URL']
  Slack::Notifier.new(ENV['WEBHOOK_URL']).ping("遅延証明更新されたよー")
end
