---
layout: post
title:  CentOS 7下配置静态路由
description: "CentOS 7下配置静态路由"
category: Network
avatarimg:
tags: [CentOS, ip, route]
duoshuo: true
---

# 引言
最近在虚拟机下配置CentOS 7，改变挺大。学习然后是重新复习之前的一些知识。  
包括现在要说的配置静态路由（虚拟机需要上网）。


# 1. ip route显示和设定路由

## 1.1 显示路由表

```bash
[root@linux-node1 ~]# ip route show 
default via 192.168.56.2 dev eth0 
169.254.0.0/16 dev eth0  scope link  metric 1002 
192.168.56.0/24 dev eth0  proto kernel  scope link  src 192.168.56.11

[root@linux-node1 ~]# ip route show | column -t       #格式化一下
default          via  192.168.56.2  dev    eth0
169.254.0.0/16   dev  eth0          scope  link    metric  1002
192.168.56.0/24  dev  eth0          proto  kernel  scope   link  src  192.168.56.1
```    

## 1.2 添加静态路由

```bash
[root@linux-node1 ~]# ip route add 192.168.56.0/24 via 192.168.56.2 dev eth0
```    

## 1.3 删除静态路由
只需要把 add 替换成 del，或者更简单的只写目标网络

```bash
[root@linux-node1 ~]# ip route del 192.168.56.0/24
```   

# 2 设置永久的静态路由

## 2.1 添加永久静态路由

> 
ip route 指令对路由的修改不能保存，重启就没了。把 ip route 指令写到 /etc/rc.local 也是徒劳的。
RHEL7官网文档没有提到 /etc/sysconfig/static-routes，经测试此文件已经无效；
/etc/sysconfig/network 配置文件仅仅可以提供全局默认网关，语法同 Centos6 一样： GATEWAY=<ip address> ；
永久静态路由需要写到 /etc/sysconfig/network-scripts/route-interface 文件中，比如添加两条静态路由：

```bash
[root@linux-node1 network-scripts]# cat /etc/sysconfig/network-scripts/route-eth0
10.18.196.0/255.255.254.0 via 192.168.56.11 dev eth0

[root@linux-node1 network-scripts]# nmcli dev connect eth0 #重启计算机，或者重新启用设备eth0才能生效。

[root@linux-node1 network-scripts]# nmcli dev disconnect eth0 && nmcli dev connect eth0
# 一般直接连接一次设备即可，如果不成功就先断开设备再连接设备，注意必须两个指令一起运行

```    

## 2.2 清除永久静态路由
> 
可以删除route-eth0文件或者注释掉文件里的相应静态路由条目，重启计算机。  
想要让修改后的静态路由立即生效，只能用 ip route del 手工删除静态路由条目。


# Ref
[Centos7添加静态路由](http://www.cnblogs.com/panblack/p/Centos7_Static_Routes.html)  
[Centos7系统配置上的变化（二）网络管理基础](http://www.cnblogs.com/panblack/p/Centos7-WhatsNew-02-networking.html)  
[⁠11.4. Static Routes and the Default Gateway](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s1-networkscripts-static-routes.html)  
