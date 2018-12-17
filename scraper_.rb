require 'rubygems'
require 'active_support'
require 'active_record'
require 'mechanize'

# p __ENCODING__ 
agent = Mechanize.new
URL = 'http://www.chusho-ma-support.com/modules/sell/index.php'
page = agent.get(URL)
# agent.page.encoding = 'Shift_JIS'
lnc = 0
  page.xpath('//*[@id="sellContent"]/div[2]/div/div[2]/table[@class="table"]/tbody').each do |row|
    td = row.search("tr")[4].search("td")[1].inner_text.strip
    next if td == "応相談"
    gyoshu = row.search("tr")[1].search("td")[1].inner_text.strip
    address = row.search("tr")[2].search("td")[1].inner_text.strip
    print "#{td} #{address} #{gyoshu}\n"
    lnc = lnc + 1
  end
