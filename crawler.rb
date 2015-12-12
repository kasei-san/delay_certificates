require "selenium-webdriver"
require "slim"

class Crawler

  SCREENSHOT_EXT = '.png'

  attr_reader :bucket
  class ParseError < StandardError; end

  def initialize(bucket)
    @bucket = bucket
    @driver = Selenium::WebDriver.for(:phantomjs)
    FileUtils.mkdir_p(tmpdir)
  end

  def make_screenshots
    crawl.each do |(filename, uri)|
      puts filename
      @driver.get(uri.to_s)
      @driver.save_screenshot(File.join(tmpdir, "#{filename}#{SCREENSHOT_EXT}"))

      sleep(1)
    end
  end

  def upload_screenshots
    Dir.glob(File.join(tmpdir, "*#{SCREENSHOT_EXT}")).map{ |path| File.basename(path) }.each do |name|
      puts "#{line_name}: upload #{name}..."
      upload_s3(File.basename(name))
    end
  end

  def make_html
    File.open(File.join(tmpdir, 'index.html'), 'w') do |file|
      file.puts Slim::Template.new('crawl_result.slim').render(self)
    end
  end

  def upload_html
    upload_s3('index.html')
  end

  def bucketed_screenshots
    bucket.objects
      .map{ |obj| File.basename(obj.key) }
      .select{ |name| File.extname(name) == SCREENSHOT_EXT }.sort.reverse
  end

  def line_name
    self.class.to_s.underscore
  end

  private
  def upload_s3(name)
    File.open(File.join(tmpdir, name), 'r') do |file|
      bucket.put_object(
        key: "#{line_name}/#{name}",
        body: file,
        acl: 'public-read'
      )
    end
  end

  def tmpdir
    File.join(__dir__, 'tmp', line_name)
  end
end
