class TaiwaneseNewsParser::Parser::AppleDaily < TaiwaneseNewsParser::Parser
  def self.domain
    'appledaily.com.tw'
  end

  def self.names
    %w{蘋果日報}
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://www.appledaily.com.tw/appledaily/article/headline/20130414/34951658'
  def parse
    @article[:title] = doc.at_css('#h1').text

    @article[:company_name] = parse_company_name

    @article[:content] = doc.css('.articulum').css('p,h2').text

    @article[:reporter_name] = parse_reporter_name()

    @article[:published_at] = self.class.parse_time(doc.css('.gggs time').text)

    clean_up

    @article
  end

  def parse_company_name
    '蘋果日報'
  end

  def parse_reporter_name
    text = doc.css('.articulum').css('p,h2').text.strip
    if match = text.match(%r{◎記者(.+)$})
      return reporter_name = match[1]
    elsif match = text.match(%r{【(?:記者)?(.+?)[/／╱]})
      reporter_name = match[1]
    end
    reporter_name
  end

  def clean_url
    @article[:url].gsub!(%r{/([^/]*)$},'')
  end

  def self.parse_url_id(url)
    # removes trailing slash
    url[%r{http://www.appledaily\.com\.tw/\w+/article/\w+/((?:\d+/)+)},1][0..-2]
  end

  def self.parse_time(raw_time)
    valid_formats = ['%Y年%m月%d日%H:%M', '%Y年%m月%d日']

    date = nil
    valid_formats.each do |format|
      begin
        date = DateTime.strptime(raw_time, format)
      rescue
      end
      break if !date.nil?
    end

    return date
  end
end
