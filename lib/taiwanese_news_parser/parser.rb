require 'taiwanese_news_parser/url_cleaner'
require 'memoist'

class TaiwaneseNewsParser::Parser
  extend Memoist

  attr_accessor :url
  attr_reader :article

  def self.applicable?(url)
    url.include?(domain())
  end

  def self.applicable_parser(url)
    redirected_url = open(url).base_uri.to_s

    parser_class = subclasses.find do |parser_class|
      parser_class.applicable?(redirected_url)
    end
    if parser_class
      parser_class.new(redirected_url)
    end
  end

  def initialize(url)
    @url = url
    @article = {}
    @article[:url] = url
    @article[:web_domain] = self.class.domain()
    @article[:url_id] = self.class.parse_url_id(url)
  end

  def doc
    @raw = open(url).read.encode('utf-8', 'big5', :invalid => :replace, :undef => :replace, :replace => '')
    @doc = ::Nokogiri::HTML(@raw,url)
  end
  memoize :doc

  def clean_up
    [:content, :title, :reporter_name, :company_name].each do |attr|
      @article[attr].strip! if @article[attr]
    end
    clean_url if respond_to?(:clean_url)
    @article[:reproduced] = reproduced?
  end

  def reproduced?
    !self.class.names.include?(parse_company_name)
  end

  Dir[File.dirname(__FILE__) + '/parser/*.rb'].each{|file| require file}
  def self.subclasses
    [ Udn, LibertyTimes, LibertyTimesBig5, ChinaTimes, Cna, AppleDaily, Ettoday, Tvbs, Cts, NowNews ]
  end

  def self.domain
    raise NotImplementedError
  end
end
