---
layout: post
title: 使用 Tcpdump 分析查看 DNS 通信过程
description: "使用 Tcpdump 分析查看 DNS 通信过程"
category: DNS
avatarimg:
tags: [Network, DNS, Tcpdump]
duoshuo: true
---

# 引言

最近想重新学习了解下 DNS 原理，于是看起了《TCP/IP 详解 卷 1：协议》 第 14 章 DNS：域名系统  
在讲解 DNS 报文格式时，使用 tcmpdump 来对 DNS 报文进行抓包举例来讲解。   
下面我亲自使用 tcpdump 来分析查看下 DNS 通信过程。

# 使用 tcpdump 观察 DNS 通信过程

## 1. 启动 tcpdump 对 DNS 报文进行抓包

命令如下：

> 
tcpdump -i eth0 -nt -s 500 port domain

使用“port domain”来过滤数据包，表示只抓取使用 domain（域名）服务的数据包，即 DNS 查询和应答报文


<pre>

-i     Listen on interface.  If unspecified, tcpdump searches the system interface list for the lowest numbered,
       configured up interface (excluding loopback). Ties are broken by choosing the earliest match.

       On Linux systems with 2.2 or later kernels, 
       an interface argument of ‘‘any’’ can be used to capture packets from all interfaces.          
       Note that captures on the ‘‘any’’ device will not be done in promiscuous mode.
       
       If the -D flag is supported, an interface number as printed by that flag can be used as the interface argument.

-n     Don’t convert host addresses to names.  This can be used to avoid DNS lookups.
-t     Don’t print a timestamp on each dump line.

-s     Snarf snaplen bytes of data from each packet rather than the default of 65535 bytes.  
       Packets truncated because of a limited snapshot are indicated in the output with ‘‘[|proto]’’, 
       where proto is the name of the protocol level at which the truncation has occurred.  
       Note that taking larger snapshots both increases the amount of time it takes to process packets and, 
       effectively, decreases the amount of packet buffering.  This may cause packets to be lost.  
       You should limit snaplen to the smallest number that will capture the protocol information you’re interested in.  
       Setting snaplen to 0 sets it to the default of 65535, 
       for backwards compatibility with recent older versions of tcpdump.

-X     When parsing and printing,  in addition to printing the headers of each packet, 
       print the data of each packet (minus its link level header) in hex and ASCII.  
       This is very handy for analysing new protocols.

</pre>



## 2. 使用 host 命令进行 DNS 查询

命令如下：

> 
host -t A www.qq.com

## 3. 分析 tcpdump 输出

当执行完第 2 步后，tcpdump 就会有输出，如下：

```bash

[root@iZ25p102vo3Z ~]# tcpdump -i eth0 -nt -s 500 port domain
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 500 bytes
IP 10.162.201.34.48965 > 10.202.72.118.domain: 18831+ A? www.qq.com. (28)
IP 10.202.72.118.domain > 10.162.201.34.48965: 18831 1/4/9 A 101.226.103.106 (275)

```     

> 
这两个数据包开始的“IP”指出，它们后面的内容描述的是 IP 数据报。 
Tcpdump 以 “IP 地址.端口号” 的形式来描述通信的某一端； 
以 “>” 表示数据传输的方向，“>” 前面是源端，后面是目的端。  
可见，第一个数据包是测试机器（IP 地址是 10.162.201.34）向其首选 DNS 服务器（IP 地址是 10.202.72.118）
发送的 DNS 查询报文（目标端口 53 是 DNS 服务使用的端口），
第二个数据包是服务器反馈的 DNS 应答报文。 

> 
第一个数据包中，数值 18831 是 DNS 查询报文的标识值，因此该值也出现在 DNS 应答报文中。  
“+” 表示启用递归查询标志。  
“A?” 表示使用 A 类型的查询方式。  
“www.qq.com” 则是 DNS 查询问题中的查询名。  
括号中的数值 28 是 DNS 查询报文的长度（以字节为单位）。  

> 
第二个数据包中，“1/4/9” 表示该报文中包含 1 个应答资源记录、4 个授权资源记录和 9 个额外信息记录。  
该应答报文的长度为 275 字节。

> 
注意：我们抓包的时候没有开启 tcpdump 的 -X 选项（或者 -x 选项）。  
如果使用 -X 选项，我们将能看到 DNS 报文的每一个字节，也就能明白上面 28 字节的查询报文和 275 字节的应答报文的具体含义。  

上面使用 -X 选项，是以 16 进制和 ASCII 方式打印，不太直观地看出来报文内容，  
这里我们可以使用 Tcpdump 将抓到的数据包写入到文件中，然后导入到 Wireshark 中查看。

```bash

[root@VM_15_187_centos ~]# tcpdump -i eth0 -nt -s 500 -X port domain -w dns-dump.pcap -v
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 500 bytes
^C2 packets captured
2 packets received by filter
0 packets dropped by kernel

```    

# Ref
[《TCP/IP 详解 卷 1：协议》 第 14 章 DNS：域名系统](https://book.douban.com/subject/1088054/)  
[使用 tcpdump 观察 DNS 通信过程](http://book.51cto.com/art/201306/400247.htm)  
[使用 wireshark 查看 tcpdump 的抓包结果](https://mozillazg.github.io/2015/05/open-tcpdump-result-with-wireshark-gui.html)  
