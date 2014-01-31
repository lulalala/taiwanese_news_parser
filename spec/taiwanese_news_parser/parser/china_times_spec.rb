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
    it do
      url = 'http://www.chinatimes.com/newspapers/%E7%99%BD%E7%B1%B3%E6%8F%9B%E7%95%AA%E8%96%AF-%E9%A6%AC%E5%B8%82%E5%BA%9C%E6%9C%89%E5%85%A7%E9%AC%BC%EF%BC%9F-20130718000466-260102'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'china_times_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '白米換番薯 馬市府有內鬼？'
      article[:content].should include('市民只能望著已換成台北富邦銀行的招牌，望樓興歎。')
      article[:company_name].should == '中國時報'
      article[:reporter_name].should == '張立勳'
      article[:published_at].should == Time.new(2013,7,18,5,40)
    end
    it do
      url = 'http://www.chinatimes.com/newspapers/20131127000637-260112'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'china_times_s3.html'))
      article = described_class.new(url).parse
      article[:title].should == '李安失望台灣商業片 不會進戲院'
      article[:content].should include('金馬50風光落幕，擔任評審團主委的李安不負眾望，以國際化視野，評出最優秀作品。')
      article[:company_name].should == '中國時報'
      article[:reporter_name].should == '陳亭均'
      article[:published_at].should == Time.new(2013,11,27,4,9)
    end
    it 'format' do
      url = 'http://news.chinatimes.com/politics/11050202/112013122200105.html'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'china_times_s4.html'))
      article = described_class.new(url).parse
      article[:title].should == '柯文哲團隊 將網羅一九八五'
      article[:content].should include('下一步，更有意號召公民一九八五等社會團體加入。')
      article[:company_name].should == '中國時報'
      article[:reporter_name].should == '朱真楷'
      article[:published_at].should == Time.new(2013,12,22,4,9)
    end
  end
  describe '.parse_url_id' do
    it 'old url' do
      described_class.parse_url_id('http://news.chinatimes.com/mainland/11050505/112013041400325.html').should == '11050505/112013041400325'
    end
    it 'new url' do
      described_class.parse_url_id('http://www.chinatimes.com/newspapers/%E9%BB%8E%E5%B7%B4%E5%AB%A9%E7%A6%81%E8%B3%BD-%E4%BA%9E%E9%8C%A6%E8%B3%BD%E5%89%A915%E9%9A%8A-20130720000861-260111').should == '20130720000861'
      described_class.parse_url_id('http://www.chinatimes.com/realtimenews/%E9%9F%93%E4%BA%9E%E8%88%AA%E7%BD%B9%E9%9B%A3%E5%B0%91%E5%A5%B3-%E7%A2%BA%E5%AE%9A%E9%81%AD%E6%95%91%E8%AD%B7%E8%BB%8A%E8%BC%BE%E6%96%83-20130720002396-260401').should == '20130720002396'
    end
    it do
      url = 'http://www.chinatimes.com/realtimenews/%E9%AB%98%E9%90%B510%EF%BC%8F1%E6%BC%B2%E5%83%B9-%E6%B6%88%E5%9F%BA%E6%9C%83%E6%89%B9%E4%B8%8D%E5%90%88%E7%90%86-20130816003789-260405'
      described_class.parse_url_id(url).should == '20130816003789'
    end
    it do
      url = 'http://www.chinatimes.com/realtimenews/%E4%B8%8A%E6%91%A9%E9%90%B5%E7%B4%84%E6%9C%83%E6%9B%9D%E5%85%89-%E9%99%B3%E6%BC%A2%E5%85%B8%E6%88%80%E6%83%85%E7%94%9F%E8%AE%8A-20130816002793-260404'
      described_class.parse_url_id(url).should == '20130816002793'
    end
  end
end
