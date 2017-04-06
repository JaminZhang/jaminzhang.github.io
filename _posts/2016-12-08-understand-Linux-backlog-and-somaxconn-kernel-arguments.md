---
layout: post
title: 理解 Linux backlog/somaxconn 内核参数 
description: "理解 Linux backlog/somaxconn 内核参数"
category: Linux
avatarimg:
tags: [Linux, TCP, Socket, backlog, somaxconn, ]
duoshuo: true
---

理解 Linux backlog/somaxconn 内核参数 

# 引言

之前[负载均衡超时问题](http://jaminzhang.github.io/lb/LB-Timeout-Problem/)这篇博文中提到一个可能原因是：  
后端服务器 Socket accept 队列满，系统的 somaxconn 内核参数默认太小。  
下面我们我深入学习理解下 somaxconn 内核参数相关内容。


# TCP SYN_REVD, ESTABELLISHED 状态对应的队列

<pre>

TCP 建立连接时要经过 3 次握手，在客户端向服务器发起连接时，
对于服务器而言，一个完整的连接建立过程，服务器会经历 2 种 TCP 状态：SYN_REVD, ESTABELLISHED。

对应也会维护两个队列：
1. 一个存放 SYN 的队列（半连接队列）
2. 一个存放已经完成连接的队列（全连接队列）

当一个连接的状态是 SYN RECEIVED 时，它会被放在 SYN 队列中。
当它的状态变为 ESTABLISHED 时，它会被转移到另一个队列。
所以后端的应用程序只从已完成的连接的队列中获取请求。


如果一个服务器要处理大量网络连接，且并发性比较高，那么这两个队列长度就非常重要了。
因为，即使服务器的硬件配置非常高，服务器端程序性能很好，
但是这两个队列非常小，那么经常会出现客户端连接不上的现象，
因为这两个队列一旦满了后，很容易丢包，或者连接被复位。
所以，如果服务器并发访问量非常高，那么这两个队列的设置就非常重要了。

</pre>


# Linux backlog 参数意义

<pre>

对于 Linux 而言，基本上任意语言实现的通信框架或服务器程序在构造 socket server 时，都提供了 backlog 这个参数，
因为在监听端口时，都会调用系统底层 API: int listen(int sockfd, int backlog);

listen 函数中 backlog 参数的定义如下：

Now it specifies the queue length for completely established sockets waiting to be accepted,
instead of the number of incomplete connection requests. 
The maximum length of the queue for incomplete sockets can be set using the tcp_max_syn_backlog sysctl. 
When syncookies are enabled there is no logical maximum length and this sysctl setting is ignored.
If the socket is of type AF_INET, and the backlog argument is greater than the constant SOMAXCONN(128 default), 
it is silently truncated to SOMAXCONN.


backlog 参数描述的是服务器端 TCP ESTABELLISHED 状态对应的全连接队列长度。

全连接队列长度如何计算？
如果 backlog 大于内核参数 net.core.somaxconn，则以 net.core.somaxconn 为准，
即全连接队列长度 = min(backlog, 内核参数 net.core.somaxconn)，net.core.somaxconn 默认为 128。
这个很好理解，net.core.somaxconn 定义了系统级别的全连接队列最大长度，
backlog 只是应用层传入的参数，不可能超过内核参数，所以 backlog 必须小于等于 net.core.somaxconn。


半连接队列长度如何计算？
半连接队列长度由内核参数 tcp_max_syn_backlog 决定，
当使用 SYN Cookie 时（就是内核参数 net.ipv4.tcp_syncookies = 1），这个参数无效，
半连接队列的最大长度为 backlog、内核参数 net.core.somaxconn、内核参数 tcp_max_syn_backlog 的最小值。
即半连接队列长度 = min(backlog, 内核参数 net.core.somaxconn，内核参数 tcp_max_syn_backlog)。
这个公式实际上规定半连接队列长度不能超过全连接队列长度。


其实，对于 Nginx/Tomcat 等这种 Web 服务器，都提供了 backlog 参数设置入口，
当然它们都会有默认值，通常这个默认值都不会太大（包括内核默认的半连接队列和全连接队列长度）。
如果应用并发访问非常高，只增大应用层 backlog 是没有意义的，因为可能内核参数关于连接队列设置的都很小，
一定要综合应用层 backlog 和内核参数一起看，通过公式很容易调整出正确的设置。

</pre>


# Ref
[关于 backlog 和相关内核参数](http://www.jameswxx.com/%E7%B3%BB%E7%BB%9F%E5%9F%BA%E7%A1%80/%E5%85%B3%E4%BA%8Ebacklog/)  
[随手记之 Linux 内核 backlog 笔记](http://www.blogjava.net/yongboy/archive/2014/07/30/416373.html)  
[关于 somaxconn 参数](https://www.4os.org/index.php/2010/10/15/%E5%85%B3%E4%BA%8Enet-core-somaxconn%E5%8F%82%E6%95%B0/)  
