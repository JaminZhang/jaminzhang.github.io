---
layout: post
title: 了解异地多活
description: "了解异地多活"
category: Architecture
avatarimg:
tags: [Architecture, Multi-Datacenter]
duoshuo: true
---


# 引言
"异地多活" 这个概念在近 2 年在国内经常被提起。  
业界有一些成熟的方案，例如阿里的单元化方案，按用户把业务封闭在一个单元里；腾讯的set方案，还有微博的跨机房方案。下面的我们收集一下相关资料来了解下它们的"异地多活"怎么做的。


# 异地多活业界方案

[专访阿里巴巴毕玄：异地多活数据中心项目的来龙去脉](http://www.infoq.com/cn/articles/interview-alibaba-bixuan)  
[微博“异地多活”部署经验谈](http://www.infoq.com/cn/articles/weibo-multi-datacenter-deployments)  
[腾讯十多个人管理一万多台NoSQL存储服务器的秘密](http://os.51cto.com/art/201601/503525.htm)   
[异地多活](http://www.infoq.com/cn/multi-datacenter)   
[魅族多机房部署方案](http://blog.csdn.net/tech_meizu/article/details/49861667)  


# 异地多活优势

根据以上业界方案总结如下部分：

* 异地灾备
* 动态加速
* 流量均衡
