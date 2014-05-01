class TaiwaneseNewsParser::Parser::ChinaTimes < TaiwaneseNewsParser::Parser
  def self.domain
    'chinatimes.com'
  end

  def self.names
    %w{中國時報 中時電子報 工商時報 旺報 時報週刊 中天 中視 中廣 中時即時}
  end

  def self.applicable?(url)
    url.include?('chinatimes.com') && !url.include?('money.chinatimes.com')
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://news.chinatimes.com/mainland/11050505/112013041400325.html'
  #url = 'http://www.chinatimes.com/realtimenews/%E6%AD%BB%E4%BA%A1%E9%9B%B2%E9%9C%84%E9%A3%9B%E8%BB%8A-%E7%BE%8E%E5%A9%A6%E5%A2%9C%E8%90%BD%E8%BA%AB%E4%BA%A1-20130720002354-260408'
  def parse
    @article[:title] = doc.at_css('.page_container header h1').text

    @article[:company_name] = parse_company_name

    @article[:content] = doc.css('.page_container article>p').text

    #@article[:web_published_at] = Time.parse(doc.at_css('#story_update').text)

    @article[:reporter_name] = parse_reporter_name()

    t = doc.css('.reporter time').text.match(/(\d*)年(\d*)月(\d*)日 (\d*):(\d*)/)
    @article[:published_at] = Time.new(t[1],t[2],t[3],t[4],t[5])

    clean_up

    @article
  end

  def parse_reporter_name
    el = doc.at_css('.reporter a[rel=author]')
    return el.text if el

    text = doc.css('.reporter>text()').text
    if match = text.match(%r{記者(.+?)[/／╱／]})
      reporter_name = match[1]
    elsif match = text.match(%r{【(.+?)[/／╱／]})
      reporter_name = match[1]
    else
      reporter_name = text
    end
    reporter_name
  end

  def parse_company_name
    n = doc.at_css('.reporter>a').text
    if n == '時週精選'
      n = '時報週刊'
    elsif n == '新聞速報'
      n = '中時電子報'
    end
    n
  end

  def clean_url
    cleaner = TaiwaneseNewsParser::UrlCleaner.new('id')
    @article[:url] = cleaner.clean(@article[:url])
  end

  def self.parse_url_id(url)
    url_id = url[%r{http://news\.chinatimes\.com/\w+/(\d+/\d+)},1]
    if url_id.nil?
      url_id = url[%r{[^-]*+[^-]*+-(\d+)-\d+},1]
    end
    if url_id.nil?
      url_id = url[%r{chinatimes\.com/(.+)},1]
    end
    url_id
  end
end
