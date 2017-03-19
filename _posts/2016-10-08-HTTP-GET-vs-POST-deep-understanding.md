---
layout: post
title: HTTP GET 和 POST 深入理解
description: " HTTP GET 和 POST 深入理解"
category: HTTP
avatarimg: 
tags: [HTTP, GET, POST]
duoshuo: true
---

# 引言

HTTP 的 GET 和 POST 这两种常用的请求方法经常被拿出来对比。  
今天看了一篇深入理解 HTTP GET 和 POST 方法区别的文章，写得不错。  
现在我们来由浅入深看下它们的区别。

#  GET 与 POST 对比

* GET - 从指定的资源请求数据
* POST - 向指定的资源提交要被处理的数据

以下图表来 w3school

|      | GET | POST   | 
|------|------|----------------|
| 后退按钮/刷新 | 无害 | 数据会被重新提交（浏览器应该告知用户数据会被重新提交）。|
| 书签	| 可收藏为书签	| 不可收藏为书签 |
| 缓存	| 能被缓存	| 不能缓存 |
| 编码类型 | application/x-www-form-urlencoded | application/x-www-form-urlencoded 或 multipart/form-data。为二进制数据使用多重编码。|
| 历史 | 参数保留在浏览器历史中。 |	参数不会保存在浏览器历史中。|
| 对数据长度的限制 | 是的。当发送数据时，GET 方法向 URL 添加数据；URL 的长度是受限制的（URL 的最大长度是 2048 个字符）。 |	无限制。|
| 对数据类型的限制 | 只允许 ASCII 字符。 | 没有限制。也允许二进制数据。|
| 安全性 |	与 POST 相比，GET 的安全性较差，因为所发送的数据是 URL 的一部分。在发送密码或其他敏感信息时绝不要使用 GET！| POST 比 GET 更安全，因为参数不会被保存在浏览器历史或 Web 服务器日志中。|
| 可见性 | 数据在 URL 中对所有人都是可见的。| 数据不会显示在 URL 中。|

#  GET 与 POST 深入对比

* GET 和 POST 本质上就是 TCP 连接，并无差别。但是由于 HTTP 的规定和浏览器/服务器的限制，导致它们在应用过程中体现出一些不同。 
* GET 和 POST 还有一个重大区别，简单的说：GET 产生一个 TCP 数据包；POST 产生两个 TCP 数据包。（具体说明请参考 Ref 中的文章）

# Ref
[HTTP 方法：GET 对比 POST](http://www.w3school.com.cn/tags/html_ref_httpmethods.asp)  
[99% 的人都理解错了 HTTP 中 GET 与 POST 的区别](http://mp.weixin.qq.com/s?__biz=MzAwNzA0NTMzMQ==&mid=2653202500&idx=1&sn=aecfb32856ef90361f8106377937391e&chksm=80d421f8b7a3a8ee36b8d64f6491e5267c74b32dcdf77fe406c87aa5030e37b5b39f05a9ea4c&mpshare=1&scene=1&srcid=10080iokRiobEfoloCTGfLHz#rd)  
