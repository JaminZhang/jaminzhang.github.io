---
layout: post
title: iptables 防火墙配置实例
description: "iptables 防火墙配置实例"
category: Linux
avatarimg:
tags: [iptables]
duoshuo: true
---


# 引言

防火墙我这边的负责业务接触的比较少，之前学习过，很久不用就忘记了，  
现在我这里重新记录一下常见的防火墙配置实例，以利于自己的理解记忆。


# 实例

1. 禁止 192.168.1.10 连接服务器的 80 端口

>
iptables -A INPUT -p tcp --dport 80 -s 192.168.1.10 -j DROP


# Ref
[Linux上iptables防火墙的基本应用教程](http://www.vpser.net/security/linux-iptables.html)  
