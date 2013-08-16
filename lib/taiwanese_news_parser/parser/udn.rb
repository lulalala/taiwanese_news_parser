class TaiwaneseNewsParser::Parser::Udn < TaiwaneseNewsParser::Parser
  def self.domain
    'udn.com'
  end

  #url = 'http://udn.com/NEWS/NATIONAL/NATS5/7807573.shtml'
  def parse
    @article[:title] = doc.at_css('#story_title').text
    @article[:content] = doc.at_css('#story').text

    #a.web_published_at = Time.parse(doc.at_css('#story_update').text)

    # TODO better way to handle company name parsing
    if !reproduced?
      set_company_and_reporter
    end
    @article[:published_at] = Time.parse(doc.at_css('#story_update').text)

    clean_up

    @article
  end

  def set_company_and_reporter
    source = doc.at_css('#story_author').text[%r{【(.*)】},1]
    @article[:company_name] = parse_company_name(source)
    @article[:reporter_name] = parse_reporter_name(source)
  end

  def parse_company_name(text)
    text.match(%r{^(.*?)[/／╱]})[1]
  end
  def parse_reporter_name(text)
    text[%r{[/／╱]記者(.*)[/／╱]},1]
  end

  def reproduced?
    doc.css('td.story_author div#story_author').text.include?('中央社')
  end

  def self.parse_url_id(url)
    url[%r{\w+/\w+/(\d+)},1]
  end
end
