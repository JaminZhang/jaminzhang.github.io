---
layout: post
title: 内核 segfault 报错分析
description: "内核 segfault 报错分析"
category: Linux
avatarimg:
tags: [Linux, Kernel, Segfault, Node.js]
duoshuo: true
---

# 引言

今天收到 Kibana 端口不通的报警。
登录服务器查看相关日志。Kibana 本身的日志中找不出相关信息。  
但在系统日志中有如下信息。  
`kernel: node[18332]: segfault at 21c75b5b81a8 ip 0000000000bed25e sp 00007ffffa36b990 error 4 in node[400000+1383000]`
于是我们来看看这段报错信息的含义。

# 内核 segfault 信息分析

上面的信息一般都是由内核内存访问越界造成的，不管是用户态程序还是内核态程序访问越界都会出 core dump，并在系统日志里面输出一条这样的信息。

这条信息的前面分别是访问越界的程序名，进程 ID 号,访问越界的地址以及当时进程进程堆栈地址等信息，比较有用的信息是最后的 error number。
在上面的信息中，error number 是 4。

下面详细介绍一下 error number 的信息：

在上面的信息中，error number 是 4，转成二进制就是 100，即 bit2 = 1,bit1 = 0,bit0 = 0
error number 是由 3 个字位组成的，从高到低分别是 bit2、bit1、bit0，所以它的取值范围是 0-7

* bit2: 值为 1 时表示是用户态程序内存访问越界，值为 0 时表示是内核态程序内存访问越界
* bit1: 值为 1 时表示是写操作导致内存访问越界，值为 0 时表示是读操作导致内存访问越界
* bit0: 值为 1 表示没有足够的权限访问非法地址的内容，
      值为 0 时表示访问的非法地址根本没有对应的页面，也就是无效地址。

所以 error 4 就表示用户态程序 Node.js 进行读操作时访问的地址无效。	  

有些遇到这种情况的 Kibana 用户说是他们使用的内核有 bug。  
我这边暂时还没办法确认，先关注下。

**附：段错误 segfault 是什么**  
段错误是指访问的内存超出了系统给这个程序所设定的内存空间，
例如访问了不存在的内存地址，访问了系统保护的内存地址，访问了只读的内存地址等等情况。

# Ref
[nginx错误日志出现worker process 24939 exited on signal 11 (core dumped)](http://blog.csdn.net/hexuan1/article/details/45222867)　  
[内核的 segfault at XXX rip XXX rsp XXX error 4 错误](http://chenwenming.blog.51cto.com/327092/1322103)   
[kernel: httpd[6430]: segfault at* rsp * error 6](http://hzcsky.blog.51cto.com/1560073/642681)    
