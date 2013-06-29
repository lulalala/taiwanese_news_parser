require 'taiwanese_news_parser'
require 'fake_web'

RSpec.configure do |config|
  def sample(path, filename)
    open(File.join(File.dirname(path), filename))
  end
end
