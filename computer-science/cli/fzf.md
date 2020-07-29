# fzf - 命令行模糊查找工具

<!--
ID: eac9b043-5f06-42e4-a109-7646546a9c0f
Status: publish
Date: 2018-04-01T04:38:00
Modified: 2020-05-16T11:31:25
wp_id: 431
-->

# 安装

在 mac 上直接 `brew install fzf` 就好了

# 使用

## 调用 fzf 命令

直接在命令行输入 fzf 开始模糊查找。

查找命令 | 匹配类型 | 说明
------|------------|---------------
sbtrkt|模糊匹配 | 匹配sbtrkt
^music|前缀精确匹配 | 以music开头
.mp3^|后缀精确匹配 | 以.mp3结尾
'wild |精确匹配(quoted) | 精确包含wild
!fire | inverse-exact-match | 不包含fire
!.mp3$ | inverse-suffix-exact-match | 不以.mp3结尾


`|`可以做or匹配， 比如 `^core go$|rb$|py$` 表示以core开头，以go或rb或py结尾的


## 按键

```
ctrl-j/k 或者 ctrl-n/p 或者箭头来上下选择
ctrl-c 或者 Esc 退出
Enter 选择
在多行模式，tab 和 Shift-tab 来标记文件
```

除了这些按键之外，还可以使用 `--bind` 绑定自己的按键，见下文

选中之后，fzf 的默认操作是打印这个文件名，这样我们还得打开，所以可以直接 `vim $(fzf)` 也就是使用 vim 打开我们选中的文件。

## 使用快捷键

```
Ctrl-T 快速选择当前目录文件，并把文件名打印出来
Ctrl-R 使用fzf来过滤history命令
ALT-C cd 进入选中的目录
```

## 自动补全

fzf 支持不少命令的自动补全功能，通过 **<tab> 来触发。如果没有特殊支持某个命令的话，fzf会用文件来补全。

```
vim **<tab>
cd **<tab>
ssh **<tab>  从 /etc/hosts 中读取主机列表
unset **<tab>
export **<tab>
unalias **<tab>

kill -s TERM <tab>
```

这里我把触发按键设置成了 Ctrl-Y 比原生的触发更方便一点，如何配置见下文。


# 选项

```
--height xx% 默认情况下 fzf 占据了 100% 的屏幕
--reverse 提示符在上面
--bind 绑定命令
--preview 指定预览命令
```

默认情况下，在fzf中选中文件之后知识打印出这个文件名，可以使用bind来指定一些快捷键，来对文件的一些操作。

比如：

```
# Press F1 to open the file with less without leaving fzf
# Press CTRL-Y to copy the line to clipboard and aborts fzf (requires pbcopy)
fzf --bind "f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort"
```

默认情况下，fzf 不会预览文件的内容，可以使用 --preview 指定，

```
# Use head instead of cat so that the command doesn"t take too long to finish
fzf --preview "head -100 {}"
```

语法高亮

```
fzf --preview "[[ $(file --mime {}) =~ binary ]] &amp;&amp;
                 echo {} is a binary file ||
                 (highlight -O ansi -l {} ||
                  coderay {} ||
                  rougify {} ||
                  cat {}) 2> /dev/null"
```

## 相关的环境变量

默认情况下，fzf 从 `find * -type f` 中读取文件列表，可以使用更好用的 fd 来替换。

```
export FZF_DEFAULT_OPTS="--height 40% --reverse --border" 这个变量来指定默认选项。
export FZF_DEFAULT_COMMAND="fd --type f" 来指定
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

##  我的最终配置

```
[ -f ~/.fzf.zsh ] &amp;&amp; source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_COMPLETION_TRIGGER=""
export FZF_DEFAULT_OPTS="--height 40% --reverse --border --prompt ">>>" \
    --bind "alt-j:preview-down,alt-k:preview-up,alt-v:execute(vi {})+abort,ctrl-y:execute-silent(cat {} | pbcopy)+abort,?:toggle-preview" \
    --header "A-j/k: preview down/up, A-v: open in vim, C-y: copy, ?: toggle preview" \
    --preview "(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null""
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="--preview "echo {}" --preview-window hidden:wrap --bind "?:toggle-preview""
export FZF_ALT_C_OPTS="--height 40% --reverse --border --prompt ">>>" \
    --bind "alt-j:preview-down,alt-k:preview-up,?:toggle-preview" \
    --header "A-j/k: preview down/up, A-v: open in vim, C-y: copy, ?: toggle preview" \
    --preview "tree -C {}""
bindkey "^Y" fzf-completion
bindkey "^I" $fzf_default_completion
[ -f ~/.dotfiles/lib/fzf-extras.sh ] &amp;&amp; source ~/.dotfiles/lib/fzf-extras.sh
```