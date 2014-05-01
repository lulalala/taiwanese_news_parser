class TaiwaneseNewsParser::Parser::ChinaTimesMoney < TaiwaneseNewsParser::Parser
  def self.domain
    'chinatimes.com'
  end

  def self.names
    %w{中國時報 中時電子報 工商時報 旺報 時報週刊 中天 中視 中廣 中時即時}
  end

  def self.applicable?(url)
    url.include?('money.chinatimes.com')
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://money.chinatimes.com/news/news-content.aspx?id=20140405000233&cid=1206&fb_action_ids=682850115112321&fb_action_types=og.comments'
  def parse
    @article[:title] = doc.at_css('.articlebox h1.highlight').text

    @article[:company_name] = parse_company_name

    @article[:content] = doc.css('#zoom-area p').text

    #@article[:web_published_at] = Time.parse(doc.at_css('#story_update').text)

    @article[:reporter_name] = parse_reporter_name()

    @article[:published_at] = Time.parse(@doc.css('.bar-align-left>ul.inline-list>li')[0].text)

    clean_up

    @article
  end

  def parse_reporter_name
    text = doc.css('.bar-align-left>ul.inline-list>li.last').text
    if match = text.match(%r{(.+?)[/／╱／]})
      reporter_name = match[1]
    elsif match = text.match(%r{【(.+?)[/／╱／]})
      reporter_name = match[1]
    else
      reporter_name = text
    end
    reporter_name
  end

  def parse_company_name
    n = doc.css('.bar-align-left>ul.inline-list>li')[1].text
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
    cleaner = TaiwaneseNewsParser::UrlCleaner.new('id')
    cleaned_url = cleaner.clean(url)
    url_id = cleaned_url[%r{id=(\d+)},1]
    url_id
  end
end

