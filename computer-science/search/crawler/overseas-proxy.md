# 墙外代理池

<!--
ID: 20ef883e-1f1b-45d8-b08e-d56157dcf13c
Status: draft
Date: 2020-08-28T08:06:20
Modified: 2020-08-28T08:06:20
wp_id: 1895
-->

https://github.com/constverum/ProxyBroker/blob/master/proxybroker/providers.py

https://list.proxylistplus.com/SSL-List-1

https://list.proxylistplus.com/Fresh-HTTP-Proxy-List-1


https://cool-proxy.net/
https://github.com/imWildCat/scylla/blob/master/scylla/providers/cool_proxy_provider.py


https://free-proxy-list.net/
https://github.com/imWildCat/scylla/blob/master/scylla/providers/free_proxy_list_provider.py

https://proxyhttp.net/
https://github.com/imWildCat/scylla/blob/master/scylla/providers/http_proxy_provider.py

https://www.ipaddress.com/proxy-list/
https://github.com/imWildCat/scylla/blob/master/scylla/providers/ipaddress_provider.py

http://proxy-list.org/english/index.php
https://github.com/imWildCat/scylla/blob/master/scylla/providers/proxy_list_provider.py

https://raw.githubusercontent.com/sunny9577/proxy-scraper/master/proxies.json
https://github.com/imWildCat/scylla/blob/master/scylla/providers/proxy_scraper_provider.py

http://www.proxylists.net/countries.html
https://github.com/imWildCat/scylla/blob/master/scylla/providers/proxylists_provider.py

https://github.com/imWildCat/scylla/blob/master/scylla/providers/proxynova_provider.py

http://pubproxy.com/api/proxy?limit=5&format=txt&type=http&level=anonymous&last_check=60&no_country=CN

https://github.com/imWildCat/scylla/blob/master/scylla/providers/rmccurdy_provider.py

https://github.com/imWildCat/scylla/blob/master/scylla/providers/spys_me_provider.py

https://github.com/imWildCat/scylla/blob/master/scylla/providers/spys_one_provider.py

https://github.com/imWildCat/scylla/blob/master/scylla/providers/the_speedX_provider.py

https://proxy-daily.com/

http://ab57.ru/downloads/proxyold.txt

http://www.proxylists.net/http.txt

http://www.proxylists.net/http_highanon.txt

http://pubproxy.com/api/proxy?limit=5&format=txt&type=http&level=anonymous&last_check=60&no_country=CN
http://pubproxy.com/api/proxy?limit=5&format=txt&type=http&level=anonymous&last_check=60&country=CN

http://free-proxy.cz/zh/proxylist/country/CN/all/ping/all
https://github.com/phpgao/proxy_pool/blob/master/job/html_cz.go

http://nntime.com/proxy-updated-01.htm
https://github.com/phpgao/proxy_pool/blob/master/job/html_nntime.go

https://premproxy.com/list/time-01.htm
https://github.com/phpgao/proxy_pool/blob/master/job/html_premproxy.go

https://github.com/phpgao/proxy_pool/blob/master/job/html_proxydb.go

https://github.com/phpgao/proxy_pool/blob/master/job/html_site_digger.go

https://github.com/phpgao/proxy_pool/blob/master/job/html_ultraproxies.go

https://github.com/phpgao/proxy_pool/blob/master/job/html_us_proxy.go

https://github.com/phpgao/proxy_pool/blob/master/job/json_cool_proxy.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_aliveproxy.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_blackhat.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_dogdev.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_freeip.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_httptunnel.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_my_proxy.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_newproxy.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_proxy_ip_list.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_proxylist.go

https://github.com/phpgao/proxy_pool/blob/master/job/re_xseo.go

https://github.com/derekhe/ProxyPool/blob/master/lib/proxybroker/providers.py

https://github.com/Jiramew/spoon/blob/master/spoon_server/proxy/listende_provider.py

https://github.com/Jiramew/spoon/blob/master/spoon_server/proxy/nord_provider.py

https://github.com/Jiramew/spoon/blob/master/spoon_server/proxy/pdb_provider.py

https://github.com/Jiramew/spoon/blob/master/spoon_server/proxy/plp_provider.py

https://github.com/Jiramew/spoon/blob/master/spoon_server/proxy/prem_provider.py

https://github.com/Jiramew/spoon/blob/master/spoon_server/proxy/ssl_provider.py

https://github.com/Jiramew/spoon/blob/master/spoon_server/proxy/web_provider.py

https://www.freeproxy.world/

http://proxydb.net/

http://www.xsdaili.cn/

https://github.com/bluet/proxybroker2/blob/master/proxybroker/providers.py


https://github.com/nicksherron/proxi/blob/master/internal/providers.go

    # def freeProxy10():
    #     """
    #     墙外网站 cn-proxy
    #     :return:
    #     """
    #     urls = ['http://cn-proxy.com/', 'http://cn-proxy.com/archives/218']
    #     request = WebRequest()
    #     for url in urls:
    #         r = request.get(url, timeout=10)
    #         proxies = re.findall(r'<td>(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})</td>[\w\W]<td>(\d+)</td>', r.text)
    #         for proxy in proxies:
    #             yield ':'.join(proxy)

    # @staticmethod
    # def freeProxy11():
    #     """
    #     https://proxy-list.org/english/index.php
    #     :return:
    #     """
    #     urls = ['https://proxy-list.org/english/index.php?p=%s' % n for n in range(1, 10)]
    #     request = WebRequest()
    #     import base64
    #     for url in urls:
    #         r = request.get(url, timeout=10)
    #         proxies = re.findall(r"Proxy\('(.*?)'\)", r.text)
    #         for proxy in proxies:
    #             yield base64.b64decode(proxy).decode()

    # @staticmethod
    # def freeProxy12():
    #     urls = ['https://list.proxylistplus.com/Fresh-HTTP-Proxy-List-1']
    #     request = WebRequest()
    #     for url in urls:
    #         r = request.get(url, timeout=10)
    #         proxies = re.findall(r'<td>(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})</td>[\s\S]*?<td>(\d+)</td>', r.text)
    #         for proxy in proxies:
    #             yield ':'.join(proxy)
