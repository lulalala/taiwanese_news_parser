require "taiwanese_news_parser/version"
require "taiwanese_news_parser/parser"
require 'nokogiri'
require 'open-uri'

module TaiwaneseNewsParser
  def self.parse(url)
    Parser.applicable_parser(url).parse
  end
end
