---
layout: post
title: TCP 数据传输分类
description: "TCP 数据传输分类"
category: Network
avatarimg:
tags: [TCP]
duoshuo: true
---

# TCP 数据传输分类

<pre>

We now examine the transfer of data using TCP.
Studies of TCP traffic, such as [Caceres et al. 1991], 
usually find that on a packet-count basis 
about half of all TCP segments contain bulk data (FTP, electronic mail, Usenet news) 
and the other half contain interactive data (Telnet and Rlogin, for example). 
On a byte-count basis the ratio is around 90% bulk data and 10% interactive, 
since bulk data segments tend to be full sized (normally 512 bytes of user data), 
while interactive data tends to be much smaller. 
(The above-mentioned study found that 90% of Telnet and Rlogin packets 
carry less than 10 bytes of user data.)

TCP obviously handles both types of data, 
but different algorithms come into play for each.


</pre>


<pre>

现在来介绍使用 TCP 进行数据传输的有关问题。
一些有关 TCP 通信量的研究如[Caceres et al. 1991]发现，
如果按照分组数量计算，
约有一半的 TCP 报文段包含成块数据（如 FTP、电子邮件和 Usenet 新闻），
另一半则包含交互数据（如 Telnet 和 Rlogin）。
如果按字节计算，
则成块数据与交互数据的比例约为 90% 和 10%。
这是因为成块数据的报文段基本上都是满长度（full-sized）的（通常为 512 字节的用户数据），
而交互数据则小得多
（上述研究表明 Telnet 和 Rlogin 分组中通常约 90% 左右的用户数据小于 10 个字节）。

很明显，TCP 需要同时处理这两类数据，但使用的处理算法则有所不同。

</pre>


从上面可以看到，使用 TCP 进行数据传输可以分为两类。

1. TCP 交互式数据流（TCP Interactive Data Flow）举例：Telnet/Rlogin
2. TCP 成块数据流（TCP Bulk Data Flow）举例：FTP/Email/Usenet

# Ref
《TCP/IP 详解 卷 1：协议》第 19 章 TCP 的交互数据流 19.1 引言
