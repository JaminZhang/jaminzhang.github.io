---
layout: post
title: Linux ulimit
description: "Linux ulimt"
category: Linux
avatarimg:
tags: [ulimit]
duoshuo: true
---

# 引言
昨天学习Linux core文件中谈到了使用ulimit命令来设置生成的core文件大小。  
今天我们来复习下ulimit命令。

# ulimit简介
> 
Provides  control  over the resources available to the shell and to processes started by it, on systems that allow such control.  The -H and -S options specify that the hard or soft limit is
set for the given resource.  A hard limit cannot be increased by a non-root user once it is set; a soft limit may be increased up to the value of the hard limit.  If neither  -H  nor  -S  is
specified,  both  the  soft  and  hard limits are set.  The value of limit can be a number in the unit specified for the resource or one of the special values hard, soft, or unlimited, which
stand for the current hard limit, the current soft limit, and no limit, respectively.  If limit is omitted, the current value of the soft limit of the resource  is  printed,  unless  the  -H
option is given.  When more than one resource is specified, the limit name and unit are printed before the value.  

ulimit在允许进行资源控制的系统上提供对Shell和它启动的进程的可用资源控制。

>
ulimit 用于限制 shell 启动进程所占用的资源，支持以下各种类型的限制：所创建的内核文件的大小、进程数据块的大小、Shell 进程创建文件的大小、内存锁住的大小、常驻内存集的大小、打开文件描述符的数量、分配堆栈的最大大小、CPU 时间、单个用户的最大线程数、Shell 进程所能使用的最大虚拟内存。同时，它支持硬资源和软资源的限制。
作为临时限制，ulimit 可以作用于通过使用其命令登录的 shell 会话，在会话终止时便结束限制，并不影响于其他 shell 会话。而对于长期的固定限制，ulimit 命令语句又可以被添加到由登录 shell 读取的文件中，作用于特定的 shell 用户。

# ulimit参数
man ulimit

```bash
-a     All current limits are reported
-b     The maximum socket buffer size
-c     The maximum size of core files created
-d     The maximum size of a process's data segment
-e     The maximum scheduling priority ("nice")
-f     The maximum size of files written by the shell and its children
-i     The maximum number of pending signals
-l     The maximum size that may be locked into memory
-m     The maximum resident set size (many systems do not honor this limit)
-n     The maximum number of open file descriptors (most systems do not allow this value to be set)
-p     The pipe size in 512-byte blocks (this may not be set)
-q     The maximum number of bytes in POSIX message queues
-r     The maximum real-time scheduling priority
-s     The maximum stack size
-t     The maximum amount of cpu time in seconds
-u     The maximum number of processes available to a single user
-v     The maximum amount of virtual memory available to the shell and, on some systems, to its children
-x     The maximum number of file locks
-T     The maximum number of threads
```    

# ulimit的使用方式
## 1.在用户的启动脚本中
> 
如果用户使用的是 bash，就可以在用户的目录下的 .bashrc 文件中，加入 ulimit -u 64，来限制用户最多可以使用 64 个进程。此外，可以在与 .bashrc 功能相当的启动脚本中加入 ulimt。

## 2.在应用程序的启动脚本中
如果用户要对某个应用程序 myapp 进行限制，可以写一个简单的脚本 startmyapp。

```bash
ulimit -s 512 
myapp
```    
以后只要通过脚本 startmyapp 来启动应用程序，就可以限制应用程序 myapp 的线程栈大小为 512K。

## 3.直接在控制台输入
这个就是直接在Shell中输入ulimit命令了。

# 针对用户进行资源限制-/etc/security/limits.conf
具体配置请查看此配置文件，写得比较清楚了。

更多实例讲解请参考[通过 ulimit 改善系统性能](http://www.ibm.com/developerworks/cn/linux/l-cn-ulimit/)，这篇写得不错，推荐看看。

# Ref
[通过 ulimit 改善系统性能](http://www.ibm.com/developerworks/cn/linux/l-cn-ulimit/)  
[linux ulimit命令参数及用法详解](http://www.linuxso.com/command/ulimit.html)  
