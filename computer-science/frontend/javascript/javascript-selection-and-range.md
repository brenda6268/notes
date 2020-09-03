# JavaScript Selection and Range

<!--
ID: cdaa7110-4db4-45ea-a55c-437091223798
Status: publish
Date: 2017-06-08T09:40:00
Modified: 2017-06-08T09:40:00
wp_id: 506
-->

# basics
`window.getSelection` and `document.getSelection` all returns the `Selection` object, the selection object is almost useless.

`window.getSelection.getRangeAt(0)` returns a Range object. for history reasons, there is only one range in each selection.

`rangeAncestor = range.commonAncestorContainer;` commonAncestorContainer is the common ancestor of the range elements.
