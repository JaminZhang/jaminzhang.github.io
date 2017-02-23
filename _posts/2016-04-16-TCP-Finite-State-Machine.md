---
layout: post
title: TCP 有限状态机
description: "TCP 有限状态机"
category: Network
avatarimg:
tags: [TCP, FSM, CLOSE_WAIT, TIME_WAIT]
duoshuo: true
---

# 引言

前面一篇文章说了 TCP 建立连接时的 3 次握手和断开连接时的 4 次挥手。  
这个过程中涉及到了 TCP 的各种状态。TCP 协议状态机可以用来定义它们。  

# 有限状态机简介

<pre>

有限状态机（英语：finite-state machine，缩写：FSM）又称有限状态自动机，简称状态机，
是表示有限个状态以及在这些状态之间的转移和动作等行为的数学模型。

有限状态机是一种用来进行对象行为建模的工具，其作用主要是描述对象在它的生命周期内所经历的状态序列，
以及如何响应来自外界的各种事件。

在计算机科学中，有限状态机被广泛用于建模应用行为、硬件电路系统设计、软件工程，
编译器、网络协议、和计算与语言的研究。比如非常有名的 TCP 协议状态机。

</pre>

# TCP 有限状态机示意图

![TCP 有限状态机示意图](http://upload-images.jianshu.io/upload_images/1133568-7a4faa75c260d9b3.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  


# 运维应该重点关注的一些 TCP 状态


## CLOSE_WAIT 

CLOSE_WAIT 状态是被动关闭 TCP 连接的一方在收到对方发送的 FIN 包后并且发送 ACK 包给对方后进入的状态。  
如果服务器处于这种状态的 TCP 连接过多，一般很可能是应用程序没有或不能正常关闭 TCP 连接。  
需要重点关注。


## TIME_WAIT

TIME_WAIT 状态是主动关闭 TCP 连接的一方在收到对方发送的对己方 FIN 的确认 ACK 包，还有对方的 FIN 包，  
然后向对方发送 ACK 包后进入的状态（这之前可能是 FIN_WAIT_1/FIN_WAIT_2/CLOSING 的状态）。

网上很多资料说 TIME_WAIT 状态的连接过多，会占用过多资源。其实这个占用的资源主要是占用了端口资源，CPU/内存的资源占用是比较小的。  

在高并发短连接的 TCP 服务器上，当服务器处理完请求后立刻主动正常关闭连接。  
这个场景下，会出现大量 socket 处于 TIME_WAIT 状态。如果客户端的并发量持续很高，此时部分客户端就会显示连接不上。

### 尽量处理 TIME_WAIT 过多

在 Linux 系统开启如下参数：

```bash
net.ipv4.tcp_timestamps = 1		# 时间戳必须要开启，否则下面的 TIME_WAIT 重用和快速回收无效
net.ipv4.tcp_tw_reuse = 1		# 非对外节点打开（如 LB 后方的内网 Web/DB 等服务可以打开）
net.ipv4.tcp_tw_recycle = 1		# 对外提供服务时（如 LB 不能打开），用户在 NAT 环境下不能打开（因为不同用户时间不同） 
```   

注意开启以上 TIME_WAIT 重用和快速回收适用的情况。

<pre>

应该在连接的发起方使用，而不能在被连接方使用。

举例来说：
客户端向服务端发起 HTTP 请求，服务端响应后主动关闭连接，于是 TIME_WAIT 便留在了服务端，此类情况使用「tcp_tw_reuse」是无效的，
因为服务端是被连接方，所以不存在复用连接一说。
让我们延伸一点来看，比如说服务端是 PHP，它查询另一个 MySQL 服务端，然后主动断开连接，于是 TIME_WAIT 就落在了 PHP 一侧，
此类情况下使用「tcp_tw_reuse」是有效的，因为此时 PHP 相对于 MySQL 而言是客户端，它是连接的发起方，所以可以复用连接。

</pre>


# Ref
[有限状态机](https://zh.wikipedia.org/wiki/%E6%9C%89%E9%99%90%E7%8A%B6%E6%80%81%E6%9C%BA)  
[深入浅出理解有限状态机](http://www.jianshu.com/p/5eb45c64f3e3#	)  
[再叙TIME_WAIT](http://huoding.com/2013/12/31/316)  
[TCP/IP详解--TCP连接中TIME_WAIT状态过多](http://blog.csdn.net/yusiguyuan/article/details/21445883)  

