# Chrome Extension Tabs

<!--
ID: 554278dc-8028-4b92-84ad-8e7efe31315e
Status: publish
Date: 2017-06-12T14:36:00
Modified: 2017-06-12T14:36:00
wp_id: 501
-->

# permissions

```
permissions: [
    "tabs",
]
```

# usage

## chrome.tabs.query to get current tab

```
chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {});  // tabs[0] would be the current tab
```

## create new tab

```
chrome.tabs.create({url: URL}, function(tab) {})
```

## kill tab
```
chrome.tabs.remove(tabId or [tabId], function() {})
```
