---
layout: post
title: Keepalived 简介
description: "Keepalived 简介"
category: Web
avatarimg:
tags: [LB, Keepalived, VRRP]
duoshuo: true
---

# 引言
前面一直讲各种具体的负载均衡软件（LVS，HAProxy, Nginx等），它们一般同时来实现集群的高可用，  
但这个负载均衡软件本身还存在单点故障，所以我们也要实现负载均衡软件的高可用，一般我们使用 Keepalived 来实现的。

# Keepalived 简介

<pre>

What is Keepalived ?

Keepalived is a routing software written in C. 
The main goal of this project is to provide simple and robust facilities for loadbalancing and 
high-availability to Linux system and Linux based infrastructures. 
Loadbalancing framework relies on well-known and widely used Linux Virtual Server (IPVS) kernel module 
providing Layer4 loadbalancing. 
Keepalived implements a set of checkers to dynamically and adaptively maintain and 
manage loadbalanced server pool according their health. 
On the other hand high-availability is achieved by VRRP protocol. 
VRRP is a fundamental brick for router failover. 
In addition, Keepalived implements a set of hooks to the VRRP finite state machine 
providing low-level and high-speed protocol interactions. 
Keepalived frameworks can be used independently or all together to provide resilient infrastructures.

</pre>

<pre>
从这段描述中，我们可以得到几个有用的信息：

1、 keepalived 是lvs 的扩展项目，因此它们之间具备良好的兼容性。这点应该是keepalived部署比其他类似工具能更简洁的原因吧！
2、 通过对服务器池对象的健康检查，实现对失效机器/服务的故障隔离。
3、 负载均衡器之间的失败切换 failover，是通过VRRPv2（Virtual Router Redundancy Protocol）stack 实现的。
</pre>

几个推荐的学习资料参考 Ref。

# Ref
[Keepalived 官网](http://www.keepalived.org/)  
[LVS + Keepalived Chinese application doc](http://www.keepalived.org/pdf/sery-lvs-cluster.pdf)  
Keepalived 权威指南
