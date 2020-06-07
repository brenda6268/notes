# m4 tool


wp_id: 422
Status: publish
Date: 2017-05-30 12:57:00
Modified: 2017-05-30 12:57:00


m4 macro language  http://mbreen.com/m4.html

comman line invoking
------

m4 -D<MACRO>

builtins
------

define(<macro>, <value>)
undefine(<macaro>)
ifdef(<macro>, <then>, <else>)
ifelse(<a>, <b>, <then>, <else>)
eval(<expr>)
len(<str>)
include(<filename>)
syscmd(<cmd>)
`'are quotes
# for comments

M4 rules
    it reads in the macro's arguments (if any)
    it determines the expansion of the macro and inserts this expansion at the beginning of its input
    m4 continues scanning the input, starting with the expansion 

example:
  define(`definenum', `define(`num', `99')')
  num                      # -> num
  definenum num            # -> define(`num', `99') num ->  99

 Unless a nested macro is quoted, it is expanded immediately:

  define(`definenum', define(`num', `99'))
  num                      # -> 99
  definenum                # ->