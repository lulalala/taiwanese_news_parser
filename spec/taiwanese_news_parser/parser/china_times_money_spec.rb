require 'spec_helper'

describe TaiwaneseNewsParser::Parser::ChinaTimesMoney do
  describe '#parse' do
    it 'format' do
      url = 'http://money.chinatimes.com/news/news-content.aspx?id=20140405000233&cid=1206'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'china_times_money_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '美罕見用要負責任批反服貿'
      article[:content].should include('美國國務院亞太助卿羅素')
      article[:company_name].should == '中國時報'
      article[:reporter_name].should == '劉屏'
      article[:published_at].should == Time.new(2014,4,5,1,28)
    end
  end
  describe '.parse_url_id' do
    it 'new url' do
      described_class.parse_url_id('http://money.chinatimes.com/news/news-content.aspx?id=20140405000233&cid=1206').should == '20140405000233'
    end
  end
end
