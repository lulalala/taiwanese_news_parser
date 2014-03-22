class TaiwaneseNewsParser::Parser::Cts < TaiwaneseNewsParser::Parser
  def self.domain
    'cts.com.tw'
  end

  def self.names
    ['華視']
  end

  def self.applicable?(url)
    url.match(%r{cts\.com\.tw/})
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://news.cts.com.tw/cts/politics/201403/201403191393958.html'
  def parse
    @article[:title] = doc.at_css('table h1').text
    @article[:company_name] = parse_company_name
    @article[:content] = doc.css('#ctscontent p').text

    time = doc.at_css('td.style14 span.info').text[%r{^\d{4}/\d{1,2}/\d{1,2} \d{2}:\d{2}}]
    @article[:published_at] = Time.parse("#{time}:00")

    @article[:reporter_name] = parse_reporter_name()

    clean_up

    @article
  end

  def parse_reporter_name
    text = doc.at_css('td.style14 span.info').text
    text.gsub!(%r{^\d{4}/\d{1,2}/\d{1,2} \d{2}:\d{2}},'')
    text.gsub!(%r{地區.+$},'')
    if text.include?('綜合報導')
      return nil
    end
    text[%r{(.+) 報導},1]
  end

  def parse_company_name
    doc.at_css('table table div[align="right"] a img').attr(:alt)
  end

  def self.parse_url_id(url)
    url[%r{/cts/.+/\d+/(\d+)\.html},1]
  end
end
