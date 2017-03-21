---
layout: post
title:  CentOS 6 下网卡名称以 em 开头原因
description: "CentOS 6 下网卡名称以 em 开头原因"
category: Linux
avatarimg:
tags: [Linux, CentOS, NIC, biosdevname, Dell]
duoshuo: true
---


# 引言

今天登录一台物理机，查看网卡是 em 开头的，
以前知道在 `/boot/grub/grub.conf` 的内核 kernel 中添加一个参数 `biosdevname=0` 可以恢复以前 eth 开头的命名规则。  
但更具体的原因没有查过，这里就查下。

# CentOS 6 中网卡名以 em 开头原因

这是由于 biosdevname 导致的。  
在RHEL 6/CentOS 6中，默认 biosdevname 是关闭的，但是当服务器是 Dell 的时候就变成开启的。  
biosdevname 是由 Dell 开发的工具，旨在为网络设备的命名理清思路。  
biosdevname 是一款 udev 帮助程序，可根据系统 BIOS 提供的信息对网络接口进行重命名。  
 
PS:
刚才发现之前写过这个原因的博文[CentOS 7下恢复旧式网卡命名方式](http://jaminzhang.github.io/linux/restore-old-nic-name-in-CentOS-7/)，
竟然忘记了，只记得配置方法，不过这里还是再记录写一篇回顾理解。 
 

# Ref

[为什么 RedHat 6/CentOS 6 里看到的网卡是 em*？](https://my.oschina.net/erichd/blog/499596)  
[RHEL6（Red Hat Enterprise Linux 6） SP1 在戴尔系统上，带有意义的网络设备命名](http://zh.community.dell.com/techcenter/b/weblog/archive/2011/07/05/meaningful-names-for-network-devices-in-rhel-6-sp1-on-dell-systems)  
[Consistent Network Device Naming in Linux](http://linux.dell.com/files/whitepapers/consistent_network_device_naming_in_linux.pdf)  
