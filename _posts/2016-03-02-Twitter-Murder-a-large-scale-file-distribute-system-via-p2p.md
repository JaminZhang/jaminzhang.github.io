---
layout: post
title: Twitter的大规模文件P2P分发系统-Murder
description: "Twitter的大规模文件P2P分发系统-Murder"
category: Linux
avatarimg:
tags: [Murder, P2P, BT]
duoshuo: true
---

# 引言
公司软件包发布系统是使用的单一的发布节点，当进行小文件的发布时并不体会到性能方面的问题，  
但在进行大规模的大文件发布时，明显看到耗费时间实在是太多了。分发一个80M左右的软件包到800台机器时，耗费了30多分钟。  
所以必须想办法解决这个问题，提高大规模大文件发布效率与性能。于是，先来考察市面上是否有相关开源解决方案。  

# Twitter开源项目Murder介绍
如题，恰巧听人介绍了这个项目，完全适合解决上面的问题啊。

它的GitHub主页上的简介就是：
>
Large scale server deploys using BitTorrent and the BitTornado library

Murder项目来龙去脉：
> 
Twitter在早期便依赖Capistrano来进行应用程序的部署，每当有新版本的程序代码需要发布时，Capistrano会根据预设好的各种设置、流程到Twitter所有的服务器上进行更新的操作，在过去服务器还不多的情況下一切都很美好，但随着Twitter服务器数量的增长，到了几百台服务器时，事情已经不再像过去一样美好，甚至到后来拥有数千台服务器时，更新的操作会耗费40分钟。

> 
Twitter针对这个问题，认为问题的关键在于：使用集中式的系统，也就是所有的服务器要轮流排队到同一台版本控制系统上进行代码更新。Twitter最初的想法是将版本控制系统也做出分散式的架构，服务器的代码更新就可以分散到不同的机器来压缩部署时间，但事实上版本控制系统即使分散在多台服务器上，这些服务器要更新文件也同样需要时间。因此Twitter发现或许需要一个完全去中心化、最好是像BitTorrent这样的，利用P2P的特点让所有的节点都可以协助进行程序代码的更新。

> 
从结果来看，在采用了BitTorrent的方式来更新代码，部署的时间从40分钟大幅减少到只要12秒！实在是非常惊人的改善，数千台服务器的代码更新居然只要短短12秒就能完成。


接下来需要花些时间验证测试下这个P2P方式的发布。

# Ref
[GitHub Murder](https://github.com/lg/murder)  
[Twitter如何在数千台服务器上快速部署代码？](http://news.cnblogs.com/n/70899/)  
[Twitter开源项目Murder：缩短部署更新时间](http://tech.qq.com/a/20100716/000424.htm)  
[Twitter的P2P分发系统](https://www.douban.com/note/77977338/)  
[华为蘑菇云设计进展与规划](http://files.meetup.com/13664792/huawei%20mashroom%20cloud%20CF%20meetup-20150314.pdf)  
[Herd - A single-command bittorrent distribution system, based on Twitter's Murder](https://github.com/russss/Herd)  

