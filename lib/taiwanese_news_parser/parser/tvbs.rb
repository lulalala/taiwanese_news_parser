class TaiwaneseNewsParser::Parser::Tvbs < TaiwaneseNewsParser::Parser
  def self.domain
    'tvbs.com.tw'
  end

  def self.names
    ['TVBS']
  end

  def self.applicable?(url)
    url.match(%r{tvbs\.com\.tw/entry})
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://news.tvbs.com.tw/entry/519673'
  def parse
    @article[:title] = doc.at_css('article h1').text
    @article[:company_name] = parse_company_name
    @article[:content] = doc.css('article .content').text

    time = doc.at_css('article .meta-data .dateline').text[%r{時間：\d{4}/\d{1,2}/\d{1,2} \d{2}:\d{2}}]
    @article[:published_at] = Time.parse("#{time}:00")

    @article[:reporter_name] = parse_reporter_name()

    clean_up

    @article
  end

  def parse_reporter_name
    doc.at_css('article .meta-data .reporter').text[%r{記者：(.+)},1]
  end

  def parse_company_name
    self.class.names.first
  end

  def self.parse_url_id(url)
    url[%r{/entry/(\d+)},1]
  end
end
