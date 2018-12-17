require 'win32ole'
require 'nokogiri'
ie = WIN32OLE.new("InternetExplorer.Application")
cnt_in=0
require 'csv'

csv_data = CSV.read('2017年8月清算amazon.csv', headers: true)

csv_data.each do |data|
    intro_msg = "#{data["date"]}:#{data["name"]}:#{data["url"]}\n"
    puts intro_msg
end