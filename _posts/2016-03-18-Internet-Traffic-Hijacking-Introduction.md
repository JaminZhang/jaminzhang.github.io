---
layout: post
title: 互联网流量劫持简介
description: "互联网流量劫持简介"
category: Security
avatarimg:
tags: [Traffic-Hijacking, HTTP, HTTPS, DNS,HTTP-DNS]
duoshuo: true
---

# 引言
最近看到一些关于网站升级到 HTTPS 的报道，其中一个原因就是防止运营商流量劫持。  
那么流量劫持是什么呢？有哪些解决方案？下面这篇关于流量劫持文章写得比较好，也是我喜欢的文风。  
我就把目录贴出来，具体内容请跳转过去阅读。

# 关于互联网流量劫持分析及可选的解决方案

[关于互联网流量劫持分析及可选的解决方案](http://www.jianshu.com/p/eff9553c8b64#)

# 一、劫持的方式分析  

## 1、DNS劫持

## 2、链路劫持

# 二、可选的解决方案

## 1、被动监测型

### 1）真机模拟型

###  2）插入SDK型

##2、主动防御型

### 1）绕过运营商 local DNS，使用公共的 DNS

### 2）抛弃域名访问方式，直接进行通过 IP 访问(HTTP-DNS)

### 3）https

# 三、选取何种解决方案

# Ref
[关于互联网流量劫持分析及可选的解决方案](http://www.jianshu.com/p/eff9553c8b64#)  
[亲历的一次某电商网站链路劫持分析](http://www.jianshu.com/p/0397a89057a9)  
[针对某电商网站流量劫持案例分析与思考](http://www.freebuf.com/vuls/62561.html)  
