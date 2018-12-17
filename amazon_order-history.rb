require 'rubygems'
require 'active_support'
require 'active_record'
require 'mechanize'

# DB接続設定
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'db/development.sqlite3',
)
class Tender < ActiveRecord::Base
end
def isNext(html,xpath)
  # print "#{html.xpath(xpath).to_s}\n"
  html.xpath(xpath).search('a').each do |nx|
    return nx if nx.at('img').attribute('title').value=='次へ'
  end
  return false
end
ENV["SSL_CERT_FILE"] = './cert.pem'

agent = Mechanize.new
#agent.follow_meta_refresh = true
#agent.redirect_ok = true
#agent.user_agent_alias = 'Mac Safari'
agent.user_agent_alias = 'Windows Chrome'
agent.follow_meta_refresh = true
agent.redirect_ok = true
URL='https://www.amazon.co.jp/ap/signin?_encoding=UTF8&ignoreAuthState=1&openid.assoc_handle=jpflex&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.ns.pape=http%3A%2F%2Fspecs.openid.net%2Fextensions%2Fpape%2F1.0&openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.co.jp%2F%3Fref_%3Dnav_custrec_signin&switch_account='
page = agent.get(URL)
form = page.form(:name=>"signIn")
form.field_with(:name => 'email').value = 'tadashi.goto2564@gmail.com'
form.field_with(:name => 'password').value = '03712564'
form.submit
URL2 = 'https://www.amazon.co.jp/gp/your-account/order-history/ref=oh_aui_pagination_1_19?ie=UTF8&orderFilter=months-6&search=&startIndex=180'

agent.get(URL2) do |page|
  print page.xpath('/html')
  page.xpath('//span[@class="hide-if-no-js"]').each do |row|
    #print row.inner_html
  end
end
#page.xpath('//span[@class="hide-if-no-js"]').each do |row|
#  print row.inner_text
#end
