class TaiwaneseNewsParser::Parser::LibertyTimesNews < TaiwaneseNewsParser::Parser
  def self.domain
    'ltn.com.tw'
  end

  def self.names
    %{自由時報}
  end

  def self.applicable?(url)
    url.include?('news.ltn.com.tw')
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://news.ltn.com.tw/news/politics/breakingnews/998126'
  def parse
    # new layout uses utf-8
    @article[:title] = doc.at_css('.content h1').text
    @article[:company_name] = parse_company_name
    @article[:content] = doc.css('#newstext p').text

    doc.css('script').each do |script|
      match = script.content.match(%r{newsTime\s=\s\'(\d+)\';$})
      if not match.nil?
        timestamp = match.captures[0].to_i
        @article[:published_at] = Time.at(timestamp)
        break
      end
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
    cleaner = TaiwaneseNewsParser::UrlCleaner.new()
    @article[:url] = cleaner.clean(@article[:url])
  end

  def self.parse_url_id(url)
    url[%r{\w+/\w+/\w+/(\d+)},1]
  end
end
