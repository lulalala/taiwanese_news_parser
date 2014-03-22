class TaiwaneseNewsParser::Parser::NowNews < TaiwaneseNewsParser::Parser
  def self.domain
    'nownews.com'
  end

  def self.names
    %w{NowNews 今日新聞}
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://www.nownews.com/n/2014/03/21/1159861'
  def parse
    @article[:title] = doc.css('[itemprop=headline]').text

    @article[:company_name] = self.class.names.first

    @article[:content] = doc.css('[itemprop=articleBody]>p').text

    @article[:reporter_name] = parse_reporter_name()

    t = doc.css('#reporter_info p').text.match(/(\d*)年\s*(\d+)月\s*(\d+)日\D*(\d+):(\d+)/)
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
    url[%r{/\d+/\d+/\d+/(\d+)},1]
  end

  def reproduced?
    false
  end
end
