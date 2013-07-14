require "taiwanese_news_parser/version"
require "taiwanese_news_parser/parser"
require 'nokogiri'
require 'open-uri'

module TaiwaneseNewsParser
  # returns a parser with basic information such as url unique code
  def self.new(url)
    Parser.applicable_parser(url)
  end

  def self.parse(url)
    Parser.applicable_parser(url).parse
  end
end
