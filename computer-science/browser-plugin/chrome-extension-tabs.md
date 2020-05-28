# Chrome Extension Tabs


wp_id: 501
Status: publish
Date: 2017-06-12 14:36:00
Modified: 2017-06-12 14:36:00


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