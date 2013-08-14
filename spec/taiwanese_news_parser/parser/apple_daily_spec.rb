require 'spec_helper'

describe TaiwaneseNewsParser::Parser::AppleDaily do
  describe '#parse' do
    it do
      url = 'http://www.appledaily.com.tw/realtimenews/article/politics/20130629/217673/%E9%82%B1%E6%96%87%E9%81%94%E5%85%A7%E5%AE%9A%E8%A1%9B%E7%A6%8F%E9%83%A8%E9%95%B7%E6%94%BF%E6%AC%A1%E6%9B%BE%E4%B8%AD%E6%98%8E%E6%88%B4%E6%A1%82%E8%8B%B1%E5%91%BC%E8%81%B2%E9%AB%98'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'apple_daily_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '邱文達內定衛福部長  政次曾中明戴桂英呼聲高' #TODO remove one space in the middle
      article[:content].should include('配合行政院組織改造，內政部社會司')
      article[:company_name].should == '蘋果日報'
      #TODO article[:reporter_name].should == '王家俊'
      article[:published_at].should == DateTime.new(2013,6,29,19,35)
    end
  end

  describe '#parse_url_id' do
    example 'realtime news' do
      url = 'http://www.appledaily.com.tw/realtimenews/article/international/20130807/238720/'
      described_class.parse_url_id(url).should == '20130807/238720'
    end
    example 'url with three numbers' do
      url = 'http://www.appledaily.com.tw/realtimenews/article/politics/20130809/239528/1/'
      described_class.parse_url_id(url).should == '20130809/239528/1'
    end
  end
end

