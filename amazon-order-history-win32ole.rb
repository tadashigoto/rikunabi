#
# アマゾン購入履歴PDF出力
#
require 'win32ole'
require 'nokogiri'
require 'htmldoc'
ie = WIN32OLE.new("InternetExplorer.Application")
cnt_in=0
for yyyy in 2016..2017 do
  STDERR.print "new YYYY #{yyyy}\n"
  cnt_max = 0
  cnt_in = 0
  STDERR.print "cnt_in=#{cnt_in}\n"  
  ie.Navigate "https://www.amazon.co.jp/gp/your-account/order-history?opt=ab&digitalOrders=1&unifiedOrders=1&returnTo=&__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&orderFilter=year-"+yyyy.to_s

  ie.Visible = true
  cnt_page = 0
  while true do
    while ie.Busy == true
      sleep 1
    end
    cnt_page += 1
    ie.document.getElementsByTagName("html").each do |html0|
      html = Nokogiri::HTML.parse(html0.outerHTML, nil, "CP932") #utf-8
      cnt_max = $1.to_i if /(\d+)/ =~ html.xpath('//*[@id="controlsContainer"]/div[2]/span[2]/span').inner_text
     
      STDERR.print "#{yyyy}年#{cnt_page}ページ/#{cnt_max}件中#{html.xpath('//div[@class="a-box-group a-spacing-base order"]').size}明細\n"
      html.xpath('//div[@class="a-box-group a-spacing-base order"]').each do |grp|
        cnt_in += 1;
        grp2 = Nokogiri::HTML.parse(grp.to_s, nil, "CP932")
        # 注文年月日
        print grp2.xpath('//div[@class="a-row a-size-base"]')[0].inner_text.strip, ","
        # 商品
        products = grp2.xpath('//div[@class="a-fixed-left-grid-col a-col-right"]/div[1]/a')
        if products.empty?
            print "-\n"
            next
        end
        print '"', products[0].inner_text.strip
        print "等" if products.size > 1
        print '",'
        # 金額
        print $1.gsub(",",""), "," if /([\d,]+)/ =~ grp2.xpath('//div[@class="a-row a-size-base"]')[1].inner_text.strip
        # URL
        print '"','https://www.amazon.co.jp',$1.gsub('amp;',''),'"',"\n" if /href=\"([^\"]*)\"/ =~ grp2.xpath('//span[@class="hide-if-js"]/a')[0].to_s  
      end
    end
    STDERR.print "cnt_in=#{cnt_in},cnt_max=#{cnt_max}\n"
    break if cnt_in >= cnt_max
    ie.Navigate "https://www.amazon.co.jp/gp/your-account/order-history/ref=oh_aui_pagination_1_28?ie=UTF8&orderFilter=year-" + yyyy.to_s + "&search=&startIndex=" + (cnt_page * 10).to_s
    sleep 4
  end
end
#ie.Visible = false