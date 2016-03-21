---
layout: post
title: Linux进程状态
description: "Linux进程状态"
category: Linux
avatarimg:
tags: [Linux, ps, pkill, pgrep ]
duoshuo: true
---

# 引言
登录某业务海外服务器，查看到一个检查日志的脚本执行了非常多。。。原因初步推测是脚本中的rsync推送数据到国内卡住了。
现在需要批量关闭这些进程。

# ps命令查看进程状态
首先使用ps -ef或ps aux，再加grep过滤出需要关闭的进程，其实也可以使用pgrep（我比较少用，刚才才在man里面发现 ）。
ps命令经常使用，但其命令选项具体含义还没有认真查看man来学习理解下，这次就看看man里面的说明。
<pre>
ps -ef 选项带“-”，是使用的标准语法
This version of ps accepts several kinds of options:
       1   UNIX options, which may be grouped and must be preceded by a dash.
       2   BSD options, which may be grouped and must not be used with a dash.
       3   GNU long options, which are preceded by two dashes.
-e     Select all processes.  Identical to -A.
-f     Do full-format listing. This option can be combined with many other UNIX-style options to add additional columns.  
It also causes the command arguments to be printed.  When used with -L, the
              NLWP (number of threads) and LWP (thread ID) columns will be added.  See the c option, the format keyword args, and the format keyword comm.
-L     Show threads, possibly with LWP and NLWP columns.
-L是显示线程和线程数，之前有写一篇文章写过通过/proc/${PID}/task判断一个程序是否是多线程程序，这里更直接一些。
ps aux 没有以“-”开头，是BSD风格的选项。
然后是进程状态码PROCESS STATE CODES。
我们经常看到的大部分进程状态在Ss，
S    interruptible sleep (waiting for an event to complete)
s    is a session leader
S (task_interruptible): 可中断的睡眠状态
处于这个状态的进程因为等待某某事件的发生（比如等待socket连接、等待信号量），而被挂起。
这些进程的task_struct结构被放入对应事件的等待队列中。当这些事件发生时（由外部中断触发、或由其他进程触发），对应的等待队列中的一个或多个进程将被唤醒。
通过ps命令我们会看到，一般情况下，进程列表中的绝大多数进程都处于task_interruptible状态（除非机器的负载很高）。
毕竟CPU就这么一两个，进程动辄几十上百个，如果不是绝大多数进程都在睡眠，CPU又怎么响应得过来。
会话主要是针对一个终端建立的。session leader是一个会话的领导进程。

</pre>

# 使用pkill批量关闭进程
pkill主要是基于名字来发送信号给相关进程的。

# Ref
man ps pkill pgrep  
[Linux 进程状态 说明](http://blog.csdn.net/tianlesoftware/article/details/6457487)  
[ps 进程查看器](http://linuxtools-rst.readthedocs.org/zh_CN/latest/tool/ps.html)  
[Linux进程关系](http://www.cnblogs.com/vamei/archive/2012/10/07/2713023.html)  
[Linux ps 进程状态码](http://www.cnblogs.com/ziziwu/p/4126955.html)  

