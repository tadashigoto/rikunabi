require 'selenium-webdriver'

# Chromeを呼び出す
driver = Selenium::WebDriver.for :chrome

# 全画面表示
driver.manage().window().maximize()

# Googleに移動
driver.get "https://saiyo.rikunabi.com/"

# ページロード待機
wait = Selenium::WebDriver::Wait.new(:timeout => 5)

# ログイン
driver.find_element(:name, 'login_nm').send_keys('05275260011638')
driver.find_element(:name, 'pswd').send_keys('carrot_software01')
driver.find_element(:name, 'frmLogin').submit()
sleep 2

# メニューバーはiFrame構成なのでそのframeに視点を移動する
driver.switch_to.frame(driver.find_element(:xpath, '//*[@id="header"]/iframe')) # frame変更
kininaru = driver.find_element(:xpath, "//ul/li[2]/a").click                    # 気になるボタン
sleep 2
path = "dat"
FileUtils.rm_rf(path) # directory削除
for pg in 1..999 do
    # ページ情報
    code = driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[1]/div[2]/div[1]').text
    # 表示範囲 (開始 ～ 終了 / 全件数) から取得
    if code.match /(\d+)[^\d]+(\d+)[^\d]+(\d+)[^\d]+/ 
        row_st, row_en, row_max = $1, $2, $3
        printf "row_st=#{row_st} row_en=#{row_en} row_max=#{row_max}\n"
    end
    FileUtils.mkdir_p(path) unless FileTest.exist?(path) # 存在しないとき保存用htmlディレクトリ作成
    File.open("#{path}/hriku#{pg.to_s}.html", "w") do |f| 
        # charset="shift-jis"を"utf-8"に置換して出力(文字化け対策)
        f.puts driver.page_source.sub(/charset=\"shift-jis\"/,"charset=utf-8")
    end
    break if row_en == row_max #最終ページならループ脱出
    # 次ページボタンクリック
    driver.find_element(:xpath, '//*[@id="main"]/div/div[1]/div[2]/div[2]/div[3]/div[2]/div[11]').click
    sleep 4
end
driver.close
