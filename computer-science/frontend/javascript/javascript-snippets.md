# JavaScript snippets

<!--
ID: a04ab907-c391-4d66-a456-8ada5d2659a6
Status: publish
Date: 2017-06-12T12:31:00
Modified: 2017-06-12T12:31:00
wp_id: 508
-->

## get parameter from url

```js
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}
```
