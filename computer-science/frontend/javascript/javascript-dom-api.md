# JavaScript DOM API

<!--
ID: 1e3e675c-0800-4917-93ec-891def0eac3a
Status: publish
Date: 2017-05-30T09:45:00
Modified: 2017-05-30T09:45:00
wp_id: 503
-->

## document object

attributes of document object

```
document.title               //设置文档标题等价于HTML的<title>标签
document.URL                 //设置URL属性从而在同一窗口打开另一网页
document.fileCreatedDate     //文件建立日期，只读属性
document.fileModifiedDate    //文件修改日期，只读属性
document.fileSize            //文件大小，只读属性
document.cookie              //设置和读出cookie
document.charset             //设置字符集 简体中文:gb2312
document.body         // body 元素
document.location.hash/host/href/port          // location
```

methods of document object

```
getElementById() // 返回一个 Element
getElementsByName() // 根据 name 属性获得元素, 返回一个 NodeList
getElementsByTagName() // 返回一个 HTMLCollection/NodeList(Webkit)
getElementsByClassName() // 返回一个 HTMLCollection
querySelector() // 返回一个符合的元素, 性能很差
querySelectorAll() // 返回所有符合的元素组成的 NodeList, 性能很差
document.write()
document.createElement()
```

## window object

### functions in window object

```
setTimeout(func, milliseconds, parameters...)
setInterval(func, milliseconds, parameters...)
```
NOTE: javascript is asynchonous, even if you set 0 timeout, the function is just put into the execute queue, not invoked immediately.

### window.location

```
location	setting location will cause the page to redirect to new page
location.href	
location.protocol	
location.host	
location.hostname	
location.port	
location.pathname	
location.search	
location.hash	
location.assign()	 go to a new address
location.replace()	 go to a new address and do not disturb the history
location.reload()	reload the page
```

### window.history

```
history.back()	
history.forward()	
history.go(number)	
```

### window.screen

window.screen.width	screen width, not the viewport width
window.screen.height	screen height

### alert, confirm and prompt

alert	show a message
confirm	return a bool by user action
prompt	

## Same Origin Policy

document.domain is the key to decide the origin of a script.

scripts under different subdomain can set the their document.domain to a same domain, and then then can share the same cookie or communicate

Cross-Origin Resource Sharing