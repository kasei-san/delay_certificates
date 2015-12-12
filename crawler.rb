require "selenium-webdriver"
require "slim"

class Crawler
  class ParseError < StandardError; end

  def initialize
    @driver = Selenium::WebDriver.for(:phantomjs)
    FileUtils.mkdir_p(tmpdir)
  end

  def make_html
    File.open(File.join(tmpdir, 'index.html'), 'w') do |file|
      file.puts Slim::Template.new('crawl_result.slim').render(self)
    end
  end

  def tmpdir
    File.join(__dir__, 'tmp', line_name)
  end

  def filelist
    Dir.glob(File.join(__dir__, 'tmp', line_name, '*.png'))
  end

  def line_name
    self.class.to_s.underscore
  end
end
