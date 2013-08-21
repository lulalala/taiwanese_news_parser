class TaiwaneseNewsParser::Parser::Cna < TaiwaneseNewsParser::Parser
  def self.domain
    'cna.com.tw'
  end

  def self.names
    %{中央社}
  end

  def doc
    @raw = open(url).read
    @doc = Nokogiri::HTML(@raw)
  end

  #url = 'http://www.cna.com.tw/News/aSaM/201304120296-1.aspx'
  def parse
    @article[:title] = doc.at_css('.news_content h1').text

    @article[:company_name] = '中央社'

    @article[:content] = doc.css('.news_content .box_2').text

    @article[:reporter_name] = parse_reporter_name()

    match = doc.css('.news_content .box_2').text.strip.match( /(\d{3})(\d{2})(\d{2})/ )
    date = []
    date[0] = match[1].to_i + 1911
    date[1] = match[2]
    date[2] = match[3]
    date_string = date.join('/') + ' ' + doc.css('.date').text
    @article[:published_at] = Time.parse(date_string)

    clean_up

    @article
  end

  def parse_reporter_name
    text = doc.css('.news_content .box_2').text
    text = text[/（中央社(.*?)\d{1,2}日/,1]
    cities = %w{台北 新北 台中 台南 高雄 基隆 新竹 嘉義 桃園 新竹 苗栗 彰化 南投 雲林 嘉義 屏東 宜蘭 花蓮 台東 澎湖 金門 連江}
    cities.find do |city|
      text.gsub!(/#{city}(?:縣市)?$/,'')
    end
    # TODO proper location name removal
    if match = text.match(%r{記者(.+)})
      reporter_name = match[1]
    end
    reporter_name
  end

  def reproduced?
    false
  end

  def self.parse_url_id(url)
    url[%r{/(\d+)(?:\-\d)?\.},1]
  end
end
