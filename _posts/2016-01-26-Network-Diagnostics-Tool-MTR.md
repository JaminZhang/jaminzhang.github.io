---
layout: post
title: 网络诊断工具 MTR 学习
description: "网络诊断工具 MTR 学习"
category: Network
avatarimg:
tags: [MTR]
duoshuo: true
---

# 引言

我们一般使用 ping 和 traceroute 来诊断网络连接的延迟和丢包问题。  
之前简单看过 MTR，今年来重新学习下。

# 什么是 MTR

<pre>

mtr - a network diagnostic tool

mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool.

As mtr starts, it investigates the network connection between the host mtr runs on and HOSTNAME.
by sending packets with purposely low TTLs. 
It continues to send packets with low TTL, noting the response time of the intervening routers.  
This allows mtr to print the response percentage and response times of the internet route to HOSTNAME.  
A sudden increase in packet loss or response time is often an indication of a bad (or simply overloaded) link.

The results are usually reported as round-trip-response times in miliseconds and the percentage of packetloss.

</pre>

MTR 是一个网络诊断工具。  
MTR 在一个单一的网络诊断工具中结合了 traceroute 和 ping 程序的功能。


# 分析 MTR 报告

得推荐这篇讲解 MTR 的文章，很不错，里面有分析报告的实例说明。
[使用 MTR 诊断网络问题](https://meiriyitie.com/2015/05/26/diagnosing-network-issues-with-mtr)  


# Ref
man mtr  
[使用 MTR 诊断网络问题](https://meiriyitie.com/2015/05/26/diagnosing-network-issues-with-mtr)   
[mtr 命令详解 / 举例说明](http://blog.hexu.org/archives/1050.shtml)  

