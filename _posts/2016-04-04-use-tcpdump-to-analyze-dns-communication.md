---
layout: post
title: 使用tcpdump分析查看DNS通信过程
description: "使用tcpdump分析查看DNS通信过程"
category: Network
avatarimg:
tags: [Network, DNS, tcpdump]
duoshuo: true
---

# 引言
最近想重新学习了解下DNS原理，于是看起了《TCP/IP详解 卷1：协议》 第14章 DNS：域名系统  
在讲解DNS报文格式时，使用tcmpdump来对DNS报文进行抓包举例来讲解。   
下面我亲自使用tcpdump来分析查看下DNS通信过程。

# 使用tcpdump观察DNS通信过程

## 1.启动tcpdump对DNS报文进行抓包
命令如下：

> 
tcpdump -i eth0 -nt -s 500 port domain

使用“port domain”来过滤数据包，表示只抓取使用domain（域名）服务的数据包，即DNS查询和应答报文

## 2.使用host命令进行DNS查询
命令如下：

> 
host -t A www.qq.com

## 3.分析tcpdump输出
当执行完第2步后，tcpdump就会有输出，如下：

```bash
[root@iZ25p102vo3Z ~]# tcpdump -i eth0 -nt -s 500 port domain
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 500 bytes
IP 10.162.201.34.48965 > 10.202.72.118.domain: 18831+ A? www.qq.com. (28)
IP 10.202.72.118.domain > 10.162.201.34.48965: 18831 1/4/9 A 101.226.103.106 (275)

```     

> 
这两个数据包开始的“IP”指出，它们后面的内容描述的是IP数据报。 
tcpdump以“IP地址.端口号”的形式来描述通信的某一端； 
以“>”表示数据传输的方向，“>”前面是源端，后面是目的端。  
可见，第一个数据包是测试机器（IP地址是10.162.201.34）向其首选DNS服务器（IP地址是10.202.72.118）发送的DNS查询报文（目标端口53是DNS服务使用的端口），第二个数据包是服务器反馈的DNS应答报文。 

> 
第一个数据包中，数值18831是DNS查询报文的标识值，因此该值也出现在DNS应答报文中。  
“+”表示启用递归查询标志。  
“A?”表示使用A类型的查询方式。  
“www.qq.com”则是DNS查询问题中的查询名。  
括号中的数值28是DNS查询报文的长度（以字节为单位）。  

> 
第二个数据包中，“1/4/9”表示该报文中包含1个应答资源记录、4个授权资源记录和9个额外信息记录。  
该应答报文的长度为275字节。

> 
注意　我们抓包的时候没有开启tcpdump的-X选项（或者-x选项）。  
如果使用-X选项，我们将能看到DNS报文的每一个字节，也就能明白上面28字节的查询报文和275字节的应答报文的具体含义。  

# Ref
[《TCP/IP详解 卷1：协议》 第14章 DNS：域名系统](https://book.douban.com/subject/1088054/)  
[使用tcpdump观察DNS通信过程](http://book.51cto.com/art/201306/400247.htm)  
