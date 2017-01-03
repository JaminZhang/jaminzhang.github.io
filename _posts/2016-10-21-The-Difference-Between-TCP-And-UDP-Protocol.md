---
layout: post
title: TCP 与 UDP 的区别
description: "TCP 与 UDP 的区别"
category: Network
avatarimg:
tags: [TCP, UDP, IP]
duoshuo: true
---


# TCP UDP 概述

<pre>

UDP 是一个简单的面向数据报的传输层协议：
进程的每个输出操作都正好产生一个 UDP 数据报，并组装成一份待发送的 IP 数据报。

UDP 不提供可靠性：它把应用程序传给 IP 层的数据发送出去，但是并不保证它们能到达目的地。
应用程序必须关心 IP 数据报的长度。如果它超过网络的 MTU，那么就要对 IP 数据报进行分片。

传输层主要为两台主机上的应用程序提供端到端的通信。
在 TCP/IP 协议族中，有两个互不相同的传输协议： TCP（传输控制协议）和 UDP（用户数据报协议）。

TCP 为两台主机提供高可靠性的数据通信。
它所做的工作包括把应用程序交给它的数据分成合适的小块交给下面的网络层，
确认接收到的分组，设置发送最后确认分组的超时时钟等。
由于运输层提供了高可靠性的端到端的通信，因此应用层可以忽略所有这些细节。

而另一方面， UDP 则为应用层提供一种非常简单的服务。
它只是把称作数据报的分组从一台主机发送到另一台主机，但并不保证该数据报能到达另一端。
任何必需的可靠性必须由应用层来提供。

</pre>

# TCP 与 UDP 的区别

## 1. TCP 是面向连接的协议，UDP 是无连接协议

TCP 发送数据前使用三次握手建立连接，UDP 发送数据前不需要建立连接。

## 2. TCP 可靠，UDP 不可靠

TCP 丢包会自动重传，UDP 不会(任何必需的可靠性必须由应用层来提供)。
TCP 可靠性由三个机制保证：1. 序号（TCP 报文的序号）2. 确认（ACK 机制）3. 重传（超时或者冗余的 ACK）


## 3. TCP 有序，UDP 无序

消息在传输过程中可能会乱序，后发送的消息可能会先到达，TCP 会对其进行重新排序，UDP 不会。

## 4.TCP 无界，UDP 有界

TCP 通过字节流传输，UDP 中每一个包都是单独的。

## 5. TCP 有流量控制（拥塞控制），UDP 没有

TCP 协议的流量控制是基于滑窗协议实现的。
拥塞控制和流量控制不同，流量控制是点对点的通信量抑制，抑制发送端发送速率，使得接收端来得及接收。

## 6. TCP 传输慢，UDP 传输快；

因为 TCP 需要建立连接、保证可靠性和有序性，所以比较耗时。
这就是为什么视频流、广播电视、在线多媒体游戏等选择使用 UDP。

## 7. TCP 是重量级的，UDP 是轻量级的

TCP 要建立连接、保证可靠性和有序性，就会传输更多的信息，如 TCP 的包头比较大。

## 8. TCP 的 头部比 UDP 大

![TCP-Segment-Format](http://liangjiabin.com/wp-content/uploads/2015/03/TCP-Packet-Format-Diagram.gif)  
![UDP-Datagram-Format](http://liangjiabin.com/wp-content/uploads/2015/03/UDP-Packet-format.jpg)  


**总结：**

* TCP 是面向连接的、可靠的、有序的、速度慢的协议；UDP 是无连接的、不可靠的、无序的、速度快的协议。
* TCP 开销比 UDP 大，TCP 头部需要 20 字节，UDP 头部只要 8 个字节。
* TCP 无界有拥塞控制，UDP 有界无拥塞控制。

|      | TCP | UDP |
|------|-----|-----|
|连接性| 面向连接 | 无连接 |
|可靠性| 可靠 | 不可靠 |
|有序性| 有序 | 无序 |
|有界性| 有界 | 无界 |
|拥塞控制| 有 | 无 |
|传输速度| 慢 | 快 |
|量级| 重量级 | 轻量级 |
|头部大小| 大 | 小 |


![TCP和UDP协议的比较](http://img.my.csdn.net/uploads/201303/15/1363304832_2419.jpg)　

# Ref
[TCP和UDP的区别](http://liangjiabin.com/blog/2015/03/difference-between-tcp-vs-udp-protocol.html)  
[面向报文（UDP）和面向字节流（TCP）的区别](http://blog.csdn.net/ce123_zhouwei/article/details/8976006)  
[TCP和UDP之间的区别](http://feinibuke.blog.51cto.com/1724260/340272)  
