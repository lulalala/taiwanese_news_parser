class TaiwaneseNewsParser::Parser::Ettoday < TaiwaneseNewsParser::Parser
  def self.domain
    'ettoday.net'
  end

  def self.names
    %w{東森}
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://www.ettoday.net/news/20130128/158005.htm'
  def parse
    @article[:title] = doc.css('[itemprop=headline]').text

    @article[:company_name] = '東森'

    @article[:content] = doc.css('.story p').text

    @article[:reporter_name] = parse_reporter_name()

    t = doc.css('.news-time').text.match(/(\d*)年(\d*)月(\d*)日 (\d*):(\d*)/)
    @article[:published_at] = Time.new(t[1],t[2],t[3],t[4],t[5])

    clean_up

    @article
  end

  def parse_reporter_name
    text = doc.css('[itemprop=articleBody]').text
    if match = text.match(%r{記者(.+?)[/／╱／]})
      reporter_name = match[1]
    end
    reporter_name
  end

  def clean_url
    cleaner = TaiwaneseNewsParser::UrlCleaner.new()
    @article[:url] = cleaner.clean(@article[:url])
  end

  def self.parse_url_id(url)
    url[%r{http://www\.ettoday\.net/\w+/(\d+/\d+)},1]
  end

  def reproduced?
    false
  end
end
