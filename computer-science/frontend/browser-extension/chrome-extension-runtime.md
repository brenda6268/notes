# Chrome Extension runtime

<!--
ID: 0b526fdc-d820-4fcd-bf09-a750f795d693
Status: publish
Date: 2017-06-12T15:00:00
Modified: 2017-06-12T15:00:00
wp_id: 717
-->

## basic usage

```js
chrome.runtime.getBackgroundPage(function(window) {})  // retrive the background page's window object
```

```js
chrome.runtime.getURL(path)  // get the absolute url for given file in extension package
```