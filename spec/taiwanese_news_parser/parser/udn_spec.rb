require 'spec_helper'

describe TaiwaneseNewsParser::Parser::Udn do
  describe '#parse' do
    it do
      url = 'http://udn.com/NEWS/NATIONAL/NAT4/7996060.shtml'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'udn_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '國光免費去宜蘭第二天 零星衝突'
      article[:content].should include('國光客運新開北宜高國5三條新路線，今天開放免費試乘第二天')
      article[:company_name].should == '聯合晚報'
      article[:reporter_name].should == '邱瓊平'
      article[:published_at].should == Time.new(2013,6,29,16,17)
    end
  end
  describe '#parse_reporter_name' do
    it do
      subject = described_class.new('http://udn.com/NEWS/NATIONAL/NAT2/8040540.shtml')
      expect{ subject.parse_reporter_name('中央社╱桃園20日電') }.to_not raise_error
    end
  end
end

