# vim 中生成和使用 tags


ID: 734
Status: publish
Date: 2017-05-30 13:03:00
Modified: 2020-05-16 12:02:21


To use go to definition and other advanced IDE feature, we need to generate tag files for vim to figure out where to find the functions or variables.

To generate a tag file

    ctags -R

By default, the generate tag file will be located at ./tags directory, we need to let vim know where to find it by:

    :set tags+=tags

To search for a symbol in vim, use

    :tag [symbol-name]
    :tag /[search-name]

To go to the definition, we need `Ctrl-]`, to go back, press `Ctrl-t`

    :tn next tag
    :tp prev tag
    :ts all tags

Ref:

[1] http://usevim.com/2013/01/18/tags/


vim tags matchlist is not very user friendly. I should write my own that shows the list in quick fix window

http://vim.1045645.n5.nabble.com/Putting-all-ctags-matches-into-quickfix-td1182150.html

http://vim.1045645.n5.nabble.com/Open-tags-in-quickfix-window-td1188577.html