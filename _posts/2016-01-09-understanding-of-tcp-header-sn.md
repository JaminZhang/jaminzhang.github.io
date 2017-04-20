---
layout: post
title: 理解 TCP 报文头中的序列号
description: "理解 TCP 报文头中的序列号"
category: Network
avatarimg:
tags: [TCP, Header, SN]
duoshuo: true
---

# 引言

看《TCP/IP 详解，卷 1：协议》关于 TCP 首部的序列号解释时，并不是理解的很清楚。  
于是查找另外的资料来看不同表述加强理解。

# TCP 序列号、确认号解释

<pre>

Sequence Number (32 bits): 32 位序列号，有两个作用：
在 SYN flag 置 1 时，此为当前连接的初始序列号（Initial Sequence Number, ISN），数据的第一个字节序号为此 ISN + 1
在 SYN flag 置 0 时，为当前连接报文段的累计数据包字节数。


Acknowledgment number (32 bits): 
32 位确认序号，ACK flag 置 1 时才有效，指接收方期待的下一个报文段的序列号。

</pre>

# 通过实例理解 TCP 序列号、确认号

现在自己还没有抓包分析说明，参照下面他人已经做过的抓包序列号分析说明。

[TCP 序列号和确认号详解](http://www.cnblogs.com/chenboo/archive/2011/12/19/2293327.html)  
[理解 TCP 序列号（Sequence Number）和确认号（Acknowledgment Number）](http://blog.csdn.net/a19881029/article/details/38091243)  

PS:
《TCP/IP 详解，卷 1：协议》18 章中 telnet 实例中，建立一个 TCP 连接并终止连接，
这个例子中没有发送数据，所以三次握手中第三次客户端发送 Ack 包给服务器时，并没有包含数据，这并不是说明，这个包不可以包含数据，
从上面[TCP 序列号和确认号详解]中实例中可以看出三次握手的第三次客户端的 Ack 包中可以包含数据。

# Ref
《TCP/IP详解，卷 1：协议》 第 17、18 章  
[TCP 协议浅析](http://blog.yuanbin.me/posts/2015/03/TCP-Protocal.html)  
[TCP 序列号和确认号详解](http://www.cnblogs.com/chenboo/archive/2011/12/19/2293327.html)  
[理解 TCP 序列号（Sequence Number）和确认号（Acknowledgment Number）](http://blog.csdn.net/a19881029/article/details/38091243)  

