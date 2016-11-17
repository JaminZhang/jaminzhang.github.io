---
layout: post
title: PHP SAPI 概念理解
description: "PHP SAPI 概念理解"
category: Web
avatarimg:
tags: [PHP, SAPI]
duoshuo: true
---

# 引言
前面一篇文章学习理解了 CGI 相关概念，那么 PHP SAPI 又是什么呢？  
我的理解是 CGI　算　SAPI 的一种实现。CGI 和 CLI 都是 SAPI 的类型。

# SAPI 是什么

SAPI (Server Application Programme Interface) “服务器应用程序接口”，可以认为是服务器端的 API。  

# PHP 中的 SAPI

在 PHP 应用中，SAPI 是应用层（比如 Apache，Nginx，CLI 等）和 PHP 交互数据的入口。

而就是 SAPI 这个入口，使得 PHP 和其上面的应用层解耦合了。  

SAPI 实现了和各种应用层的兼容，应用层可以根据自身情况，定制 SAPI，比如：  

1. apache2handler 和 apache2filter，这是提供给 Apache mod_php 的 SAPI；
2. cgi，Web Server fork 出 cgi 进程使用的 sapi；
3. fastcgi，Web Server 采用网络通信或者网络 IPC 和 PHP 交换数据的 SAPI；
4. cli，命令行方式运行 PHP 脚本的 SAPI。


# Ref
[说说php的sapi (cgi fastcgi .etc.)](http://blog.csdn.net/fangru/article/details/9137079)  
