# Chrome extension cookies


wp_id: 724
Status: publish
Date: 2017-06-12 08:01:00
Modified: 2017-06-12 08:01:00


## permissions

set the cookies permission and the domain you would like to access cookies.

```
"permissions": {
    "cookies",
    "*://*.example.com/"
}
```

## type
### cookie
just a simple object with `{name, value, domain...}`

### CookieStore
normal mode and incognito mode use different cookie stores.

## read

get: `chrome.cookies.get({url: URL, name: COOKIE_NAME, storeId: COOKIE_STORE_ID}, function(cookie) {})`

get all: `chrome.cookies.get({domain: DOMAIN}, function(cookies) {})` NOTE: there are other filters not listed here.

set: `chrome.cookies.set({url, name, value}, function(cookie) {})` if failed, the callback gets null