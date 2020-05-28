# Chrome Extension 存储


wp_id: 723
Status: publish
Date: 2017-06-12 13:30:00
Modified: 2017-06-12 13:30:00


## Basic Concepts

there are 3 storage area for chrome, `sync`, `local`, `managed` areas. the `sync` area will be synced with the cloud. managed area is read-only.

all your extension scripts share the same storage, including content scripts, they don't belong to their domain's localStorage.

## Usage

```
chrome.storage.local.get('key', function(data) {});
chrome.storage.local.get(["KEY1", "KEY2"], function(data) {});

chrome.storage.local.set(data, function() {});  // data is key-value pair to store

chrome.storage.local.remove('key', function() {});
chroem.storage.local.remove(["KEY1", "KEY2"], function() {});
chrome.storage.local.clear(function() {});
```

## Events