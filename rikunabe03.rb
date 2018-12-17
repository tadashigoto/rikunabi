# coding: utf-8
require 'selenium-webdriver'
def get_memberinfo(otf, row)
# 2列:メンバー情報
    col = row.find_element(:xpath, 'td[2]')
    # 0.アプローチ
    approach = col.find_element(:xpath,'div[1]').text
    #print "approach:#{approach}\n"
    # 1.アクセス日
    access_dt = col.find_element(:xpath,'ul/li[1]').text
    #print "access_dt:#{access_dt}\n"
    # 2. 会員番号
    member_id = $1 if col.find_element(:xpath,'ul/li[2]').text.match /(\d+)/
        #print "member_id:#{member_id}\n"
    # 3.年齢 / 在住
    age_g = col.find_element(:xpath,'ul/li[3]').text
    #print "age_g:#{age_g}\n"
    age, resident = $1, $2 if age_g.match /(\d+)[^\d\/]+[\s\/]*(\S+)/
    #print "age:#{age} "
    resident.sub!("在住","")
    #print "resident:#{resident}\n"
    # 4.年収
    income = col.find_element(:xpath, 'ul/li[4]').text
    income.gsub!("年収","").gsub!("万円","")
    #print "income:#{income}\n"
# 3列:学歴情報
    col = row.find_element(:xpath, 'td[3]')
    education = col.text.split("●")
    education.each do |item|
    #    print "item:#{item}\n"
    end
# 4列:職歴情報
    col = row.find_element(:xpath, 'td[4]')
    works = col.text
    works.split("●").each do |item|
    #    print "item:#{item}\n"
    end
# 5列:スキル情報
    col = row.find_element(:xpath, 'td[5]')
    skills = col.text
    skills.split("●").each do |item|
    #    print "item:#{item}\n"
    end
# 6列:経験業務情報
    col = row.find_element(:xpath, 'td[6]')
    workexperiences = col.text
    workexperiences.split("●").each do |item|
        #print "item:#{item}\n"
    end
# 会員番号、年齢、年収
    otf.print "#{member_id},#{age},#{income}\n"
end
# Chromeを呼び出す
driver = Selenium::WebDriver.for :chrome

# 全画面表示
# driver.manage().window().maximize()

# Googleに移動
driver.get "file:///G:/pg/ruby/scraper/hriku2.html"

# ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 5)
sleep 3
# ページ情報
code = driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[1]/div[2]/div[1]').text
# 表示範囲 (開始 ～ 終了 / 全件数) から取得
if code.match /(\d+)[^\d]+(\d+)[^\d]+(\d+)[^\d]+/ 
    row_st, row_en, row_max = $1, $2, $3
    printf "row_st=#{row_st} row_en=#{row_en} row_max=#{row_max}\n"
end
otf = File.open("test.txt", "w")
for i in 1..50 do
    # 1行
    row = driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[2]/table/tbody/tr['+i.to_s+']')
    get_memberinfo(otf,row)
end
otf.close
##File.open("hriku02.html", "w") do |f| 
#    f.puts driver.page_source
#end
#driver.close
