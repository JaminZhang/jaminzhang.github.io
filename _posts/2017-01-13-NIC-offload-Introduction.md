---
layout: post
title:  网卡 offload 简介
description: " 网卡 offload 简介"
category: Linux
avatarimg:
tags: [NIC, Offload, MTU, LSO, LRO, GSO, GRO, TSO, UFO]
duoshuo: true
---

# 网卡 offload 简介
 
现在，越来越多的网卡设备支持 offload 特性，来提升网络收/发性能。  
**offload 是将本来该操作系统进行的一些数据包处理（如分片、重组等）放到网卡硬件中去做，
降低系统 CPU 消耗的同时，提高处理的性能。**

网卡 offload 包括 LSO/LRO、GSO/GRO、TSO/UFO 等。

# LSO/LRO 简介

<pre>

分别对应到发送和接收两个方向，全称是 Large Segment Offload 和 Large Receive Offload。

首先来看 LSO。我们知道计算机网络上传输的数据基本单位是离散的网包，
既然是网包，就有大小限制，这个限制就是 MTU（Maximum Transmission Unit）的大小，一般是 1518 字节。

比如我们想发送很多数据出去，经过 OS 协议栈的时候，会自动帮你拆分成几个不超过 MTU 的网包。
然而，这个拆分是比较费计算资源的（比如很多时候还要计算分别的 checksum），
由 CPU 来做的话，往往会造成使用率过高。
那可不可以把这些简单重复的操作 offload 到网卡上呢？

于是就有了 LSO，在发送数据超过 MTU 限制的时候（太容易发生了），
OS 只需要提交一次传输请求给网卡，网卡会自动的把数据拿过来，
然后进行切，并封包发出，发出的网包不超过 MTU 限制。

接下来看 LRO，当网卡收到很多碎片包的时候，LRO 可以辅助自动组合成一段较大的数据，一次性提交给 OS 处理。

一般的，LSO 和 LRO 主要面向 TCP 报文。

</pre>

# GSO/GRO 简介

<pre>

Generic Segmentation Offload 和 Generic Receive Offload，
分别比 LSO 和 LRO 更通用，自动检测网卡支持特性，支持分包则直接发给网卡，否则先分包后发给网卡。
新的驱动一般用 GSO/GRO。

</pre>

# TSO/UFO 简介

<pre>

TCP Segmentation Offload 和 UDP fragmentation offload，分别对应 TCP 报文和 UDP 报文。

很典型的，TCP 协议中就考虑了分片存在的情况，往往是切分 TCP 的数据包，叫做 TSO。
而一般的情况，则称为 LSO 或者 GSO。

对于其他不支持切片的协议例如 UDP，则只能进行 IP 层上的切片。

</pre>


可以通过`ethtool -k eth0`命令来查看网卡设备各个选项的当前状态，注意输出中各种 offload 选项的状态。


# Ref
[网络虚拟化中的 offload 技术：LSO/LRO、GSO/GRO、TSO/UFO、VXLAN](http://blog.csdn.net/yeasy/article/details/19204639)  
[理解 Linux 网络栈（3）：QEMU/KVM + VxLAN 环境下的 Segmentation Offloading 技术（发送端）](http://www.cnblogs.com/sammyliu/p/5228581.html)  
[ openstack的neutron:禁用GRO:TSO、UFO、GSO、LRO、GRO和RSS介绍 2](http://stupidpig.blog.chinaunix.net/uid-7374279-id-4751789.html)  
[网卡TSO/GSO/LRO/GRO简要介绍](http://seitran.com/2015/04/13/01-gso-gro-lro/)  
[ GSO/TSO/GRO等对VirtIO虚机的网络性能影响分析(by quqi99)](http://blog.csdn.net/quqi99/article/details/51066800)  
[使用LVS，关闭网卡LRO/GRO功能](http://www.bo56.com/%E4%BD%BF%E7%94%A8lvs%EF%BC%8C%E5%85%B3%E9%97%AD%E7%BD%91%E5%8D%A1lrogro%E5%8A%9F%E8%83%BD/)　
