require 'spec_helper'

describe TaiwaneseNewsParser::Parser::LibertyTimes do
  describe '#parse' do
    before do
      Timecop.freeze(Time.local(2013,6,29,9,13))
    end
    it do
      url = 'http://iservice.ltn.com.tw/2014/specials/nonukes/news.php?rno=1&no=998521&type=l'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'liberty_times_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '馮光遠：郝因「劫機」被打成秀斗搞獨裁'
      article[:content].should include('馮光遠補充，郝龍斌後來因為驅離績效卓著，因此「榮升」國民黨副主席。')
      article[:company_name].should == '自由時報'
      article[:reporter_name].should == nil
      article[:published_at].should == Time.new(2014,4,30,23,54)
    end
    it do
      url = 'http://iservice.ltn.com.tw/2014/specials/nonukes/news.php?rno=1&no=998521&type=l'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'liberty_times_s3.html'))
      article = described_class.new(url).parse
      article[:title].should == '林義雄宣布停止禁食 願再為台奮鬥'
      article[:content].should include('林義雄說，為了回應台灣人民的真摯關愛')
      article[:company_name].should == '自由時報'
      article[:reporter_name].should == '李欣芳'
      article[:published_at].should == Time.new(2014,4,30,14,49)
    end
  end

  describe '#parse_url_id' do
    it do
      url = 'http://iservice.libertytimes.com.tw/liveNews/news.php?no=854755&Slots=Live'
      described_class.parse_url_id(url).should == '854755'

      url = 'http://iservice.libertytimes.com.tw/liveNews/news.php?no=854838&type=%E5%9C%8B%E9%9A%9B'
      described_class.parse_url_id(url).should == '854838'
    end
  end
end
