require "selenium-webdriver"

class Crawler
  class ParseError < StandardError; end

  def initialize
    @driver = Selenium::WebDriver.for(:phantomjs)
    FileUtils.mkdir_p(tmpdir)
  end

  def tmpdir
    File.join(__dir__, '..', 'tmp', self.class.to_s.underscore)
  end
end
