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
    Dir.glob(File.join(__dir__, 'tmp', line_name, "*#{SCREENSHOT_EXT}")).each do |path|
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

  def make_html
    File.open(File.join(tmpdir, 'index.html'), 'w') do |file|
      file.puts Slim::Template.new('crawl_result.slim').render(self)
    end
  end

  def upload_html
    File.open(File.join(tmpdir, 'index.html'), 'r') do |file|
      bucket.put_object(
        key: "#{line_name}/index.html",
        body: file,
        acl: 'public-read'
      )
    end
  end

  def bucketed_screenshots
    bucket.objects.map{ |obj| File.basename(obj.key) }.select{ |name| File.extname(name) == SCREENSHOT_EXT }.sort.reverse
  end

  def tmpdir
    File.join(__dir__, 'tmp', line_name)
  end

  def line_name
    self.class.to_s.underscore
  end
end
