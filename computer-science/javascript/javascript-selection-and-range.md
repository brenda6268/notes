# JavaScript Selection and Range


ID: 506
Status: publish
Date: 2017-06-08 09:40:00
Modified: 2017-06-08 09:40:00


# basics
`window.getSelection` and `document.getSelection` all returns the `Selection` object, the selection object is almost useless.

`window.getSelection.getRangeAt(0)` returns a Range object. for history reasons, there is only one range in each selection.

`rangeAncestor = range.commonAncestorContainer;` commonAncestorContainer is the common ancestor of the range elements.