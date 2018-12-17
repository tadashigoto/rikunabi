require 'selenium-webdriver'

# Chromeを呼び出す
driver = Selenium::WebDriver.for :chrome

# 全画面表示
driver.manage().window().maximize()

# Googleに移動
driver.get "https://www.google.co.jp/"

# ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 5)

# 検索ボックス探して入力して検索
search_box = driver.find_element(:name, 'q')
search_box.send_keys('YoshinoriN')
search_box.submit()

sleep 5
print driver.page_source
driver.close