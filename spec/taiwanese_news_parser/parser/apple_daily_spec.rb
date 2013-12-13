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
      article[:reporter_name].should == '王家俊'
      article[:published_at].should == DateTime.new(2013,6,29,19,35)
    end

    it do
      url = 'http://www.appledaily.com.tw/appledaily/article/headline/20050811/1968864'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'apple_daily_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '診所助理救活人反觸法' #TODO remove one space in the middle
      article[:content].should include('姚在事發後已離職，林鴻也病逝。')
      article[:content].should include('女子姚素珍三年前在北市中心診所當助理研究員')
      article[:company_name].should == '蘋果日報'
      article[:reporter_name].should == '丁牧群'
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

  describe '.parse_time' do
    it 'parse date with time ' do
      described_class.parse_time('2013年06月29日19:35').should == DateTime.new(2013,6,29,19,35)
    end
    it 'parse date' do
      described_class.parse_time('2005年08月11日').should == DateTime.new(2005,8,11)
    end
  end
end

