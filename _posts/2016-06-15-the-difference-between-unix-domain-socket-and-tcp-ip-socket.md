---
layout: post
title:  Unix domain socket 和 TCP/IP socket 的区别
description: "Unix domain socket 和 TCP/IP socket 的区别"
category: Network
avatarimg:
tags: [Linux, Socket]
duoshuo: true
---

# 引言
前篇文章谈到 mysql 中 localhost 和 127.0.0.1 连接的区别，其实质分别对应的就是 Unix domain socket 和 TCP/IP socket。
下面再来看看这两者之间的区别。  

# UNIX Domain Socket 与 TCP/IP Socket 对比
<pre>
socket API原本是为网络通讯设计的，但后来在socket的框架上发展出一种IPC机制，就是UNIX Domain Socket。
虽然网络socket也可用于同一台主机的进程间通讯（通过loopback地址127.0.0.1），
但是UNIX Domain Socket用于IPC更有效率：不需要经过网络协议栈，不需要打包拆包、计算校验和、维护序号和应答等，只是将应用层数据从一个进程拷贝到另一个进程。
UNIX域套接字与TCP套接字相比较，在同一台主机的传输速度前者是后者的两倍。
这是因为，IPC机制本质上是可靠的通讯，而网络协议是为不可靠的通讯设计的。
UNIX Domain Socket也提供面向流和面向数据包两种API接口，类似于TCP和UDP，但是面向消息的UNIX Domain Socket也是可靠的，消息既不会丢失也不会顺序错乱。


A UNIX socket is an inter-process communication mechanism that allows bidirectional data exchange between processes running on the same machine.

IP sockets (especially TCP/IP sockets) are a mechanism allowing communication between processes over the network. 
In some cases, you can use TCP/IP sockets to talk with processes running on the same computer (by using the loopback interface).

UNIX domain sockets know that they’re executing on the same system, so they can avoid some checks and operations (like routing); 
which makes them faster and lighter than IP sockets. 
So if you plan to communicate with processes on the same host, this is a better option than IP sockets.
</pre>	

# Ref
[linux网络编程之socket（十五）：UNIX域套接字编程和socketpair 函数](http://blog.csdn.net/jnu_simba/article/details/9079359)  
[What's the difference between Unix socket and TCP/IP socket?](http://serverfault.com/questions/124517/whats-the-difference-between-unix-socket-and-tcp-ip-socket)  
[nginx、php-fpm默认配置与性能–TCP socket还是unix domain socket](https://www.cnxct.com/default-configuration-and-performance-of-nginx-phpfpm-and-tcp-socket-or-unix-domain-socket/)  
[Unix Socket 与 IP Socket (TCP/IP) 的区别](http://coseylee.com/2012-04-13-unix-socket-ip-vs-ip-socket.html)  
