---
layout: post
title: CDN 的智能 DNS 简介
description: "CDN 的智能 DNS 简介"
category: CDN
avatarimg:
tags: [Web, DNS, CDN, GSLB]
duoshuo: true
---

# 引言

GSLB（Global Server Load Balance，全局负载均衡）作为 CDN 系统架构中最核心的部分，负责流量调度。   
其中常见的便是基于 DNS 的解析方式来实现，我们称之为智能 DNS。  

# 基于 DNS 解析方式的 CDN

简单来说，基于 DNS 解析方式的 CDN 使用 Local DNS 进行寻址，  
通过建立 IP 地址访问列表，判断用户的访问来源，以确定其访问节点的位置。

在这种方式下，一般如果 Local DNS 设置不当，  
例如没有使用当前 ISP 提供的 Local DNS 这种实现方式可能会误判用户的位置，
从而将用户误导到错误的 CDN 缓存节点，造成加速效果差的问题。

那么一定非要使用 ISP 提供的 Local DNS 吗？  
不一定，我们可以使用一些公共 DNS 服务器，比如阿里公共 DNS，它的官网说明了
`结合阿里优质 CDN 资源和精准的 IP 地址库，让用户访问到较近的网站。`

但使用阿里公共 DNS，也可能访问某些网站变慢，原因如下。

<pre>

为什么我设置阿里公共 DNS 后，访问某些大网站变慢了？

许多网站的静态资源都使用了 CDN 服务或者 DNS 智能解析服务（这里的 DNS 是指域名的权威 DNS 服务器），
目前大部分 CDN 或者 DNS 智能解析是根据客户 Local DNS IP 来进行调度的。

为了让使用阿里公共 DNS 的客户访问 CDN 的域名更快。阿里公共 DNS 设计了两层 CACHE 架构，
第一层 CACHE 采用 bgp anycast 技术宣告统一服务 IP：223.5.5.5 和 223.6.6.6，接收并应答客户请求。
第二层 CACHE 结合阿里优质的机房资源及淘宝 IP 地址库，根据客户端的公网出口 IP，
选择与客户本地网络最近的节点代替客户进行递归查询。
从而让这些网站的 CDN 调度系统返回离用户最近的 CDN 节点。
如果您使用阿里公共 DNS，感觉访问大网站变慢，有可能是我们选择代替您递归的二级 CACHE 节点不够准确，
也可能是网站服务商的 CDN 或者权威 DNS 调度我们的 IP 有问题。
请您配合我们做一下测试，并提供一下测试结果，以便我们改善我们的服务，谢谢！

</pre>


# Ref
[浅析基于 DNS 解析方式的 GSLB](http://www.cnblog.me/2015/09/30/cdn-gslb-dns/)   
[使用公共 DNS 可能会遇到的疑问](http://www.alidns.com/faqs/#dns-faqs)   
[获取访客本地域名解析服务器的方法 ](https://www.google.com/patents/CN102035905B?cl=zh)  
