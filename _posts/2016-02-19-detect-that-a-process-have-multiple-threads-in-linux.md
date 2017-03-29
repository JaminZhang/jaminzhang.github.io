---
layout: post
title: Linux 下多线程进程的检测方法
description: "Linux 下多线程进程的检测方法"
category: Linux
avatarimg:
tags: [Linux, Thread]
duoshuo: true
---

# 引言

之前说到在 Linux 下使用 prozilla 进行下载加速，
其中一个原因就是 prozilla 是多线程程序，可以同时打开多个连接，而 wget 不是一个多线程的程序。  
我多想了一下，那怎么判断一个程序进程是单线程还是多线程的？

# 根据 /proc/PID/task 下子目录个数来判断一个程序进程是否是多线程

下面来进行测试验证下：

1、使用 wget 下载一个文件，相关输出如下：

```bash

[root@iZ25p102vo3Z ~]# ps -ef | grep wget
root     31644 31570  0 15:10 pts/0    00:00:00 wget --limit-rate=20k http://xxx.xx
root     31646 31612  0 15:10 pts/2    00:00:00 grep --color=auto wget
[root@iZ25p102vo3Z ~]# ll /proc/31644/task
total 0
dr-xr-xr-x 6 root root 0 Feb 25 15:10 31644

```    

可以看到/proc/31644/task/下只有一个目录，验证了 wget 是一个单线程程序。

2、使用 prozilla 下载一个文件，开启 10 个线程，相关输出如下：  

```bash

[root@iZ25p102vo3Z ~]# ps -ef | grep proz
root     31659 31570  0 15:17 pts/0    00:00:00 proz -k=10 -f --max-bps=102400 http://xxx.xx
root     31686 31612  0 15:18 pts/2    00:00:00 grep --color=auto proz
[root@iZ25p102vo3Z ~]# ll /proc/31659/task/
total 0
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31659
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31667
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31668
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31669
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31670
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31671
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31672
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31673
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31674
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31675
dr-xr-xr-x 6 root root 0 Feb 25 15:18 31676

```    

可以看到`/proc/31659/task/`下有多个目录，验证了 prozilla 是一个多线程程序。

# 使用 ps -efL 命令

# Ref
[Linux: detect at runtime that a process have multiple threads](http://stackoverflow.com/questions/4125898/linux-detect-at-runtime-that-a-process-have-multiple-threads)  

