---
layout: post
title: 了解 SOCKS
description: "了解 SOCKS"
category: Network
avatarimg:
tags: [SOCKS]
duoshuo: true
---


了解 SOCKS


# SOCKS 简介

<pre>

SOCKS 是一种网络传输协议，主要用于客户端与外网服务器之间通讯的中间传递。
SOCKS 是"SOCKetS"的缩写。
当防火墙后的客户端要访问外部的服务器时，就跟 SOCKS 代理服务器连接。
这个代理服务器控制客户端访问外网的资格，允许的话，就将客户端的请求发往外部的服务器。
这个协议最初由 David Koblas 开发，而后由 NEC 的 Ying-Da Lee 将其扩展到版本 4。
最新协议是版本 5，与前一版本相比，增加支持 UDP、验证，以及 IPv6。
根据 OSI 模型，SOCKS 是会话层的协议，位于表示层与传输层之间。

</pre>

# Ref
[SOCKS](https://zh.wikipedia.org/wiki/SOCKS)  
[SOCKS5 协议的原理和应用](http://www.cppblog.com/noflybird/archive/2009/12/26/104149.html)  
[socket5 协议学习与实现(一)](http://www.mojidong.com/network/2015/03/07/socket5-1/)  
[Socks 代理和 http 代理的区别](http://wrfly.kfd.me/SOCKS%E4%BB%A3%E7%90%86%E5%92%8CHTTP%E4%BB%A3%E7%90%86%E7%9A%84%E5%8C%BA%E5%88%AB/)  
