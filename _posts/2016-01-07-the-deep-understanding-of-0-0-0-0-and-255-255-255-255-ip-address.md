---
layout: post
title: 0.0.0.0和255.255.255.255 IP地址的深入理解
description: "0.0.0.0和255.255.255.255 IP地址的深入理解"
category: Network
avatarimg:
tags: [IP, netstat]
duoshuo: true
---

# 引言
研发的程序配置文件监听使用域名时有问题，程序启动后，把监听域名解析成255.255.255.255，可以使用netstat命令查看到，在255.255.255.255上监听，真是无语了。  
于是我多想了下，这种在本地255.255.255.255上监听是错误的？它怎么来理解？为什么系统会在这个地址上监听？只是因为它解析出来是255.255.255.255？ 
在广播地址上监听是有效的吗？一般广播地址是用作目标IP的，这里竟然能做源IP？
下面先来看看0.0.0.0和255.255.255.255的定义。  

# 0.0.0.0
> 
In the Internet Protocol Version 4, the address 0.0.0.0 is a non-routable meta-address used to designate an invalid, unknown or non-applicable target. To give a special meaning to an otherwise invalid piece of data is an application of in-band signaling.

> 
In the context of servers, 0.0.0.0 means "all IPv4 addresses on the local machine". If a host has two IP addresses, 192.168.1.1 and 10.1.2.1, and a server running on the host listens on 0.0.0.0, it will be reachable at both of those IPs.

> 
In the context of routing, 0.0.0.0 usually means the default route, i.e. the route which leads to "the rest of" the internet instead of somewhere on the local network.

以上来自Wiki，在服务器网络编程中，也就是在服务器上下文中，0.0.0.0意味着本机上的所有IPv4地址。  

# 255.255.255.255
> 
A broadcast address is a logical address at which all devices connected to a multiple-access communications network are enabled to receive datagrams. A message sent to a broadcast address is typically received by all network-attached hosts, rather than by a specific host.

> 
A special definition exists for the IP broadcast address 255.255.255.255. It is the broadcast address of the zero network or 0.0.0.0, which in Internet Protocol standards stands for this network, i.e. the local network. Transmission to this address is limited by definition, in that it is never forwarded by the routers connecting the local network to other networks.

以上同样来处Wiki。255.255.255.255是广播地址，它作为目标IP地址表示一个本地网络的广播地址。

# 结语
255.255.255.255作为源IP地址并在其上监听，还是不知道如何理解，这种方式是有效或者错误的？并没有见过这种监听方法。  
刚才在Windows下设置IP地址时，255开头就提示不能设置，这说明主机IP地址不能为255.255.255.255。255.255.255.255不能被任何一台独立主机拥有，  
只能作为目标IP地址来表示一个本地网络的广播地址。
netstat命令显示出来的是在255.255.255.255上监听，这样只有去看netstat源代码才能理解它的结果输出了。  
有结果输出就不一定表示这种监听方式正确的。 
能力有效，只能理解到这里了。  

这是不是netstat 显示的bug？它好像并不验证你在什么IP地址上监听？
255.255.255.255是受限的广播地址，用于IP数据报的目的地址，仅应用于UDP。

# Ref
[网络编程IP地址](https://www.loggerhead.me/posts/wang-luo-bian-cheng-ipdi-zhi.html)  
[0.0.0.0](https://en.wikipedia.org/wiki/0.0.0.0)  
[Broadcast_address](https://en.wikipedia.org/wiki/Broadcast_address)  
[《TCP/IP详解 卷1：协议》第12章 广播和多播]
