---
layout: post
title: MIME学习
description: "MIME学习"
category: HTTP
avatarimg:
tags: [MIME]
duoshuo: true
---

# 引言
经常看到MIME这个名词，下面来了解一下MIME的定义及作用。

# 什么是MIME？
<pre>
Multipurpose Internet Mail Extensions (MIME) is an Internet standard that extends the format of email to support:

Text in character sets other than ASCII
Non-text attachments: audio, video, images, application programs etc.
Message bodies with multiple parts
Header information in non-ASCII character sets

Virtually all human-written Internet email and a fairly large proportion of automated email is transmitted via SMTP in MIME format.
MIME is specified in six linked RFC memoranda: RFC 2045, RFC 2046, RFC 2047, RFC 4288, RFC 4289 and RFC 2049; 
with the integration with SMTP email specified in detail in RFC 1521 and RFC 1522.

Although MIME was designed mainly for SMTP, the content types defined by MIME standards are also of importance outside of email, 
such as in communication protocols such as HTTP for the World Wide Web. 
Servers insert the MIME header at the beginning of any Web transmission. 
Clients use this content type or media type header to select an appropriate "player" application for the type 
of data the header indicates. Some of these players are built into the Web client or browser 
(for example, almost all browsers come with GIF and JPEG image players as well as the ability to handle HTML files); 
other players may need to be downloaded.

</pre>

以上来自wikipedia，MIME一个互联网标准，它扩展了Email支持的格式。  
MIME标准定义的内容类型在除了Email之外的领域也很重要，比如HTTP。

# HTTP也使用MIME
因特网上有数千种不同的数据类型，HTTP 仔细地给每种要通过Web 传输的对象都打上了名为MIME 类型（MIME type） 的数据格式标签。  
最初设计MIME（Multipurpose Internet Mail Extension，多用途因特网邮件扩展）是为了解决在不同的电子邮件系统之间搬移报文时存在的问题。  
MIME 在电子邮件系统中工作得非常好，因此HTTP 也采纳了它，用它来描述并标记多媒体内容。  

Web 服务器会为所有HTTP 对象数据附加一个MIME 类型。当Web浏览器从服务器中取回一个对象时，会去查看相关的MIME 类型，
看看它是否知道应该如何处理这个对象。大多数浏览器都可以处理数百种常见的对象类型：显示图片文件、解析并格式化HTML文件、
通过计算机声卡播放音频文件，或者运行外部插件软件来处理特殊格式的数据。

# Ref
[MIME Wikipedia](https://en.wikipedia.org/wiki/MIME)  
[什么是 MIME TYPE](http://www.cnblogs.com/jsean/articles/1610265.html)  
[Media Types](http://www.iana.org/assignments/media-types/media-types.xhtml)  

