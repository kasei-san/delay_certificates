require 'open-uri'
require "rexml/document"
require "nkf"

class Odakyu < Crawler

  BASE_URI = 'http://www.odakyu.jp/program/emg/'

  def crawl
    URI.parse(BASE_URI).read.scan(%r|certificate\d+.html|).sort.uniq.each do |path|
      uri = URI.join(BASE_URI, path)
      html = NKF.nkf('-w', uri.read)
      text = html.gsub(/<[^<]+>/,'').gsub(/\s+/, ' ')
      filename = []

      unless match = /遅延発生日 : (?<year>\d+)年(?<month>\d+)月(?<date>\d+)日/.match(text)
        raise ParseError, '遅延発生日を取得できませんでした'
      end
      filename << ("%04d%02d%02d" % [match[:year], match[:month], match[:date]].map(&:to_i))

      unless match = /遅延時間帯 : (?<start>[^ ]+) 〜 (?<end>[^ ]+)/.match(text)
        raise ParseError, '遅延時間帯を取得できませんでした'
      end
      filename << [match[:start], match[:end]].map{|v| v.sub(':', '')}.join('-')
      filename = filename.join('_')+'.png'
      filename = filename.sub('初電', '0000').sub('終電', '9999')

      p filename

      @driver.get(uri.to_s)
      @driver.save_screenshot(File.join(tmpdir, filename))

      sleep(1)
    end
  end
end
