# Python 中的异常总结

<!--
ID: 66eba0b8-b37f-4028-a285-e2b0f430c157
Status: publish
Date: 2017-05-30T03:01:00
Modified: 2020-05-16T11:58:03
wp_id: 675
-->

## User defined class

for user defined exceptions, just subclass Exception

## Catching Exceptions

```
except Exception as e: # SystemExit, KeyboardInterrupt, GeneratorExit is not captured
    log("Reason", e)    # the baseline is to record
```

## 容易抛出异常的地方

* 网络读取，requests.get
* 调用其他命令超时，subprocess.call
* 读取他人的数据，IndexError

### 容易阻塞的地方

网络


## 内置的异常树

```
BaseException
 +-- SystemExit
 +-- *KeyboardInterrupt*
 +-- GeneratorExit
 +-- Exception
      +-- *StopIteration*
      +-- *StandardError*
      |    +-- BufferError
      |    +-- *ArithmeticError*
      |    |    +-- FloatingPointError
      |    |    +-- OverflowError
      |    |    +-- ZeroDivisionError
      |    +-- AssertionError
      |    +-- AttributeError
      |    +-- EnvironmentError
      |    |    +-- *IOError*
      |    |    +-- OSError
      |    |         +-- WindowsError (Windows)
      |    |         +-- VMSError (VMS)
      |    +-- EOFError
      |    +-- *ImportError*
      |    +-- *LookupError*
      |    |    +-- IndexError
      |    |    +-- KeyError
      |    +-- MemoryError
      |    +-- *NameError*
      |    |    +-- UnboundLocalError
      |    +-- ReferenceError
      |    +-- RuntimeError
      |    |    +-- NotImplementedError
      |    +-- *SyntaxError*
      |    |    +-- IndentationError
      |    |         +-- TabError
      |    +-- SystemError
      |    +-- *TypeError*
      |    +-- *ValueError*
      |         +-- UnicodeError
      |              +-- UnicodeDecodeError
      |              +-- UnicodeEncodeError
      |              +-- UnicodeTranslateError
      +-- *Warning*
           +-- DeprecationWarning
           +-- PendingDeprecationWarning
           +-- RuntimeWarning
           +-- SyntaxWarning
           +-- UserWarning
           +-- FutureWarning
	   +-- ImportWarning
	   +-- UnicodeWarning
	   +-- BytesWarning
```