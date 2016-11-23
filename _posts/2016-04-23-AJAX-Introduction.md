---
layout: post
title: AJAX 简介
description: "AJAX 简介"
category: Web
avatarimg:
tags: [AJAX, JavaScript, XML, HTML]
duoshuo: true
---

# 引言

最近遇到一些浏览器前端及与服务器通信交互的疑问。  
这里面涉及到各种技术，作为运维，我们不是专门的 Web 开发者，但一些基础概念我们可以了解下。  

# AJAX 简介

<pre>
AJAX 即 “Asynchronous JavaScript and XML”（异步的 JavaScript 与 XML 技术），
指的是一套综合了多项技术的浏览器端网页开发技术。
Ajax 的概念由杰西·詹姆士·贾瑞特所提出。

传统的 Web 应用允许用户端填写表单（form），当送出表单时就向网页服务器发送一个请求。
服务器接收并处理传来的表单，然后送回一个新的网页，但这个做法浪费了许多带宽，
因为在前后两个页面中的大部分 HTML 码往往是相同的。
由于每次应用的沟通都需要向服务器发送请求，应用的回应时间依赖于服务器的回应时间。
这导致了用户界面的回应比本机应用慢得多。

与此不同，AJAX 应用可以仅向服务器发送并取回必须的数据，并在客户端采用 JavaScript 处理来自服务器的回应。
因为在服务器和浏览器之间交换的数据大量减少（大约只有原来的5%）,服务器回应更快了。
同时，很多的处理工作可以在发出请求的客户端机器上完成，因此 Web 服务器的负荷也减少了。

类似于 DHTML 或 LAMP，AJAX 不是指一种单一的技术，而是有机地利用了一系列相关的技术。
虽然其名称包含 XML，但实际上数据格式可以由 JSON 代替，进一步减少数据量，形成所谓的AJAJ。
而客户端与服务器也并不需要异步。一些基于 AJAX 的“派生／合成”式（derivative/composite）的技术也正在出现，如AFLAX。

</pre>


# Ref
[AJAX Wiki](https://zh.wikipedia.org/wiki/AJAX)  
[AJAX 教程](http://www.w3school.com.cn/ajax/index.asp)  

