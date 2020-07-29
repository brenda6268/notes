# tmux cheatsheet

<!--
ID: a10f15b8-d8ad-45e9-81ae-e2a65ebb2b3c
Status: publish
Date: 2018-06-18T00:54:00
Modified: 2019-10-17T13:45:17
wp_id: 755
-->

if you use set mouse off, then you could use system mark and copy, or if you are  in Mac, you could use Option + Mouse Select

# 按键绑定

```
C-b         发送 Ctrl-b 按键
C-z         暂停（suspend） tmux 客户端
```

## 窗口创建与管理

```
!           把当前分区独立出来作为单独的窗口
"           横向分隔，变成上线两个分区
%           纵向分隔，变成左右两个分区
&amp;           关闭当前窗口（window），也就是所有的分区                    
.           Prompt for an index to move the current window.
c           创建一个新窗口
x           关闭当前分区（pane）
{           Swap the current pane with the previous pane.
}           Swap the current pane with the next pane.
C-o         Rotate the panes in the current window forwards.
M-o         Rotate the panes in the current window backwards.
C-Up, C-Down
C-Left, C-Right
            Resize the current pane in steps of one cell.
M-Up, M-Down
M-Left, M-Right
            Resize the current pane in steps of five cells.
M-1 to M-5  Arrange panes in one of the five preset layouts: even-horizontal, even-vertical, main-horizontal, main-vertical, or tiled.
Space       Arrange the current window in the next preset layout.
M-n         Move to the next window with a bell or activity marker.
M-p         Move to the previous window with a bell or activity marker.
```


## copy and paste

```
#           List all paste buffers.
-           Delete the most recently copied buffer of text.
=           Choose which buffer to paste interactively from a list.
[           Enter copy mode to copy text or view the history.
]           Paste the most recently copied buffer of text.
Page Up     Enter copy mode and scroll one page up.
```

## rename

```
$           Rename the current session.
,           Rename the current window.
```

## 选择窗口

```         
"           Prompt for a window index to select.
(           Switch the attached client to the previous session.
)           Switch the attached client to the next session.
0 to 9      Select windows 0 to 9.
l           Move to the previously selected window. remapped to \
n           Change to the next window.
o           Select the next pane in the current window.
p           Change to the previous window.
s           Select a new session for the attached client interactively.
w           Choose the current window interactively.
;           Move to the previously active pane.
```

## 其他

```
:           Enter the tmux command prompt.
?           List all key bindings.
D           Choose a client to detach.
L           Switch the attached client back to the last session.        
d           Detach the current client.
f           Prompt to search for text in open windows.
i           Display some information about the current window.
q           Briefly display pane indexes.
r           Force redraw of the attached client.
m           Mark the current pane (see select-pane -m).
M           Clear the marked pane.
t           Show the time
z           Toggle zoom state of the current pane.
           ~           Show previous messages from tmux, if any.
           
           Up, Down
           Left, Right
                       Change to the pane above, below, to the left, or to the right of the current pane.
```


# dtach

还有一个类似 tmux 的命令 dtach，不过后来没怎么用了，笔记还是留在这里。

`dtach` is used to detach and attach to a session.

`dtach` works with a session file, and can detach and attach to a session, but it has no functionality of terminal multiplexing.

Formula
    dtach [mode] [session_file] [options] [command]

`dtach` modes are `-a` attach, `-A` attach or create, `-c` creates a new session and attach, `-n` creates without attach.