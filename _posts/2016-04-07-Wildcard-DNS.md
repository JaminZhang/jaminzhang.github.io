---
layout: post
title: 域名泛解析
description: "域名泛解析"
category: DNS
avatarimg:
tags: [DNS, Wildcard]
duoshuo: true
---

# 引言
由于现在维护的业务是游戏类，并没有涉及到网站类，所以域名泛解析涉及得比较少。  
有些概念知道就是知道，长时间不接触也会忘记准备定义，现在我们重新要看下它的定义，

# 什么是域名泛解析

域名泛解析是指：利用 * （星号）来做次级域名以实现所有的次级域名均指向同一 IP 地址。  

例如您的域名是 a.com，设置泛解析（*.a.com）后，所有该域名下的次级域名（如 b.a.com）都将指向与 a.com 相同的一个独立 IP 地址。（除单独设置的子域名解析）  

您可以通过添加一个主机名为 * 的域名解析记录来将域名泛解析至您服务器的独立 IP 地址。  

# 域名泛解析设置方法

登录你的域名管理后台配置，增加一个 *.xxx.com 的次级域名 A 记录指向你的 IP

# Ref
[域名泛解析设置](http://www.cnblogs.com/zhangweizhong/p/4806655.html)  
[域名泛解析设置方法](https://help.aliyun.com/knowledge_detail/39797.html)  
[DNS服务系列之一：泛域名解析的安全案例](http://laoxu.blog.51cto.com/4120547/1282773)  
[Wildcard DNS record](https://en.wikipedia.org/wiki/Wildcard_DNS_record)  
[Setting Up WildCard DNS](https://sg.godaddy.com/zh/help/setting-up-wildcard-dns-3301)  
