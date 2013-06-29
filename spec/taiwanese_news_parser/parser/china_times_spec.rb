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
end

