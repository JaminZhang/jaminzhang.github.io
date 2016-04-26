---
layout: post
title: 服务器提示kernel TCP time wait bucket table overflow
description: "服务器提kernel TCP time wait bucket table overflow"
category: Network
avatarimg:
tags: [TCP]
duoshuo: true
---

# 引言
之前偶然在某台服务器上查看到如下提示：
kernel: TCP: kernel: TCP: time wait bucket table overflow
现在我们来分析下这个问题

# Linux中TCP time wait的配置
上面的内核提示：TCP time wait bucket表溢出了。

首先我们复习一下TCP中Time Wait的含义。
> TIME_WAIT是本地端主动关闭后一定会出现的状态。

## net.ipv4.tcp_max_tw_buckets 
> 
Linux系统内核参数net.ipv4.tcp_max_tw_buckets是控制系统允许处于TIME_WAIT状态的套接字(Sockets)的最大数，
这个限制是为了防止DOS(denial-of-service)攻击而存在。默认值是NR_FILE*2，并且会根据系统的内存容量被调整。
如果超过net.ipv4.tcp_max_tw_buckets上限，该连接被关闭，并且输出该信息到syslog(/var/log/messages)。

所以出现上面的提示，就是处于TIME_WAIT状态的套接字达到了net.ipv4.tcp_max_tw_buckets的数量，此时调大net.ipv4.tcp_max_tw_buckets。
如果net.ipv4.tcp_max_tw_buckets已经很大了，尝试配置另外2个TIME WAIT相关的内核参数。

## net.ipv4.tcp_tw_recycle
<pre>
This enables fast recycling of TIME_WAIT sockets. 
The default value is 0 (disabled). Should be used with caution with loadbalancers.

快速收回处于TIME_WAIT状态的套接字(Sockets)
默认是0(无效)
在使用负载均衡器的环境，需谨慎修改该参数

</pre>

## net.ipv4.tcp_tw_reuse
<pre>
This allows reusing sockets in TIME_WAIT state for new connections when it is safe from protocol viewpoint.
Default value is 0 (disabled). It is generally a safer alternative to tcp_tw_recycle.
Note: The tcp_tw_reuse setting is particularly useful in environments where numerous short connections are
open and left in TIME_WAIT state, such as web servers and loadbalancers. Reusing the sockets can be very effective
in reducing server load. Starting in Linux 2.6.7 (and back-ported to 2.4.27), linux includes alternative congestion
control algorithms beside the traditional ‘reno’ algorithm. These are designed to recover quickly from packet loss
on high-speed WANs.

从协议安全性，允许将处于TIME_WAIT状态的套接字(Sockets)用于新的TCP连接
默认是0(无效)
一般来讲这是比修改tcp_tw_recycle安全

</pre>


# Ref
[kernel: TCP: time wait bucket table overflow](https://www.awspack.com/os/linux/time-wait-table/)  



