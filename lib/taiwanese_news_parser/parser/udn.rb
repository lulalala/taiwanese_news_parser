class TaiwaneseNewsParser::Parser::Udn < TaiwaneseNewsParser::Parser
  def self.domain
    'udn.com'
  end

  #url = 'http://udn.com/NEWS/NATIONAL/NATS5/7807573.shtml'
  def parse
    @article[:title] = @doc.at_css('#story_title').text
    @article[:content] = @doc.at_css('#story').text

    #a.web_published_at = Time.parse(@doc.at_css('#story_update').text)

    origin = @doc.at_css('#story_author').text.match(%r{【(.*)[/／╱](.*)[/／╱]})
    @article[:company_name] = origin[1]
    @article[:reporter_name] = origin[2][%r{記者(.+)},1]
    @article[:published_at] = Time.parse(@doc.at_css('#story_update').text)

    clean_up

    @article
  end

  def reproduced?
    @doc.css('td.story_author div#story_author').text.include?('中央社')
  end

  def self.parse_url_id(url)
    url[%r{(\w+/\w+/\d+)},1]
  end
end
