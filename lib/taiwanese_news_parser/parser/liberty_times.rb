class TaiwaneseNewsParser::Parser::LibertyTimes < TaiwaneseNewsParser::Parser
  def self.domain
    'libertytimes.com.tw'
  end

  def self.names
    %{自由時報}
  end

  def self.applicable?(url)
    url.include?('iservice.ltn.com.tw')
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  def parse
    # new layout uses utf-8
    @article[:title] = doc.at_css('.content h1 text()').text
    @article[:company_name] = parse_company_name
    @article[:content] = doc.css('.content p').text

    time = doc.at_css('.content .date').text[%r{\d{4}-\d{1,2}-\d{1,2} \d{2}:\d{2}}]
    if time.nil?
      match = doc.at_css('.content .date').text.match(%r{(\d{2}):(\d{2})})
      now = Time.now
      today = Date.today
      @article[:published_at] = Time.new(today.year, today.month, today.day, match[1].to_i, match[2].to_i)
    else
      @article[:published_at] = Time.parse("#{time}:00")
    end

    @article[:reporter_name] = parse_reporter_name()

    clean_up

    @article
  end

  def parse_reporter_name
    if match = @article[:content].match(%r{〔(.*?)[/／╱](.*?)〕})
      reporter_name = match[1][%r{記者(.+)},1]
    elsif match = @article[:content].match(%r{記者(.+?)[/／╱]})
      reporter_name = match[1]
    elsif match = @article[:content].match(%r{（文／(.*?)）})
      reporter_name = match[1]
    end
    reporter_name
  end

  def parse_company_name
    '自由時報'
  end

  def clean_url
    cleaner = TaiwaneseNewsParser::UrlCleaner.new('no')
    @article[:url] = cleaner.clean(@article[:url])
  end

  def self.parse_url_id(url)
    url[%r{news\.php\?no=(\d+)},1]
  end
end
