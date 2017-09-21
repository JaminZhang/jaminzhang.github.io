---
layout: post
title: Python 基础 06-模块
description: "Python 基础 06-模块"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---


# 模块

* 实际上一个 Python 模块是一个 Python 脚本文件。
* 一个 Python 包是一个包含了 Python 脚本文件(至少包含有 `__init__.py` 文件)的目录。
* Python 包中的 `__init__.py` 文件内容可以为空或包含 Python 代码。
* 包可以嵌套，就是对应于文件系统中目录包含子目录。

![Python-Modules](http://jaminzhang.github.io/images/Python/Python-Modules.png)

# 模块导入

* 大型程序包含多个 Python 文件，也就是包含多个模块。
* 文件之间的函数调用可以通过模块导入来实现。
* 文件 A 要使用文件 B 中的函数，需要事先将文件 B 中的函数导入到文件 A 中来，这就是所谓的模块导入。
* 在 Python 中，一个变量名或一个函数名在一个模块中（一个 Python 文件中），要么在这个文件中定义，要么通过其他模块导入过。
也就是说明这个变量名或函数名来自哪里。

## 模块导入规则

模块导入的关键是定位模块，定位规则如下：

1. 跟入口文件在同一个目录下的模块或包能被找到。
2. 根据被导入的模块和当前模块的路径关系来定位导入。

* . 表示在当前模块所在的包下。（当前模块是代码所在的文件）
* .. 表示在当前模块的所在包的外层目录下。

模块导入时，代码会运行一次。再次导入时，不会再次运行。


![Python-Modules-Import](http://jaminzhang.github.io/images/Python/Python-Modules-Import.png)


## Python 2 的导入特性（不推荐）

* import 语句所在模块的"同包模块"（即在同一个目录下 Python 文件）可以直接被找到。

`from input import get_input`

* 了解这个用法，但是不建议使用。（因为不适用于 Python 3 ）


## 模块相关技巧

### dir(模块)

可以查看模块可使用的属性（可能是一个常量或一个函数，本质上是一个变量，内容上是一个常量或函数 ）。

```python

>>> import sys
>>> dir(sys)
['__displayhook__', '__doc__', '__excepthook__', '__name__', '__package__', '__stderr__', '__stdin__', '__stdout__', '_clear_type_cache', '_current_frames', '_getframe', 'api_version', 'argv', 'builtin_module_names', 'byteorder', 'call_tracing', 'callstats', 'copyright', 'displayhook', 'dont_write_bytecode', 'exc_clear', 'exc_info', 'exc_type', 'excepthook', 'exec_prefix', 'executable', 'exit', 'flags', 'float_info', 'getcheckinterval', 'getdefaultencoding', 'getdlopenflags', 'getfilesystemencoding', 'getprofile', 'getrecursionlimit', 'getrefcount', 'getsizeof', 'gettrace', 'hexversion', 'last_type', 'last_value', 'maxint', 'maxsize', 'maxunicode', 'meta_path', 'modules', 'path', 'path_hooks', 'path_importer_cache', 'platform', 'prefix', 'ps1', 'ps2', 'py3kwarning', 'setcheckinterval', 'setdlopenflags', 'setprofile', 'setrecursionlimit', 'settrace', 'stderr', 'stdin', 'stdout', 'subversion', 'version', 'version_info', 'warnoptions']
>>> type(sys.version)
<type 'str'>
>>> type(sys.platform)
<type 'str'>
>>> type(sys.getsizeof)
<type 'builtin_function_or_method'>

```     

### 模块内置变量 `__name__`

* 模块有一个内置变量 `__name__`，Python 内部定义好了，不需要显式定义。  
* 一般情况下其值为相对引用路径，如 "lib.parse"
* 在入口模块中值为 `__main__`

```python

if __name__ == "__main__":  # 如果为此形式，说明这个模块是通过 "python *.py" 运行的，而不是通过模块导入的 
    # do something

```    


