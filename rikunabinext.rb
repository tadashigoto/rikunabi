require 'rubygems'
require 'active_support'
require 'active_record'
require 'mechanize'
require 'Base64'

# DB接続設定
#ActiveRecord::Base.establish_connection(
#  adapter:  'sqlite3',
#  database: 'db/development.sqlite3',
#)
#class Tender < ActiveRecord::Base
#end
#def isNext(html,xpath)

# print "#{html.xpath(xpath).to_s}\n"
#  html.xpath(xpath).search('a').each do |nx|
#    return nx if nx.at('img').attribute('title').value=='次へ'
#  end
#  return false
#end
#ENV["SSL_CERT_FILE"] = './cert.pem'

agent = Mechanize.new
#agent.follow_meta_refresh = true
#agent.redirect_ok = true
#agent.user_agent_alias = 'Mac Safari'
agent.user_agent_alias = 'Windows Chrome'
agent.follow_meta_refresh = true
agent.redirect_ok = true
URL='https://saiyo.rikunabi.com/'
agent.get(URL) do |page|
  mypage = page.form_with(:name=>"frmLogin") do |form|
    form.login_nm = '05275260011638'
    form.pswd = 'carrot_software01'
  end.submit
  doc = Nokogiri::HTML(mypage.content.toutf8)
  print doc
end
#URL2 = 'https://www.amazon.co.jp/gp/your-account/order-history/ref=oh_aui_pagination_1_19?ie=UTF8&orderFilter=months-6&search=&startIndex=180'

#agent.get(URL2) do |page|
#  print page.xpath('/html')
#  page.xpath('//span[@class="hide-if-no-js"]').each do |row|
#    #print row.inner_html
#end
#end
#page.xpath('//span[@class="hide-if-no-js"]').each do |row|
#  print row.inner_text
#end
