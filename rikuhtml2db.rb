# coding: utf-8
require 'nokogiri'
###
# 求職者毎の情報を取得する
###
def get_memberinfo(doc)
    hashes = []
    row_st,row_en,row_max=get_pageinfo(doc)
    print "row_st:#{row_st},row_en:#{row_en},row_max:#{row_max}\n"
    # 画面にある全求職者情報を取得しrowsテーブルにセット
    rows = doc.xpath('//*[@id="main"]/div/div[1]/div[2]/div[2]/div[2]/table/tbody/tr') #全求職者
    rows.each_with_index do |row,i|
        hash = Hash.new
        # 2列:メンバー情報
        col = row.xpath('td[2]')
        # 0.アプローチ
        approach = col.xpath('div[1]').inner_text
        #print "approach:#{approach}\n"
        hash[:approach]=approach
        # 1.アクセス日
        access_dt = col.xpath('ul/li[1]').inner_text
        #print "access_dt:#{access_dt}\n"
        hash[:access_dt]=access_dt
        # 2. 会員番号
        member_id = $1 if col.xpath('ul/li[2]').inner_text.match /(\d+)/
        #print "member_id:#{member_id}\n"
        hash[:member_id]=member_id
        # 3.年齢 / 在住
        age_g = col.xpath('ul/li[3]').inner_text
        #print "age_g:#{age_g}\n"
        age, resident = $1, $2 if age_g.match /(\d+)[^\d\/]+[\s\/]*(\S+)/
        #print "age:#{age} "
        hash[:age]=age
        resident.sub!("在住","")
        #print "resident:#{resident}\n"
        hash[:resident]=resident
        # 4.年収
        income = col.xpath('ul/li[4]').inner_text
        income.gsub!("年収","").gsub!("万円","")
        #print "income:#{income}\n"
        hash[:income]=income
    # 3列:学歴情報
        col = row.xpath('td[3]')
        educations = col.text.split("●")
        educations.each do |item|
            #print "item:#{item}\n"
        end
        hash[:educations]=educations
    # 4列:職歴情報
        col = row.xpath('td[4]')
        works = col.text
        works.split("●").each do |item|
            #print "item1:#{item}\n"
        end
        hash[:works]=works
    # 5列:スキル情報
        col = row.xpath('td[5]')
        skills = col.text
        skills.split("●").each do |item|
            #print "item2:#{item}\n"
        end
        hash[:skills]=skills
    # 6列:経験業務情報
        col = row.xpath('td[6]')
        workexperiences = col.text
        workexperiences.split("●").each do |item|
            #print "item3:#{item}\n"
        end
        hash[:workexperiences]=workexperiences
    # 会員番号、年齢、年収
        #otf.print "#{member_id},#{age},#{income}\n"
        hashes << hash
    end
    return hashes
end
###
# ページ情報取得 開始、終了、全件数
###
def get_pageinfo(doc)
    code = doc.xpath('//*[@id="main"]/div/div[1]/div[2]/div[2]/div[1]/div[2]/div[1]').inner_text
    # 表示範囲 (開始 ～ 終了 / 全件数) から取得
    return $1.to_i,$2.to_i, $3.to_i if code.match /(\d+)[^\d]+(\d+)[^\d]+(\d+)[^\d]+/ 
end

#
f = File.open "dat/hriku1.html"
doc = Nokogiri::HTML.parse(f.read, nil, "utf-8")
# ページ情報
#otf = File.open("test.csv", "w")
    # 気になる1ページ毎 
    hashes = get_memberinfo(doc)
    hashes.each do |hash|
        print "member_id:#{hash[:member_id]},"
        print "age:#{hash[:age]},"
        print "income:#{hash[:income]}\n"
    end
#otf.close
