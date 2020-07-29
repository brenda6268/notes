# Git 使用技巧

<!--
ID: df93a184-93e1-452d-9ea5-26292d0addd4
Status: publish
Date: 2017-06-05T10:30:00
Modified: 2020-05-16T12:06:02
wp_id: 438
-->

# 最佳实践

每次提交前都使用 `git status` 查看已经更改的文件，然后使用 `git add` 逐条添加文件,然后再看 `git status` 提交的文件是不是都对的. 认真编写 `.gitignore` 文件，最好能够做到每次可以使用 `git add .` 是安全的。

https://stackoverflow.com/questions/9339429/what-does-cherry-picking-a-commit-with-git-mean 从其他分支读取单个文件

```
git co branch -p
```

本来我以为是 `git cherry-pick`，但是显然 cherry-pick 和我想的不一样 Push 到远端不同名字的分支

```
git push origin local-name:remote-name
```

https://github.com/jiffyclub/blog-posts/blob/master/git-pushing-to-a-remote-branch-with-a-different-name.md

# 取消与重置

当你的 commit 已经 push 之后就不能再撤销了，只能使用 revert。

## 取消上一个 commit

```
git reset HEAD~1
```

* reset --mixed will reset the index not the working dir
* reset --soft will only move the HEAD
* reset --hard will even reset the working dir

## 删掉第一个 commit

```
git update-ref -d HEAD
```

## 重置到origin库中的 HEAD

首先，保存到一个分支

```
git commit -a -m "Saving my work, just in case"
git branch my-saved-work
```

然后，把master分支重置到 origin/master
```
git fetch origin
git reset --hard origin/master
```

## 从 staging area 中删除文件

```
git reset HEAD <file>  // remove a file from staging area

git reset // to remove all files from staging area
```

git checkout -- <filename>
git fetch origin && git reset --hard origin/master


# push

`git push --tags` 推送 tag 到远端仓库

`git tag tagname commit_id` 给某个commit打上标签

`git checkout tagname` 切换到某个tag


# 使用 git bisect 二分查找问题

use bisect to determine when a bug is introduced by specifying a start point and a end point, and doing a binary search between the commits.

```
git bisect start
git bisect good xxxxxx
git bisect bad xxxxxx
# begin binary search
run test and mark commits
git bisect good/bad
# end of binary search
# git will prompt a first bad commits
# you can use git log to visualize the process
git bisect reset
```

# 分支与合并



```
git push -u origin master
git checkout -b branch_name # create new branch
git checkout master # switch back
git branch -d branch_name # delete branch
git push origin --delete branch_name # delete remote branch
git push origin branch_name # push to remote
git branch branch -v xxxxxx
git merge branch_name # merge branch_name to current branch
git merge --squash
git merge --abort  # 放弃合并
```

当第一次推送某个分支的时候，需要使用 `--set-upstream/-u` 来制定要同步的分支。

为了使commit记录清晰易懂，不产生无谓的commit，应该尽量避免和远程分支合并。每次提交尽量使用pull --rebase，而不是pull and merge。

```
git pull --rebase  # 如果有冲突的话，先运行 git stash
git stash # if you and remote change the same file
git stash pop  # pull 之后再 stash pop
git commit -am "some change"
git push
```

## rebase

Once you understand what rebasing is, the most important thing to learn is when not to do it. The golden rule of git rebase is to never use it on public branches.

```
git rebase origin/master
```

## rebase vs merge

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fse6aurc89j30im0dhq3d.jpg)

![](https://ws2.sinaimg.cn/large/006tKfTcgy1fse6cbu59sj30h80dnaah.jpg)


# advanced stash

1. git stash save "stash_name"  // save a stash with a name

2. apply by name

```	
[alias]
sshow = "!f() { git stash show stash^{/$*} -p; }; f"
sapply = "!f() { git stash apply stash^{/$*}; }; f"
```
	
use these lines to show and apply stash by name
	
3. git stash -p  // stashes which files you select

git diff 可以跟时间，来查看一段时间内的改动

显示某个文件谁的改动最多：

```
git blame file | sort -b -k 3 # sort by date
```