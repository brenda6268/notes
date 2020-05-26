# vimscript 基础教程


ID: 733
Status: draft
Date: 2017-07-25 23:34:00
Modified: 2020-05-16 11:46:16


* use `echom` to save printed messages, you can use `messages` later to retrive them

* All boolean options work this way. `:set <name>` turns the option on and `:set no<name>` turns it off.

* There are a number of ways to exit insert mode in Vim by default:

```
&lt;esc&gt;
&lt;c-c&gt;
&lt;c-[&gt;
```

# autocommands

```
 autocmd BufNewFile * :write
         ^          ^ ^
         |          | |
         |          | The command to run.
         |          |
         |          A &quot;pattern&quot; to filter the event.
         |
         The &quot;event&quot; to watch for.
```

A common idiom in Vim scripting is to pair the BufRead and BufNewFile events together to run a command whenever you open a certain kind of file, regardless of whether it happens to exist already or not.

examples:

`autocmd BufWritePre,BufRead *.html :normal gg=G`  reindent html files

`autocmd BufNewFile,BufRead *.html setlocal nowrap`  set html files to nowrap

`:autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
:autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>` map `<leader>c` to comment out the line