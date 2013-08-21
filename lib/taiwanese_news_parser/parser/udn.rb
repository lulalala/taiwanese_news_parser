class TaiwaneseNewsParser::Parser::Udn < TaiwaneseNewsParser::Parser
  def self.domain
    'udn.com'
  end

  def self.names
    %{聯合報 聯合晚報}
  end

  #url = 'http://udn.com/NEWS/NATIONAL/NATS5/7807573.shtml'
  def parse
    @article[:title] = doc.at_css('#story_title').text
    @article[:content] = doc.at_css('#story').text

    #a.web_published_at = Time.parse(doc.at_css('#story_update').text)

    @article[:company_name] = parse_company_name
    @article[:reporter_name] = parse_reporter_name

    @article[:published_at] = Time.parse(doc.at_css('#story_update').text)

    clean_up

    @article
  end

  def parse_company_name
    get_company_name_and_reporter_name.match(%r{^(.*?)[/／╱]})[1]
  end
  def parse_reporter_name
    get_company_name_and_reporter_name[%r{[/／╱]記者(.*)[/／╱]},1]
  end

  def self.parse_url_id(url)
    url[%r{\w+/\w+/(\d+)},1]
  end

private

  def get_company_name_and_reporter_name
    doc.at_css('#story_author').text[%r{【(.*)】},1]
  end
end
