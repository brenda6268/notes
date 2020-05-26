# Python Argparse 库的使用


ID: 651
Status: publish
Date: 2018-04-04 06:23:00
Modified: 2020-05-16 11:34:12


## 基本用法

```
import argparse
parser = argparse.ArgumentParser()
parser.add_argument(&quot;--verbosity&quot;, help=&quot;increase output verbosity&quot;)
args = parser.parse_args()
print(args.verbosity)
```

两种不同的参数模式， `positional`，`optional arguments`，感觉之间的区别有点像 args 和 kwargs

## subcommand

Actually, the argparse module is not ok with subcommand, mannually parse the first command and then pass the rest to argparse

### add_argument 的参数

```
name or flags - Either a name or a list of option strings, e.g. foo or &#x60;-f&#x60;, &#x60;--foo&#x60;.
action - The basic type of action to be taken when this argument is encountered at the command line. store/store_const/store_true/append/count
nargs - The number of command-line arguments that should be consumed. N/?/*/+
const - A constant value required by some action and nargs selections.
default - The value produced if the argument is absent from the command line.
type -	The type to which the command-line argument should be converted.
choices - A container of the allowable values for the argument. a list 
required - Whether or not the command-line option may be omitted (optionals only).
help - A brief description of what the argument does.
metavar - A name for the argument in usage messages.
dest - The name of the attribute to be added to the object returned by parse_args().
```