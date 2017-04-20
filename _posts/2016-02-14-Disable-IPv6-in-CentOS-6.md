---
layout: post
title: CentOS 6 中禁用 IPv6
description: "CentOS 6 中禁用 IPv6"
category: Network
avatarimg:
tags: [Network, IPv6, CentOS]
duoshuo: true
---

# 引言

<pre>

众所周知，IPv6 是为了解决 IPv4 地址耗尽的问题，但是并不是每个人都在使用它，也不是所有的硬件支持它，
取代 IPv4 是大趋所致迟早的事情，IPv4 会在悠悠岁月中慢慢退出而不会一蹴而就的。

在某些情况下，可能会发现禁用 IPv6 不仅仅会加快网络，还会有助于减少管理开销和提高安全级别。
CentOS6 / RHCE6 系统默认已经启用 IPv6 了。

</pre>

# CentOS 6 中禁用 IPv6

网上相当一部分资料谈到的方法是禁用 IPv6 模块，我们线上服务器也是禁用 IPv6 模块，并没有遇到什么问题。  
但 CentOS 官方网站并不推荐使用禁用 IPv6 模块的方法，因为这样会引起 SELinux 和其他组件的问题。  
推荐的方法如下：

## 配置 /etc/sysctl.conf

```bash

net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1

```    

## 在运行的系统中禁用

```bash

echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6

# 或者
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

```    

# Ref
[How do I disable IPv6?](https://wiki.centos.org/FAQ/CentOS6#head-d47139912868bcb9d754441ecb6a8a10d41781df)  
[CentOS 6/RHCE 6 禁用 IPv6 协议模块](http://www.ttlsa.com/linux/centos6-rhce6-disables-the-ipv6-protocol-module/)  
