#
# アマゾン購入履歴PDF出力
#
require 'win32ole'
require 'nokogiri'
require 'csv'
ie = WIN32OLE.new("InternetExplorer.Application")
cnt_in = 1

csv_data = CSV.read('2017年8月清算amazon.csv', headers: true)

File.open("./tmp/"+cnt_in.to_s+".html", 'w') do |file|
  csv_data.each do |data|
    cnt_in += 1
    #break if cnt_in > 4
    print "#{data["date"]}:#{data["name"]}:#{data["price"]}:#{data["url"]}\n"
    ie.Navigate data["url"]
    while ie.Busy == true
      sleep 1
    end

    ie.document.getElementsByTagName("html").each do |html|
      # html = Nokogiri::HTML.parse(html0.outerHTML, nil, "CP932") #utf-8
        file.write(html.outerHTML)
    end
  end
end