require 'spec_helper'

describe TaiwaneseNewsParser::Parser::ChinaTimes do
  describe '#parse' do
    it do
      url = 'http://www.chinatimes.com/realtimenews/%E5%8A%A0%E6%B2%B9%E7%AB%99%E7%84%A1%E8%89%AF%E5%93%A1%E5%B7%A5-%E5%AD%B8%E5%A4%A7%E8%88%8C%E9%A0%AD%E8%AD%8F%E7%AC%91%E7%99%8C%E5%A9%A6-20130629002528-260402'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'china_times_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '「春盈號」第二艘救生筏尋獲時破損 2死15失蹤'
      article[:content].should include('高雄籍漁船「春盈號」日前在印度洋海域作業時發生火警')
      article[:company_name].should == '中廣'
      article[:reporter_name].should == '溫蘭魁'
      article[:published_at].should == Time.new(2013,6,29,18,24)
    end
  end
  describe '.parse_url_id' do
    it 'old url' do
      described_class.parse_url_id('http://news.chinatimes.com/mainland/11050505/112013041400325.html').should == '11050505/112013041400325'
    end
    it 'new url' do
      described_class.parse_url_id('http://www.chinatimes.com/newspapers/%E9%BB%8E%E5%B7%B4%E5%AB%A9%E7%A6%81%E8%B3%BD-%E4%BA%9E%E9%8C%A6%E8%B3%BD%E5%89%A915%E9%9A%8A-20130720000861-260111').should == '20130720000861-260111'
      described_class.parse_url_id('http://www.chinatimes.com/realtimenews/%E9%9F%93%E4%BA%9E%E8%88%AA%E7%BD%B9%E9%9B%A3%E5%B0%91%E5%A5%B3-%E7%A2%BA%E5%AE%9A%E9%81%AD%E6%95%91%E8%AD%B7%E8%BB%8A%E8%BC%BE%E6%96%83-20130720002396-260401').should == '20130720002396-260401'
    end
  end
end

