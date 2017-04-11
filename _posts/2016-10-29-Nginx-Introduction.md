---
layout: post
title: Nginx 介绍
description: "Nginx 介绍"
category: Nginx
avatarimg:
tags: [Web, LB, Nginx, Proxy]
duoshuo: true
---


# Nginx 介绍

<pre>

Nginx 是目前比较主流的 HTTP 反向代理服务器，对于构建大型分布式 Web 应用，具有举足轻重的作用。  
简单来说，Nginx 有 2 个主要的功能：动/静态资源分离、负载均衡。  
 
动/静态资源分离：
Nginx 支持正则表达式以区分静态资源或者动态资源，其中动态资源可以进一步转发给后端的 Proxy Server，  
而静态资源则可以在 Nginx 层面使用本地缓存策略或者重定向（类 CDN）到其他 Nginx 上。

负载均衡：
对于动态资源而言，如果有多个 Proxy Server，那么 Nginx 将会根据一定的算法选择合适的 Server，
并转发请求，最终将客户端 Request 相对均衡的分发给多个 Server。
 
 Nginx 作为“单点”，面向客户端请求，并将请求转发给后端的某个 Server，因为 Server 可以有多个，
 那么从整体而言，提升了站点的“资源整合”能力，提升了站点的整体吞吐能力；
但因为受限于 Nginx 本身的 IO 模型，并没有“降低”对物理资源的消耗（即性能开支）；
通常 Nginx 作为整个站点的“避雷针”和导流通道，它应该被架设在物理资源较为优越的机器上，
比如 8U 物理机，32 核心，64G 内存，对磁盘要求相对较低，对 CPU、内存、网卡带宽有较高的要求，
因为 Nginx 不仅需要和客户端请求建立链接，而且还需要与后端 Proxy Server 建立链接并且负责流量输入、输出
（这和 LVS、HAProxy 有本质区别），这种双倍的链接建立，就要求机器具有较高的内存和 CPU，
如果你的 Nginx 还有大量的“静态资源” Cache，还需要使用高速、高容量的磁盘。
因为 Nginx 节点最终为所有 Proxy Server 流量的总和，那么它应该具有更高的网卡带宽。
 
为了避免资源竞争，应该避免 Nginx 和 Web Server 部署在同一个节点上，
因为 Web Server 通常为 CPU 和内存高耗型，这会大大降低 Nginx 的代理能力。

1) 在中小型应用中（PV 在 KW 级别，单一垂直 Web 应用），通常一个 Nginx 代理多个（组）Server 即可。
2）对于大中型应用，一个 Nginx 将无法支撑全部的流量，我们将会采用多个 Nginx 代理（复制了 1）中的架构模型，
   并在 Nginx 前端继续构建高性能的分流设备，比如 LVS、HAProxy 等更低层的软/硬件负载均衡器，
   这种负载均衡器通常只是“转发”，而不涉及到流量的输出，所以转发效率将会更高，承载能力更强。
3）无论何时，我们也不希望 Nginx 存在单点故障问题，那么通常我们还需要使用 Keepalived（其他同类型技术，VIP）
   来提高 Nginx 节点的可用性，即 Master-Backup 模式。
4）当有多个 Nginx 时，为了提升后端 Server 的代理能力，通常还会让多个 Nginx 之间交叉重叠代理后端的 Server。

</pre>


![Nginx 使用模型](http://dl2.iteye.com/upload/attachment/0110/3954/bca4ce00-451d-35bf-ad5a-43005b5a6006.png)

# Ref
[Nginx 学习总结概述(一)](http://shift-alt-ctrl.iteye.com/blog/2229578)  
