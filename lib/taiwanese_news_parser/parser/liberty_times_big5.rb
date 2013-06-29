class TaiwaneseNewsParser::Parser::LibertyTimesBig5 < TaiwaneseNewsParser::Parser
  def self.domain
    'libertytimes.com.tw'
  end

  def self.applicable?(url)
    url.match(%r{libertytimes\.com\.tw/\d+/\w+/\w+/\d+/.+\.htm})
  end

  #url = 'http://www.libertytimes.com.tw/2013/new/apr/13/today-sp2.htm'
  def parse
    @article.title = @doc.at_css('#newtitle').text
    @article.company_name = '自由時報'
    @article.content = @doc.css('#newsContent>span:not(#newtitle)>p:not(.picture)').text

    @article.reporter_name = parse_reporter_name()
    @article.published_at = Time.parse(@doc.at_css('#date').text)

    clean_up

    @article
  end

  def parse_reporter_name
    if match = @article.content.match(%r{〔(.*?)[/／╱](.*?)〕})
      reporter_name = match[1][%r{記者(.+)},1]
    elsif match = @article.content.match(%r{記者(.+?)[/／╱]})
      reporter_name = match[1]
    elsif match = @article.content.match(%r{（文／(.*?)）})
      reporter_name = match[1]
    end
    reporter_name
  end

  def clean_url
    cleaner = TaiwaneseNewsParser::UrlCleaner.new('')
    @article.url = cleaner.clean(@article.url)
  end

  def self.parse_url_id(url)
    url[%r{http://www\.libertytimes\.com\.tw/(.*\.htm)},1]
  end
end
