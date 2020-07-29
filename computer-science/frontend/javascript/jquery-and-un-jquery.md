# jQuery and un-jQuery

<!--
ID: 81551b66-fb8c-4f9a-bfeb-1391bbfb69f1
Status: publish
Date: 2017-05-30T13:41:00
Modified: 2017-05-30T13:41:00
wp_id: 511
-->

# jQuery

$el.append(htmlString)
$el.prepend(htmlString)

$newEl.insertBefore(queryString)
$newEl.insertAfter(queryString)

# un-jQuery

## DOM 操作

选择器可以使用 querySelector 和 querySelectorAll, 但是这两个的性能太差了, 最好使用 getElementById, getElementsByTagName, getElementsByClassName

$el.val() 对应 el.value

### 获取 attr
```
$el.attr('id');
el.getAttribute('id);
el.setAttribute(attr, value)
```

### parent and children

```
$el.children
$el.parent()
el.children
el.parentNode
```

### 设置 css

```
$el. css({color: '#000'});
el.style.color = '#000';
$el.css('color');
window.getComputedStyle(el)['color'];
```

特别地
$(el).hide(); // jQuery
el.style.display = 'none'; // native
$(el).show(); // jQuery
el.style.dispaly = ''


### 设置 class

$el.addClass(className) // remove, has, toggle
el.classList.add(className) // remove, contains, toggle

设置text
Get text
// jQuery
$el.text();
// Native
el.textContent;

Set text
// jQuery
$el.text(string);

// Native
el.textContent = string;

## 设置html
Get HTML
// jQuery
$el.html();

// Native
el.innerHTML;
Set HTML
// jQuery
$el.html(htmlString);

// Native
el.innerHTML = htmlString;

## inserting html fragment to document

Have a look at `insertAdjacentHTML`

```
var element = document.getElementById("one");
var newElement = '<div id="two">two</div>'
element.insertAdjacentHTML( 'afterend', newElement )
// new DOM structure: <div id="one">one</div><div id="two">two</div>
position is the position relative to the element you are inserting adjacent to:
```

`beforebegin` Before the element itself

`afterbegin` Just inside the element, before its first child

`beforeend` Just inside the element, after its last child

`afterend` After the element itself


事件

绑定事件 
$el.on(eventName, eventHandler);  // jQuery
el.addEventListener(eventName, eventHandler);  // Native

解绑事件
$el.off(eventName, eventHandler);  // jQuery
el.removeEventListener(eventName, eventHandler);  // Native

触发事件
// 用户事件
$(el).trigger('custom-event', {key1: 'data'});  // jQuery
// Native, note that
const event = new CustomEvent('custom-event', {detail: {key1: 'data'}});
el.dispatchEvent(event);

// 原生事件
$(el).trigger('change');
var ev = new Event("look", {"bubbles":true, "cancelable":false});
document.dispatchEvent(ev);



## ajax

getJSON
jQuery
$.getJSON('/my/url', function(data) {
});
IE9+
var request = new XMLHttpRequest();
request.open('GET', '/my/url', true);
request.onload = function() {
  if (request.status >= 200 && request.status < 400) {
    // Success!
    var data = JSON.parse(request.responseText);
  } else {
    // We reached our target server, but it returned an error
}
};
request.onerror = function() {
  // There was a connection error of some sort
};
request.send();
Post
jQuery
$.ajax({
  type: 'POST',
  url: '/my/url',
  data: data
});
IE8+
var request = new XMLHttpRequest();
request.open('POST', '/my/url', true);
request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
request.send(data);
Request
jQuery
$.ajax({
  type: 'GET',
  url: '/my/url',
  success: function(resp) {
},
  error: function() {
}
});
IE9+
var request = new XMLHttpRequest();
request.open('GET', '/my/url', true);
request.onload = function() {
  if (request.status >= 200 && request.status < 400) {
    // Success!
    var resp = request.responseText;
  } else {
    // We reached our target server, but it returned an error
}
};
request.onerror = function() {
  // There was a connection error of some sort
};
request.send();

DOM Ready



https://github.com/oneuijs/You-Dont-Need-jQuery/blob/master/README.zh-CN.md
http://youmightnotneedjquery.com/