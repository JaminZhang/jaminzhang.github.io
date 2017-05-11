---
layout: post
title: DNS 的报文格式
description: "DNS 的报文格式"
category: DNS
avatarimg:
tags: [Network]
duoshuo: true
---


DNS 的报文格式


# DNS 报文总体格式

DNS 定义了一个用于查询和响应的报文格式。图 14-3 显示这个报文的总体格式。

![DNS-Message-General-Format](http://jaminzhang.github.io/images/DNS/01-DNS-Message-General-Format.png)  

![DNS General Message Format](http://www.tcpipguide.com/free/diagrams/dnsgenformat.png)  

这个报文由 12 字节长的首部和 4 个长度可变的字段组成。

DNS 报文 12 字节长的首部格式如下图所示。

![DNS Message Header Format](http://www.tcpipguide.com/free/diagrams/dnsheaderformat.png)  


标识字段由客户程序设置并由服务器返回结果。
客户程序通过它来确定响应与查询是否匹配。

16 bit 的标志字段被划分为若干子字段，如图 14-4 所示。

![DNS-Message-Header-Flags-Codes](http://jaminzhang.github.io/images/DNS/02-DNS-Message-Header-Flags-Codes.png)  


我们从最左位开始依次介绍各子字段：

* QR(Query/Response Flag) 是 1 bit 字段：0 表示查询报文，1 表示响应报文。
* opcode 是一个 4 bit 字段：通常值为 0（标准查询），其他值为 1（反向查询）和 2（服务器状态请求）。
* AA 是 1 bit 标志，表示 “授权回答(Authoritative Answer)” 。该名字服务器是授权于该域的。
* TC 是 1 bit字段，表示 “可截断的(Truncated)”。使用 UDP 时，它表示当应答的总长度超过 512 字节时，只返回前 512 个字节。
* RD 是 1 bit字段 表示 “期望递归(Recursion Desired)”。
  该比特能在一个查询中设置，并在响应中返回。
  这个标志告诉名字服务器必须处理这个查询，也称为一个递归查询。
  如果该位为 0，且被请求的名字服务器没有一个授权回答，它就返回一个能解答该查询的其他名字服务器列表，这称为迭代查询。
  在后面的例子中，我们将看到这两种类型查询的例子。
* RA 是 1 bit 字段，表示 “可用递归(Recursion Available)”。
  如果名字服务器支持递归查询，则在响应中将该比特设置为 1。
  在后面的例子中可看到大多数名字服务器都提供递归查询，除了某些根服务器。
* 随后的 3 bit 字段必须为 0。
* rcode(Response Code) 是一个 4 bit 的返回码字段。通常的值为 0（没有差错）和 3（名字差错）。
  名字差错只能从一个授权名字服务器上返回，它表示在查询中指定的域名不存在。
  
  
随后的 4 个 16 bit 字段说明最后 4 个变长字段中包含的条目数。  
对于查询报文，问题(question)数通常是 1，而其他 3 项则均为 0。  
类似地，对于应答报文，回答数至少是 1，剩下的两项可以是 0 或非 0。


# DNS 查询报文中的问题部分

问题部分中每个问题的格式如图 14-5 所示，通常只有一个问题。  

![DNS-Query-Message-Question-Section-Format](http://jaminzhang.github.io/images/DNS/03-DNS-Query-Message-Question-Section-Format.png)  
![DNS Message Question Section Format](http://www.tcpipguide.com/free/diagrams/dnsquestionformat.png)  

查询名(QName)是要查找的名字，它是一个或多个标识符的序列。  
每个标识符以首字节的计数值来说明随后标识符的字节长度，
每个名字以最后字节为 0 结束，长度为 0 的标识符是根标识符。
计数字节的值必须是 0 ~ 63 的数，因为标识符的最大长度仅为 63
（在本节的后面我们将看到计数字节的最高两比特为 1，即值 192 ~ 255，将用于压缩格式）。
不像我们已经看到的许多其他报文格式，该字段无需以整 32 bit 边界结束，即无需填充字节。

图 14-6 显示了如何存储域名 gemini.tuc.noao.edu。

![DNS-Domain-Name-Representation](http://jaminzhang.github.io/images/DNS/04-DNS-Domain-Name-Representation.png)  

每个问题有一个查询类型(QType)，而每个响应（也称一个资源记录，我们下面将谈到）也有一个类型。
大约有 20 个不同的类型值，其中的一些目前已经过时。
图 14-7 显示了其中的一些值。
查询类型是类型的一个超集( superset )：图中显示的类型值中只有两个能用于查询类型。

![DNS-Type-Value](http://jaminzhang.github.io/images/DNS/05-DNS-Type-Value.png)  


最常用的查询类型是 A 类型，表示期望获得查询名的 IP 地址。
一个 PTR 查询则请求获得一个 IP 地址对应的域名。这是一个指针查询，我们将在 14.5 节介绍。
其他的查询类型将在 14.6 节介绍。

查询类(QClass)通常是 1，指互联网地址（某些站点也支持其他非 IP 地址）。

# DNS 响应报文中的资源记录部分

DNS 报文中最后的三个字段，回答字段、授权字段和附加信息字段，
均采用一种称为资源记录RR（Resource Record）的相同格式。
图 14-8 显示了资源记录的格式。

![DNS-Resource-Records-Format](http://jaminzhang.github.io/images/DNS/06-DNS-Resource-Records-Format.png)  
![DNS Common Resource Record Format](http://www.tcpipguide.com/free/diagrams/dnsrrformat.png)  


* 域名是记录中资源数据对应的名字。它的格式和前面介绍的查询名字段格式（图 14-6）相同。
* 类型说明 RR 的类型码。它的值和前面介绍的查询类型值是一样的。类通常为 1，指 Internet 数据。
* 生存时间字段是客户程序保留该资源记录的秒数。资源记录通常的生存时间值为 2 天。
* 资源数据长度说明资源数据的数量。该数据的格式依赖于类型字段的值。对于类型 1（A 记录）资源数据是 4 字节的 IP 地址。


# Ref
[《TCP/IP 详解 卷 1：协议》14.3 DNS 的报文格式]  
[DNS Messaging and Message, Resource Record and Master File Formats](http://www.tcpipguide.com/free/t_DNSMessagingandMessageResourceRecordandMasterFileF.htm)  


