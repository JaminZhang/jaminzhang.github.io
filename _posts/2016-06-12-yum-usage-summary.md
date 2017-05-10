---
layout: post
title: yum 用法总结
description: "yum 用法总结"
category: Linux
avatarimg: 
tags: [Linux, Yum]
duoshuo: true
---

# 引言

经常碰到要查询某个命令属于什么软件包，比如这几天部署 smokeping 时遇到不知道 dig 命令是属于什么软件包。  
使用`yum provides`选项参数 即可查询。  
再比如只知道软件包部分关键字，想搜索对应软件包全称，这是可以使用`yum search all KEYWORDS`来搜索  
yum 使用的还是比较频繁的，所以这里准备不断总结 yum 在实际工作中常用的选项参数。


# 1 yum provides

```bash 
provides       Find what package provides the given value
```   

查找有什么软件包能提供给定的值

例子：比如查询什么软件包提供 dig 命令

```bash

[root@linux-node1 ~]# yum provides dig

32:bind-utils-9.9.4-29.el7_2.3.x86_64 : Utilities for querying DNS name servers
Repo        : updates
Matched from:
Filename    : /usr/bin/dig

```   
# 2 yum remove

从系统中移除一个软件包，其实最起初的命令应该是 erase，remove 是 erase 的一个别名。

<pre>

erase PACKAGE...

Remove a package or packages from your system

aliases: remove, autoremove, erase-n, erase-na, erase-nevra, autoremove-n, autoremove-na, 
autoremove-nevra, remove-n, remove-na, remove-nevra

</pre>

今天碰到一个情况就是，通过 yum remove 卸载方式安装的 Nginx 时，  
`/var/log, /var/cache` 等目录中还有残留，其实我的原意是想完全卸载一个软件。  
如这位朋友的情况：[Linux 中如何完全卸载一个软件(如 CentOS)](https://segmentfault.com/q/1010000002578813)  
里面的回答我还是比较同意的（现暂时不纠结完全卸载一个软件）。

<pre>

yum remove 的话貌似已经把所有的依赖都删除了。
所以剩下的只有两部分：
缓存（cache）和日志（log）。

日志是不会自动删除的，因为第一工作量太大，各种软件的日志目录都能自定义，没办法完全删除，
另一个就是因为日志记录了几乎所有的东西，错误，警告，硬件错误，访问记录等。

一般的服务器日志都不会删除，
（装了桌面的话，X.org.log 除外）
甚至还有专门的日志切割软件 logrotate 来进行日志分割方便备份和查询。

</pre>


# Ref
yum --help  
[Linux 中如何完全卸载一个软件(如 CentOS)](https://segmentfault.com/q/1010000002578813)  
