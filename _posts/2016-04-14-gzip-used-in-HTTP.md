---
layout: post
title: 
description: "HTTP 中使用 gzip"
category: Web
avatarimg:
tags: [HTTP, gzip]
duoshuo: true
---

# 引言
网站性能优化最常见的一个点是对一些静态资源启用 gzip 压缩，  
这样可以加快网站资源文件下载速度，同时也减少带宽流量。  
现在我们来重新学习了解 gzip 及在 Nginx 中的配置使用。  

# gzip 简介

<pre>
Gzip是若干种文件压缩程序的简称，通常指GNU计划的实现，此处的gzip代表GNU zip。也经常用来表示gzip这种文件格式。

HTTP/1.1 协议允许客户端选择要求从服务器下载压缩内容，这个标准本身定义了三种压缩方法：“gzip”（内容用gzip数据流进行封装）、
“compress”（内容用compress数据流进行封装）以及“deflate”（内容是原始格式、没有数据头的DEFLATE数据流）[4]。
许多 HTTP 客户端库、服务器平台和绝大多数现代浏览器都支持前后两种格式。
</pre>

# 开启 Nginx 的 gzip 压缩功能

这个网上有太多的资料了，我这里就不写了，可以直接去看 Nginx 官网文档和 Ref 中的相关文章。

# Ref
[gzip](https://zh.wikipedia.org/wiki/Gzip)  
[Module ngx_http_gzip_module](http://nginx.org/en/docs/http/ngx_http_gzip_module.html)  
[开启 Nginx 的 Gzip 压缩功能](https://www.insp.top/article/open-nginx-gzip-module)
