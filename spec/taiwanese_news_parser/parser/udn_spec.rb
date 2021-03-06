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
    it do
      url = 'http://udn.com/NEWS/SPORTS/SPO6/8950901.shtml'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'udn_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '南韓style 明目張膽搞小動作'
      article[:content].should include('仁川亞運才正式開賽兩天')
      article[:company_name].should == '聯合報'
      article[:reporter_name].should == '古硯偉'
      article[:published_at].should == Time.new(2014,9,22,10,29)
    end
  end
  describe '#parse_reporter_name' do
    it do
      subject = described_class.new('http://udn.com/NEWS/NATIONAL/NAT2/8040540.shtml')
      subject.stub(:get_company_name_and_reporter_name){'中央社╱桃園20日電'}

      expect{ subject.parse_reporter_name }.to_not raise_error
    end
  end
  describe '#reproduced?' do
    it do
      subject = described_class.new('http://udn.com/NEWS/NATIONAL/NAT2/8040540.shtml')
      subject.stub(:get_company_name_and_reporter_name){'中央社╱桃園20日電'}
      subject.reproduced?.should == true
    end
  end
  describe '#parse_url_id' do
    it do
      url = 'http://udn.com/news/national/nats4/8099187.shtml'
      described_class.parse_url_id(url).should == '8099187'
    end
    it 'breaking news' do
      url = 'http://udn.com/NEWS/BREAKINGNEWS/BREAKINGNEWS1/8101247.shtml'
      described_class.parse_url_id(url).should == '8101247'
    end
  end
end

