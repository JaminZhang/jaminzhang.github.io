---
layout: post
title:  了解 Socket 非阻塞 connect 方法
description: "了解 Socket 非阻塞 connect 方法"
category: Network
avatarimg:
tags: [Linux, Socket, connect, select]
duoshuo: true
---


了解 Socket 非阻塞 connect 方法

# 引言
看到一个关于 Socket 的面试问题：解释一下 Socket 非阻塞 connect。
这算是 Socket 网络编程必须要理解掌握的基础知识了。  
由于自己并没有怎么写代码，所以不太清楚，现在我先来学习下 Socket 非阻塞 connect 方法的概念及原理。  

<pre>

TCP 连接的建立涉及到一个三次握手的过程，
且 SOCKET 中 connect 函数需要一直等到客户接收到对于自己的 SYN 的 ACK 为止才返回，
这意味着每个 connect 函数总会阻塞其调用进程至少一个到服务器的 RTT 时间，
而 RTT 波动范围很大，从局域网的几个毫秒到几百个毫秒甚至广域网上的几秒。
这段时间内，我们可以执行其他处理工作，以便做到并行。
在此，需要用到非阻塞 connect。

</pre>


<pre>

对于面向连接的 socket 类型(SOCK_STREAM,SOCK_SEQPACKET)，
在读写数据之前必须建立连接，connect() 函数用于完成面向连接的 socket 的建链过程，
对于 TCP，也就是三次握手过程。

套接字执行 I/O 操作有阻塞和非阻塞两种模式。
在阻塞模式下，在 I/O 操作完成前，执行操作的函数一直等候而不会立即返回，该函数所在的线程会阻塞在这里。
相反，在非阻塞模式下，套接字函数会立即返回，而不管 I/O 是否完成，该函数所在的线程会继续运行。

客户端调用 connect() 发起对服务端的 socket 连接，
如果客户端的 socket 描述符为阻塞模式，则 connect() 会阻塞到连接建立成功或连接建立超时
（Linux 内核中对 connect 的超时时间限制是 75s， Soliris 9 是几分钟，因此通常认为是 75s 到几分钟不等）。
如果为非阻塞模式，则调用 connect() 后函数立即返回，
如果连接不能马上建立成功（返回 -1），则 errno 设置为 EINPROGRESS，此时 TCP 三次握手仍在继续。
此时可以调用 select() 检测非阻塞 connect 是否完成。
select 指定的超时时间可以比 connect 的超时时间短，因此可以防止连接线程长时间阻塞在 connect 处。

select 判断规则：   
1）如果 select() 返回 0，表示在 select() 超时，超时时间内未能成功建立连接，
也可以再次执行 select() 进行检测，如若多次超时，需返回超时错误给用户。

2）如果 select() 返回大于 0 的值，则说明检测到可读或可写的套接字描述符。
源自 Berkeley 的实现有两条与 select 和非阻塞 I/O 相关的规则：
    A) 当连接建立成功时，套接口描述符变成 可写（连接建立时，写缓冲区空闲，所以可写）
    B) 当连接建立出错时，套接口描述符变成 既可读又可写（由于有未决的错误，从而可读又可写）

因此，当发现套接口描述符可读或可写时，可进一步判断是连接成功还是出错。
这里必须将 B）和另外一种连接正常的情况区分开，就是连接建立好了之后，服务器端发送了数据给客户端，
此时 select 同样会返回非阻塞 socket 描述符既可读又可写。

一种更有效的判断方法，经测试验证，在 Linux 环境下是有效的：

再次调用 connect，相应返回失败，如果错误 errno 是 EISCONN，表示 socket 连接已经建立，否则认为连接失败。 


</pre>

# Ref
[Linux socket非阻塞connect方法（一）](http://blog.csdn.net/nphyez/article/details/10268723)  
[非阻塞connect编写方法介绍](http://dongxicheng.org/network/non-block-connect-implemention/)  
