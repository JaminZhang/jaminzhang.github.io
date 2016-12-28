---
layout: post
title: TCP/IP 数据封装与分用概述
description: "TCP/IP 数据封装与分用概述"
category: Network
avatarimg:
tags: [TCP, UDP, IP]
duoshuo: true
---

# 封装

当应用程序用 TCP 传送数据时，数据被送入协议栈中，  
然后逐个通过每一层直到被当作一串比特流送入网络。  
其中每一层对收到的数据都要增加一些首部信息（有时还要增加尾部信息），该过程如图 1-7 所示。  


![Data-Encapsulation](http://jaminzhang.github.io/images/TCP-IP/Data-Encapsulation.png)  


* TCP 传给 IP 的数据单元称作 TCP 报文段或简称为 TCP 段（TCP segment）。
* IP 传给网络接口层的数据单元称作 IP 数据报(IP datagram)。
* 通过以太网传输的比特流称作帧(Frame)。

以太网数据帧的物理特性是其长度必须在 46~1500 字节之间。

更准确地说，图 1-7 中 IP 和网络接口层之间传送的数据单元应该是分组（packet）。
分组既可以是一个 IP 数据报，也可以是 IP 数据报的一个片（fragment）。

UDP 数据与 TCP 数据基本一致。
唯一的不同是 UDP 传给 IP 的信息单元称作 UDP 数据报（UDP datagram），而且 UDP 的首部长为 8 字节。

由于 TCP、UDP、ICMP 和 IGMP 都要向 IP 传送数据，
因此 IP 必须在生成的 IP 首部中加入某种标识，以表明数据属于哪一层。
为此， IP 在首部中存入一个长度为 8 bit的数值，称作协议域。
1 表示为 ICMP 协议， 2 表示为 IGMP 协议， 6 表示为 TCP 协议， 17 表示为 UDP 协议。

类似地，许多应用程序都可以使用 TCP 或 UDP 来传送数据。  
运输层协议在生成报文首部时要存入一个应用程序的标识符。
TCP 和 UDP 都用一个 16 bit 的端口号来表示不同的应用程序。  
TCP 和 UDP 把源端口号和目的端口号分别存入报文首部中。

网络接口分别要发送和接收 IP、ARP 和 RARP 数据，
因此也必须在以太网的帧首部中加入某种形式的标识，以指明生成数据的网络层协议。
为此，以太网的帧首部也有一个 16 bit 的帧类型域。

# 分用（解封装）

当目的主机收到一个以太网数据帧时，数据就开始从协议栈中由底向上升，
同时去掉各层协议加上的报文首部。
每层协议盒都要去检查报文首部中的协议标识，以确定接收数据的上层协议。
这个过程称作分用（Demultiplexing），图 1-8 显示了该过程是如何发生的。

![Data-Demultiplexing](http://jaminzhang.github.io/images/TCP-IP/Data-Demultiplexing.png)  

为协议 ICMP 和 IGMP 定位一直是一件很棘手的事情。
在图 1-4 中，把它们与 IP 放在同一层上，那是因为事实上它们是 IP 的附属协议。
但是在这里，我们又把它们放在 IP 层的上面，这是因为 ICMP 和 IGMP 报文都被封装在 IP 数据报中。

对于 ARP 和 RARP，我们也遇到类似的难题。
在这里把它们放在以太网设备驱动程序的上方，这是因为它们和 IP 数据报一样，都有各自的以太网数据帧类型。
但在图 2-4 中，我们又把 ARP 作为以太网设备驱动程序的一部分，放在 IP 层的下面，其原因在逻辑上是合理的。
这些分层协议盒并不都是完美的。


# Ref
《TCP/IP 详解 卷 1：协议》第 1 章 概述 1.6 封装 1.7 分用
