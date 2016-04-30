---
layout: post
title: Linux pmap
description: "Linux pmap"
category: Linux
avatarimg:
tags: [pmap]
duoshuo: true
---

# 引言
前一篇提到的扩展文章中有使用pmap的例子。
这个命令我之前没有使用过，所以现在来学习下。  

# pmap是什么
man pmap，描述很简单：
> 
The pmap command reports the memory map of a process or processes.

> 
Pmap 提供了进程的内存映射，pmap命令用于显示一个或多个进程的内存状态。其报告进程的地址空间和内存状态信息。Pmap实际上是一个Sun OS上的命令，linux仅支持其有限的功能。但是它还是对查看完整的进程地址空间很有帮助。我们需要PID或者运行的进程的唯一进程ID来查看进程内存状态，我们可以通过/proc或者常规命令比如top或ps得到它。

# pmap使用

## 扩展模式使用

```bash
[root@iZ25p102vo3Z ~]# pmap -x 9173
9173:   /usr/bin/python /usr/bin/ssserver -c /etc/shadowsocks.json -d start
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000000400000       4       4       0 r-x-- python2.7
0000000000600000       4       4       4 r---- python2.7
0000000000601000       4       4       4 rw--- python2.7
0000000002152000    3460    3224    3224 rw---   [ anon ]
00007feae240a000      12       8       0 r-x-- fcntlmodule.so
00007feae240d000    2044       0       0 ----- fcntlmodule.so
00007feae260c000       4       4       4 r---- fcntlmodule.so
00007feae260d000       4       4       4 rw--- fcntlmodule.so
00007feae260e000      12       0       0 r-x-- _randommodule.so
00007feae2611000    2044       0       0 ----- _randommodule.so
00007feae2810000       4       4       4 r---- _randommodule.so
00007feae2811000       4       4       4 rw--- _randommodule.so
00007feae2812000      28       0       0 r-x-- math.so
00007feae2819000    2044       0       0 ----- math.so
00007feae2a18000       4       4       4 r---- math.so
00007feae2a19000       8       8       8 rw--- math.so
00007feae2a1b000      20      12       0 r-x-- selectmodule.so
00007feae2a20000    2044       0       0 ----- selectmodule.so
00007feae2c1f000       4       4       4 r---- selectmodule.so
00007feae2c20000       8       8       8 rw--- selectmodule.so
00007feae2c22000      28       0       0 r-x-- libffi.so.6.0.1
00007feae2c29000    2044       0       0 ----- libffi.so.6.0.1
00007feae2e28000       4       4       4 r---- libffi.so.6.0.1
00007feae2e29000       4       4       4 rw--- libffi.so.6.0.1

```    

以上输出部分截取，这里的Address，Kbyte，Dirty，RSS，mode还有mapping的说明如下：

```bash
Address: 内存开始地址
Kbytes: 占用内存的字节数（KB）
RSS: 保留内存的字节数（KB）
Dirty: 脏页的字节数（包括共享和私有的）（KB）
Mode: 内存的权限：read、write、execute、shared、private (写时复制)
Mapping: 占用内存的文件、或[anon]（分配的内存）、或[stack]（堆栈）
Offset: 文件偏移
Device: 设备名 (major:minor)
```    

# Ref
[Linux Pmap 命令 - 查看进程用了多少内存](https://linux.cn/article-2217-1.html)  
