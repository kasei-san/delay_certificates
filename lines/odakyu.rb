require 'open-uri'
require "selenium-webdriver"


class Odakyu

  BASE_URI = 'http://www.odakyu.jp/program/emg/'

  def initialize
    @driver = Selenium::WebDriver.for(:phantomjs)
  end

  def crawl
    URI.parse(BASE_URI).read.
      scan(%r|certificate\d+.html|).sort.uniq.
      each do |path|
        @driver.get(URI.join(BASE_URI, path))
        @driver.save_screenshot(File.join(tmpdir, path+'.png'))
      end
  end

  def tmpdir
    File.join(__dir__, '..', 'tmp')
  end
end

puts Odakyu.new.crawl.map(&:to_s).join("\n")
