require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'aws-sdk'
require './crawler'

s3 = Aws::S3::Resource.new
bucket = s3.bucket(ENV['BUCKET'])

Dir[File.expand_path('./crawler/*.rb')].each do |path|
  require path
  File.basename(path, '.rb').camelize.constantize.new.instance_eval do |crawler|
    puts "#{line_name}: crawling..."
    make_screen_shots

    puts "#{line_name}: create index.html..."
    make_html

    puts "#{line_name}: upload index.html..."
    File.open(File.join(tmpdir, 'index.html'), 'r') do |file|
      bucket.put_object(
        key: "#{line_name}/index.html",
        body: file,
        acl: 'public-read'
      )
    end

    filelist.each do |path|
      puts "#{line_name}: upload #{File.basename(path)}..."
      File.open(path, 'r') do |file|
        bucket.put_object(
          key: "#{line_name}/#{File.basename(path)}",
          body: file,
          acl: 'public-read'
        )
      end
    end
  end
end
