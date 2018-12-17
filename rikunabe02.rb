require 'selenium-webdriver'

# Chromeを呼び出す
driver = Selenium::WebDriver.for :chrome

# 全画面表示
driver.manage().window().maximize()

# Googleに移動
driver.get "https://saiyo.rikunabi.com/"

# ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 5)

# 検索ボックス探して入力して検索
driver.find_element(:name, 'login_nm').send_keys('05275260011638')
driver.find_element(:name, 'pswd').send_keys('carrot_software01')
driver.find_element(:name, 'frmLogin').submit()
sleep 3

# メニューバーは別のiFrameなのでframeを変更する
driver.switch_to.frame(driver.find_element(:xpath, '//*[@id="header"]/iframe'))
driver.find_element(:xpath, "//ul/li[2]/a").click
sleep 3

# 対象データの件数と現在の表示位置を取得する
code = driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[1]/div[2]/div[1]').text
puts code

prv = driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[3]/div[2]/div[2]')
p prv.enabled?
nxt = driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[3]/div[2]/div[11]')
p nxt.enabled?

# 次ページボタンクリック
driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[3]/div[2]/div[11]').click
sleep 4

driver.close
