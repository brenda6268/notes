# Python pip 和 poetry 极简教程


ID: 638
Status: publish
Date: 2017-05-30 03:04:00
Modified: 2020-05-16 11:58:10


# pip

## installing packages

`pip install <package-name>==<version>`, version is optional

To install a package from git repository:

`pip install -e git+REPO`

pip currently supports cloning over git, git+https and git+ssh, Here are the supported forms:

```
[-e] git+git://git.myproject.org/MyProject#egg=MyProject
[-e] git+https://git.myproject.org/MyProject#egg=MyProject
[-e] git+ssh://git.myproject.org/MyProject#egg=MyProject  # for private repo, you can only use this
[-e] git+git@git.myproject.org:MyProject#egg=MyProject

Passing branch names, a commit hash or a tag name is possible like so:
[-e] git://git.myproject.org/MyProject.git@master#egg=MyProject
[-e] git://git.myproject.org/MyProject.git@v1.0#egg=MyProject
[-e] git://git.myproject.org/MyProject.git@da39a3ee5e6b4b0d3255bfef95601890afd80709#egg=MyProject
```

if you add the `-e`(editable) option, then you can save the version info in freeze, which is exactly what you need.

## upgrade a package:

```
pip install package-name --upgrade
pip install xxx -U
```

## 忽略缓存

```
pip install --on-cache-dir xxx
```

## requirements file

save current dependencies to a requirement file:

pip freeze > requirements.txt

install from a requirement file

pip install -r requirements.txt

http://crazygit.wiseturtles.com/2018/01/08/pipenv-tour/

## 卸载的时候删除所有依赖

可以使用 pip-autoremove 包

```
pip install pip-autoremove
pip-autoremove requrests -y  # requests 有严重的内存泄露，而且代码非常不优雅，强烈建议不要使用。
```

# 让 pip 使用国内的源

* 阿里云 https://mirrors.aliyun.com/pypi/simple/ 
* 中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/ 
* 豆瓣 http://pypi.douban.com/simple/
* 清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/ 
* 中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/

```
pip install flask -i https://pypi.tuna.tsinghua.edu.cn/simple/
```

修改 ~/.pip/pip.conf (没有就创建一个)， 内容如下：

```
[global]
https://pypi.tuna.tsinghua.edu.cn/simple/
```

# poetry




# pipenv

**pipenv 太垃圾了，吹得很牛逼，结果基本不能用。不知道为啥不使用官方的 venv，而要使用 virtualenv。强烈不建议使用。**

