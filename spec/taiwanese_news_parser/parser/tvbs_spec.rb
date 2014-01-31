require 'spec_helper'

describe TaiwaneseNewsParser::Parser::Tvbs do
  describe '#parse' do
    before do
      Timecop.freeze(Time.local(2013,6,29,9,13))
    end
    it do
      url = 'http://news.tvbs.com.tw/entry/519673'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'tvbs_s1.html'))
      article = described_class.new(url).parse
      article[:title].should == '昔笑談連勝文、今尷尬迴避！　馬連會微妙'
      article[:content].should include('馬總統照往例總是會到國民黨榮譽主席連戰家走一趟')
      article[:company_name].should == 'TVBS'
      article[:reporter_name].should == '邱婉柔'
      article[:published_at].should == Time.new(2014,1,31,18,32)
    end
    it do
      url = 'http://news.tvbs.com.tw/entry/519613'
      FakeWeb.register_uri(:get, url, body:sample(__FILE__,'tvbs_s2.html'))
      article = described_class.new(url).parse
      article[:title].should == '拚押張德正　院檢攻防3回戰'
      article[:content].should include('羈押庭攻防，法官2次裁定張德正無保請回')
      article[:company_name].should == 'TVBS'
      article[:reporter_name].should == nil
      article[:published_at].should == Time.new(2014,1,31,11,11)
    end
  end

  describe '#parse_url_id' do
    it do
      url = 'http://news.tvbs.com.tw/entry/519673'
      described_class.parse_url_id(url).should == '519673'
    end
  end
end
