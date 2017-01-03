---
layout: post
title: HTTP 报文简介
description: "HTTP 报文简介"
category: HTTP
avatarimg: 
tags: [HTTP]
duoshuo: true
---


# 引言
最近遇到一个别人问的一个关于 HTTP 报文具体组成的问题，当时自己回答时，把相关顺序弄错了，
说明自己没理解掌握好，没有经常使用。这里重新学习理解下。


# HTTP 报文简介

HTTP 报文是由一行一行的简单字符串组成的。  
HTTP 报文都是纯文本，不是二进制代码，所以人们可以很方便地对其进行读写。

从 Web 客户端发往 Web 服务器的 HTTP 报文称为**请求报文**（request message）。  
从服务器发往客户端的报文称为**响应报文**（response message），此外没有其他类型的 HTTP 报文。  
HTTP 请求和响应报文的格式很类似。  

HTTP 报文包括以下三个部分。

## 1. 起始行

报文的第一行就是起始行，在请求报文中用来说明要做些什么，在响应报文中说明出现了什么情况。

## 2. 首部字段

起始行后面有零个或多个首部字段。每个首部字段都包含一个名字和一个值，为
了便于解析，两者之间用冒号（:）来分隔。
首部以一个空行结束。添加一个首部字段和添加新行一样简单。


## 3. 主体

空行之后就是可选的报文主体了，其中包含了所有类型的数据。  
请求主体中包括了要发送给 Web 服务器的数据；响应主体中装载了要返回给客户端的数据。  
起始行和首部都是文本形式且都是结构化的，而主体则不同，主体中可以包含任意
的二进制数据（比如图片、视频、音轨、软件程序）。
当然，主体中也可以包含文本。


## 请求与响应报文结构图示

![HTTP Message Example](http://images0.cnblogs.com/blog2015/776887/201507/241034588189239.png)  

![HTTP Message Structure](http://upload-images.jianshu.io/upload_images/650075-6d7ed800f9ab8579.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  

![HTTP Request Message Structure](http://upload-images.jianshu.io/upload_images/650075-ce290675985dd780.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  

![HTTP Response Message Structure](http://upload-images.jianshu.io/upload_images/650075-2c152be714d4cff8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)　

# Ref
《 HTTP 权威指南》  
《图解HTTP》  
[HTTP学习笔记1：HTTP报文](http://www.jianshu.com/p/47e1ca7b1948)  
[http报文详解](http://www.cnblogs.com/klguang/p/4618526.html)  
