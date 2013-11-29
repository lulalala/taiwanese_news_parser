require 'spec_helper'

describe TaiwaneseNewsParser::Parser::Ettoday do
  describe '#parse' do
    it do
      url = 'http://www.ettoday.net/news/20131129/302433.htm'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'ettoday_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '檢方都諭令「不得騷擾」了　王貴芬30日赴長庚道歉'
      article[:content].should include('桃園檢方訊後將她以10萬元交保並限制住居及出境')
      article[:company_name].should == '東森'
      article[:reporter_name].should == nil
      article[:published_at].should == Time.new(2013,11,29,21,19)
    end
    it do
      url = 'http://www.ettoday.net/news/20130128/158005.htm'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'ettoday_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '軍公教18%調9%？　民進黨不支持：18%結構複雜'
      article[:content].should include('軍公教18%優存利率可望調降為9%')
      article[:company_name].should == '東森'
      article[:reporter_name].should == '王文萱'
      article[:published_at].should == Time.new(2013,1,28,15,23)
    end
  end
  describe '.parse_url_id' do
    it do
      described_class.parse_url_id('http://www.ettoday.net/news/20131129/302031.htm').should == '20131129/302031'
    end
  end
end
