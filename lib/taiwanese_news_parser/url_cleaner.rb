require "addressable/uri"
class TaiwaneseNewsParser::UrlCleaner
  # white_list: Array of string, denoting url query 
  # parameters that cleaner should keep
  def initialize(white_list = nil)
    @white_list = Array(white_list)
    @white_list.map!(&:to_s)
  end

  def clean(url)
    @url = Addressable::URI.parse(url)
    params = @url.query_values
    if params
      params.keep_if{|k,v| @white_list.include?(k) }
    end
    @url.query_values = params
    @url.to_s
  end
end
