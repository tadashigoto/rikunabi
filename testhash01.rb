hash1 = {}
hash1[:income] = 10000
hash1[:name] ="後藤正\n"
print hash1["name"]
p hash1.size
hash1.each do |k,v|
    print "#{k}:#{v}\n"
end