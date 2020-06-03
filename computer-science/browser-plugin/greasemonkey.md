# 学习 greasemonkey 教程


wp_id: 722
Status: publish
Date: 2017-05-29 15:23:00
Modified: 2020-05-16 12:09:56


GreaseMonkey/TamperMonkey 学习

## 头部命令


* @name | 脚本名字|	
* @namespace|命名空间|	
* @version| 版本|	
* @author|作者|		
* @description		
* @homepage		
* @icon		
* @updateURL		
* @downloadURL		
* @include		
* @exclude		
* @resource key url		
* @require	include scripts	
* @connect 	reach cross origin domains	self, current domain, localhost,  or *
* @run-at	when to run the script	document-start/document-body/document-end/document-idle/context-menu
* @grant	whitelist GM_* functions	If no @grant tag is given TM guesses the scripts needs.

## 函数

```js
GM_addStyle(css)		
GM_get/set/deleteValue		
GM_listValues()		
GM_getResourceText(name)		
GM_getResourceURL(name)	get base64 encoded urI	
GM_openInTab(url)		
GM_getTab(cb)	Get a object that is persistent as long as this tab is open.	
GM_getTabs(cb)	Get all tab objects as a hash to communicate with other script instances.	
GM_setClipboard(data, info)	set the clipboard	


GM_xmlhttprequest can do cross domain request

```

using it in $.ajax https://gist.github.com/yifeikong/9e93cc38297cce989ffbef5587ad2f39