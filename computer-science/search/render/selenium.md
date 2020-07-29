# 安装

<!--
ID: a62c1e57-2604-423c-a777-206f3f2232d9
Status: draft
Date: 2020-05-28T14:15:53
Modified: 2020-05-28T14:15:53
wp_id: 1482
-->

首先需要安装 Google Chrome 和 Chrome Driver，以 Debian 为例：

```
sudo apt-get install 
```

## 查找元素

```python
find_element_by_xpath
find_elements_by_xpath
```

## 等待

```py
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

driver = webdriver.Firefox()
driver.get("http://somedomain/url_that_delays_loading")
try:
    element = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "myDynamicElement"))
    )
finally:
    driver.quit()
```

```
title_is
title_contains
presence_of_element_located
visibility_of_element_located
visibility_of
presence_of_all_elements_located
text_to_be_present_in_element
text_to_be_present_in_element_value
frame_to_be_available_and_switch_to_it
invisibility_of_element_located
element_to_be_clickable
staleness_of
element_to_be_selected
element_located_to_be_selected
element_selection_state_to_be
element_located_selection_state_to_be
alert_is_present
```

# 抛出异常

selenium.common.exceptions.WebDriverException

# cookies

driver.get("http://www.example.com")

# Now set the cookie. This one's valid for the entire domain
cookie = {‘name’ : ‘foo’, ‘value’ : ‘bar’}
driver.add_cookie(cookie)

# And now output all the available cookies for the current URL
driver.get_cookies()

# 代理

可以考虑使用 seleniumwire。seleniumwire 是 selenium 的一个增强版。

# 模拟移动设备

```python
from selenium import webdriver

from selenium.webdriver.chrome.options import Options

# 自定义一种设备的规格
mobile_emulation = {
    "deviceMetrics": { "width": 360, "height": 640, "pixelRatio": 3.0 },
    "userAgent": "Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19" 
}

# 或者直接指定设备名字
mobile_emulation = { "deviceName": "Nexus 5" }

chrome_options = Options()

chrome_options.add_experimental_option("mobileEmulation", mobile_emulation)

driver = webdriver.Chrome(chrome_options = chrome_options)
```

## FAQ

1. https://stackoverflow.com/questions/17082425/running-selenium-webdriver-with-a-proxy-in-python
2. https://github.com/wkeeling/selenium-wire
3. https://chromedriver.chromium.org/mobile-emulation