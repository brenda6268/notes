# readability.js 源码阅读

<!--
ID: d641c927-f982-4a84-91a1-20dda00aaa13
Status: draft
Date: 2017-08-16T21:40:00
Modified: 2020-05-16T11:50:06
wp_id: 466
-->

Readability is able to fetch paginated page and combine them into one page
 
# by functions
 
## init

1. start the whole process
2. remove event listeners
3. remove scripts
4. find next page
5. prep the document
6. get readability article components
7. get document directions
8. add readability dom to the dom
9. post process
10. scroll to top
11. append next page to the dom
12. add some smooth scrolling function

## parsedPages

stores the parsed pages, key are end-slash-striped

## prepDocument

1. create document.body if not have
2. find the biggest frame (width + height)
3. remove all css
4. remove all style elements
5. replace `<br/><br>` to `</p><p>`
 
## prepArticle
 
1. Prepare the article node for display. Clean out any inline styles, iframes, forms, strip extraneous `<p>` tags, etc.
2. clean styles
3. clean unwanted tags
4. if only have one h2, that must be the title, but we already have title, so remove it
5. remove empty `<p>` s
 
## getArticleTitle
 
1. get document.title or h1
2. normalizing the title
 
## killBreaks
 
replace any break (`<br/>`&nbsp;) by `<br />`
 
## cleanTags
 
1. clean child tags of given element
2. cleanConditionally
 
## getLinkDensity
 
the amount of text that is inside a link divided by the total text in the node. archored text length / all text length
 
## grabArticle
 
main logic for readability, using a variety of metrics (content score, classname, element types), find the content that is most likely to be the stuff a user wants to read. Then return it wrapped up in a div.

## get nodes to score:

1. get all nodes
2. remove unlikely candidates by find specific patterns in classname and id
3. add p, td, pre to nodesToScore
4. Turn all divs that don't have children block level elements into p's, and add it to nodesToScore

## get candidates

1. Loop through all paragraphs, and assign a score to them based on how content-y they look. Then add their score to their parent node.
2. pass `<25` char nodes
3. initialize parent and grand parent nodes ?
4. compute content score
    1. base score 1
    2. add score by comma numbers, note only english comma counted
    3. For every 100 characters in this paragraph, add another point. Up to 3 points.
    4. Add the score to the parent. The grandparent gets half.
 
## getCharCount
 
Get the number of times a string s appears in the node e.
 
## htmlspecialchars
 
replace <>&"' to safe strings
 
## flagisActive/addFlag/removeFlag
 
check/ readability flags

## removeScripts
 
remove all javascripts found one the page
 
## getInnerText
 
trim and squeeze spaces and return the textContent of a node
 
 
## cleanStyles
 
1. clean style attribute recursively

## fixImageFloats
 
1. Some content ends up looking ugly if the image is too large to be floated.  If the image is wider than a threshold (currently 55%), no longer float it, center it instead.
 
## postProcessContent
 
post processing: add footnotes, fix floating images
 
## getArticleTools
 
1. get document.title or h1
2. normalizing the title
 
## getSuggestedDirection
 
## getArticleFooter
 
1. readability tracking script

## addFootNotes
 
add links found in the page as foot notes
 
## useRdbTypekit
 
nothing 
 
xhr
 
xmlhttprequest
 
successfulrequest
 
ajax

## findbaseUrl
 
find the articles base url, normalize and remove the paganation part
only the path part, no query string
 
## findnextpage
 
1. find all links
2. if already seen the link or the link is the page self
3. if on different domain, ignore
4. if match the EXTRANEOUS regex or has a long text, remove it
5. if remove the base url, and have no number in it, remove it
 
ok, the logic is very good, just translate it to python
 
## appendNextPage