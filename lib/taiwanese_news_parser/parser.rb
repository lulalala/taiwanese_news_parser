require 'taiwanese_news_parser/url_cleaner'

class TaiwaneseNewsParser::Parser
  attr_reader :doc

  def self.applicable?(url)
    url.include?(domain())
  end

  def self.applicable_parser(url)
    parser_class = subclasses.find do |parser_class|
      parser_class.applicable?(url)
    end
    if parser_class
      parser_class.new(url)
    end
  end

  def initialize(url)
    @article = {}
    @article[:url] = url
    @article[:web_domain] = self.class.domain()
    @article[:url_id] = self.class.parse_url_id(url)
    set_doc(url)
  end

  def set_doc(url)
    @raw = open(url).read.encode('utf-8', 'big5', :invalid => :replace, :undef => :replace, :replace => '')
    @doc = ::Nokogiri::HTML(@raw,url)
  end

  def clean_up
    [:content, :title, :reporter_name, :company_name].each do |attr|
      @article[attr].strip! if @article[attr]
    end
    clean_url if respond_to?(:clean_url)
    @article[:reproduced] = reproduced?
  end

  def reproduced?
    false
  end

  Dir[File.dirname(__FILE__) + '/parser/*.rb'].each{|file| require file}
  def self.subclasses
    [ Udn, LibertyTimes, LibertyTimesBig5, ChinaTimes, Cna, AppleDaily ]
  end

  def self.domain
    raise NotImplementedError
  end
end
