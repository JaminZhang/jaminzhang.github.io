---
layout: post
title: 理解 TCP 报文头中的初始序列号
description: "理解 TCP 报文头中的初始序列号"
category: Network
avatarimg:
tags: [TCP, ISN]
duoshuo: true
---

# 引言

上篇文章谈到 TCP 中的序列号，这引发我对初始化序列号的理解。
在看《TCP/IP 详解，卷 1：协议》时，里面讲述 ISN 是随时间生成的，
当时看到这里时，认为这个算法生成的 ISN 是有规律的，但通过查找其他资料，  
了解到 ISN 的安全性非常重要，生成的 ISN 必须得随机，不然可能被人预测进行 TCP 包的伪造。

# 引入 ISN 的原因

标识每个 TCP 连接

<pre>

The Problem With Starting Every Connection Using the Same Sequence Number

In the example I gave in the topic describing the sliding windows system, 
I assumed for “simplicity” (ha ha, was that simple?) that each device would start a connection 
by giving the first byte of data sent sequence number 1. 
A valid question is, why wouldn't we always just start off each TCP connection by sending the first byte of data 
with a sequence number of 1? The sequence numbers are arbitrary, after all, and this is the simplest method.

In an ideal world, this would probably work, but we don't live in an ideal world. 
The problem with starting off each connection with a sequence number of 1 is that 
it introduces the possibility of segments from different connections getting mixed up. 
Suppose we established a TCP connection and sent a segment containing bytes 1 through 30. 
However, there was a problem with the internetwork that caused this segment to be delayed, 
and eventually, the TCP connection itself to be terminated. 
We then started up a new connection and again used a starting sequence number of 1. 
As soon as this new connection was started, however, the old segment with bytes labeled 1 to 30 showed up. 
The other device would erroneously think those bytes were part of the new connection.

This is but one of several similar problems that can occur. 
To avoid them, each TCP device, at the time a connection is initiated, 
chooses a 32-bit initial sequence number (ISN) for the connection. 
Each device has its own ISN, and they will normally not be the same.

</pre>

# ISN 生成方法及其安全性

<pre>

Selecting the Initial Sequence Number

Traditionally, each device chose the ISN by making use of a timed counter, like a clock of sorts, 
that was incremented every 4 microseconds. 
This counter was initialized when TCP started up and then its value increased by 1 every 4 microseconds 
until it reached the largest 32-bit value possible (4,294,967,295) at which point it “wrapped around” to 0 
and resumed incrementing. 
Any time a new connection is set up, the ISN was taken from the current value of this timer. 
Since it takes over 4 hours to count from 0 to 4,294,967,295 at 4 microseconds per increment, 
this virtually assured that each connection will not conflict with any previous ones.

One issue with this method is that it makes ISNs predictable. 
A malicious person could write code to analyze ISNs and 
then predict the ISN of a subsequent TCP connection based on the ISNs used in earlier ones. 
This represents a security risk, which has been exploited in the past 
(such as in the case of the famous Mitnick attack). 
To defeat this, implementations now use a random number in their ISN selection process.

</pre>

<pre>

不同的 OS 在选择生成 TCP ISN 时采用不同的方法。
一些 UNIX 系统采用传统的 64K 递增方法，较新的 Solaris，IRIX，FreeBSD，DIGITAL UNIX 和 Cray 等系统则采用随机增量的方法，
Linux 2.0，OpenVMS 和 AIX 等系统采用真随机方法，Windows 系统采用一种时间相关的模型。
还有一些系统使用常数，如 3Com 集线器使用 0x803，Apple LaserWriter 打印机使用 OxC 7001 等。

所以为了使生成的 ISN 具有不可预测性，就要设计好的生成算法，这篇很早的中文论文就谈到了这方面的内容，可以好好看看，
[关于 TCP/IP 序列号生成方法的研究](http://lin-style.iteye.com/blog/156950) ，（PS: 没有找到原始出处。）

</pre>

# Ref

[TCP Connection Establishment Sequence Number Synchronization and Parameter Exchange ](http://www.tcpipguide.com/free/t_TCPConnectionEstablishmentSequenceNumberSynchroniz.htm)  
[关于 TCP/IP 序列号生成方法的研究](http://lin-style.iteye.com/blog/156950)  
