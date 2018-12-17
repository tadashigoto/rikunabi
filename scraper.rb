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
#agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
URL = 'https://ramendb.supleks.jp/s/71786.html'
page = agent.get(URL)
#agent.page.encoding = 'Shift_JIS'
page.xpath('//*[@id="data-table"]/tr[2]/td').each do |row|
  print row.inner_text
end
