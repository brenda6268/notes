# Python doctest library


ID: 631
Status: publish
Date: 2017-05-30 12:55:00
Modified: 2017-05-30 12:55:00


## basic usage

```
"""
>>> print 'hello'
hello
"""

doctest.testmod()
```

## be verbose

`doctest.testmod(verbose=True)`
or 
`python module.py -v`

## traps

if you have unicode in your docstirng, add u to the doc string

Notes on testing classes
* If it's testing the class as a whole, I'd put them in the class' docstring.
* If it's testing the constructor, I'd put them in the constructor's docstring.
* If it's testing a method (as it seems to be in this case), I'd actually put it them in that method's docstring.