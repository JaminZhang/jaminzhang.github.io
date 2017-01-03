---
layout: post
title: Cobbler 之服务器重启自动安装操作系统问题
description: "Cobbler 之服务器重启自动安装操作系统问题"
category: Automated Ops
avatarimg:
tags: [Linux, Cobbler, koan]
duoshuo: true
---

Cobbler 之服务器重启自动安装操作系统问题

# 引言
最近遇到有人问我一个关于 Cobbler 的问题，Cobbler 相关有好长时间没有接触了，
所以忘记了，主要我认为是没有深入理解 Cobbler 自动安装操作系统的原理和过程，所以没回答好，这里回顾然后记录下。  
问题是：使用 Cobbler 自动安装操作系统，服务器重启后会重新安装操作系统吗？如果会，怎么避免。

# Cobbler 之服务器重启自动安装操作系统问题

首先，引言中的问题可以分为两种情况来分析。

**1.服务器是裸机，上面没有操作系统**

这种情况下，我们一般可以配置根据机器的 MAC 地址，自动绑定 IP，网关，DNS 等定制一个 Cobbler system。
这个时候重启服务器，不管开机引导介质的顺序为何（硬盘、光盘、网络等），服务器硬盘上面由于没有操作系统，也没有光盘，所以会从网络启动，和 Cobbler Server 连接进行操作系统重装。  

经过上面的分析，新的裸机服务器，配置好对应的 Cobbler system，重启后会自动安装操作系统，如果想避免，就不配置对应的 Cobbler system。
而且 Cobbler 默认也是从 local 本地磁盘引导启动。

**2.服务器上已有操作系统，需要进行重装**

这种情况下，重启后，服务器开机引导介质一般应该首先是硬盘，这时不会重装安装操作系统，如果想重装安装，需要配置首选开机启动介质为网络启动然后会连接 Cobbler 进行系统重装（如果配置对应的 Cobbler system，可以实现自动化）。还有一个 koan 客户端可以进行系统重装，指定 Cobbler Server 和 Profile 就可以在重启后进行对应系统的重装（会修改 Grub 启动引导菜单，从而避免从硬盘启动时而跳过网络启动实现自动重装）。

如何避免 koan 安装错误机器，或者 Cobbler 自动化安装错误机器。
解决方法：
环境设计：配置装机专用 VLAN

# Ref
[Cobbler 自动化部署实践](http://jaminzhang.github.io/automated%20ops/Cobbler-automate-deployment-practice/)  
