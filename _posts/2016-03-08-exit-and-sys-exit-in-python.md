---
layout: post
title: Python中的exit()和sys.exit()
description: "Python中的exit()和sys.exit()"
category: Python
avatarimg:
tags: [exit, Shell]
duoshuo: true
---

# 引言
前几天测试Murder时，当没开启Tracker服务器时，在Peer下执行下载时会有如下报错：

```bash
[root@xxx_game dist]# python /usr/local/murder/dist/murder_client.py peer /data/download/server_1262.zip.torrent /data/download/server_1262.zip x.x.x.x
Problem connecting to tracker - [Errno 111] Connection refused
[root@xxx_game dist]# echo $?
0
```    

从上面可以看出，当在Shell命令行中执行murder_client.py脚本出错后，Shell的$?返回值是0，但我需要在Shell脚本中执行这个脚本，
并判断这个py脚本是否执行成功，因为后续操作的判断会根据这个$?，如果像上面那样出错，返回$?为0，那么后续就会判断python下载成功了，
这可是错误的。  
所以我当前的解决方法是自己在Shell脚本里面加了一个判断，如果python脚本执行后输出结果不会为空，不管提示信息为何，判断python脚本执行
失败，通过Shell脚本返回一个提示信息和错误码，如下：

```bash
result=`python /usr/local/murder/dist/murder_client.py peer ${download_file}.torrent ${download_file} $IP`
if [ -n "$result" ]
then
    echo $result
    echo "Download error, please check."
    exit 66
fi

```    

# Python异常处理分析
为什么上面murder_client.py脚本出错后，Shell的$?还是为0呢？  
是这个py脚本没有对异常进行exit或sys.exit()的处理，而是直接抛出异常了。

根据错误提示，搜索到改错误提示异常处理是在[这个文件](https://github.com/lg/murder/blob/master/dist/BitTornado/BT1/Rerequester.py)中，

截取如下：

```python
err = None
try:
    h = urlopen(t+s)
    closer[0] = h.close
    data = h.read()
except (IOError, error), e:
    err = 'Problem connecting to tracker - ' + str(e)
except:
    err = 'Problem connecting to tracker'
try:
    h.close()
```    

当没开启Tracker服务器时，在Peer上执行murder_client.py，就会出现Tracker拒绝连接的提示，在上面的代码中就对应了
IOError异常，并没有做exit或sys.exit()的处理。

# Python中的exit()和sys.exit()的区别
现在来了解下Python中的exit()和sys.exit()，
> 
exit is a helper for the interactive shell - sys.exit is intended for use in programs.

> 
The site module (which is imported automatically during startup, except if the -S command-line option is given) adds several constants to the built-in namespace (e.g. exit). They are useful for the interactive interpreter shell and should not be used in programs.

> 
Note that there is a third exit option, namely os._exit, which exits without calling cleanup handlers, flushing stdio buffers, etc. (and which should normally only be used in the child process after a fork()).

上面的意思是exit用于给交互式Shell返回值，而sys.exit是用于程序内部。


* exit()/quit(), 跑出SystemExit异常. 一般在交互式shell中退出时使用.
* sys.exit(n) 退出程序引发SystemExit异常, 可以捕获异常执行些清理工作. n默认值为0, 表示正常退出. 其他都是非正常退出. 还可以sys.exit("sorry, goodbye!"); 一般主程序中使用此退出.
* os._exit(n), 直接退出, 不抛异常, 不执行相关清理工作. 常用在子进程的退出.

# Ref
[The difference between exit() and sys.exit() in Python?](http://stackoverflow.com/questions/6501121/the-difference-between-exit-and-sys-exit-in-python)  
[Exit codes in Python](http://stackoverflow.com/questions/285289/exit-codes-in-python)  
[sys.exit](https://docs.python.org/2/library/sys.html#sys.exit)  
[python 中 os._exit()， sys.exit()， exit() 的区别是什么](https://www.zhihu.com/question/21187839)  
[错误和异常](http://www.pythondoc.com/pythontutorial3/errors.html)   


