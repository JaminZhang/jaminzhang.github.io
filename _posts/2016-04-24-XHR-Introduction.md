---
layout: post
title: XHR 简介
description: "XHR 简介"
category: Web
avatarimg:
tags: [XHR]
duoshuo: true
---

# 引言

前面对 AJAX 技术做了简介。下面就来了解下 AJAX 的基础 XHR。

# XHR 简介

XMLHttpRequest(XHR) 是 AJAX 的基础。  

<pre>
XMLHttpRequest 对象

所有现代浏览器均支持 XMLHttpRequest 对象（IE5 和 IE6 使用 ActiveXObject）。
XMLHttpRequest 用于在后台与服务器交换数据。
这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。

所有现代浏览器（IE7+、Firefox、Chrome、Safari 以及 Opera）均内建 XMLHttpRequest 对象。

XMLHttpRequest 对象用于和服务器交换数据。

</pre>


<pre>

XMLHTTP 是一组 API 函数集，可被 JavaScript、JScript、VBScript 以及其它 web 浏览器内嵌的脚本语言调用，
通过 HTTP 在浏览器和 web 服务器之间收发 XML 或其它数据。
XMLHTTP 最大的好处在于可以动态地更新网页，它无需重新从服务器读取整个网页，也不需要安装额外的插件。
该技术被许多网站使用，以实现快速响应的动态网页应用。
例如：Google 的 Gmail 服务、Google Suggest 动态查找界面以及 Google Map 地理信息服务。
XMLHTTP 是 AJAX 网页开发技术的重要组成部分。
除 XML 之外，XMLHTTP 还能用于获取其它格式的数据，如 JSON 或者甚至纯文本。

</pre>


# Ref
[AJAX XHR](http://www.w3school.com.cn/ajax/ajax_xmlhttprequest_create.asp)  
[XMLHTTP Wiki](https://zh.wikipedia.org/wiki/XMLHTTP)  
