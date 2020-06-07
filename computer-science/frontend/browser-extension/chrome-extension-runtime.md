# Chrome Extension runtime


wp_id: 717
Status: publish
Date: 2017-06-12 15:00:00
Modified: 2017-06-12 15:00:00


## basic usage

```js
chrome.runtime.getBackgroundPage(function(window) {})  // retrive the background page's window object
```

```js
chrome.runtime.getURL(path)  // get the absolute url for given file in extension package
```