---
layout: post
title:  CentOS 7下恢复旧式网卡命名方式
description: " CentOS 7下恢复旧式网卡命名方式"
category: Linux
avatarimg:
tags: [CentOS,NIC]
duoshuo: true
---

# 引言
这两天需要安装一个CentOS 7系统，安装说明中提到了，不使用CentOS 7默认的网卡命名规则，  
而是使用CentOS 5系列“ethX”这种旧式命名规则。  
现在我们先来看看为什么在CentOS 7中使用新式的命名规则。

# CentOS 7网卡命名规则
> 
CentOS 7网卡命名变化的原因，是由于systemd 和 udev 引入了一种新的网络设备命名方式–一致网络设备命名（CONSISTENT NETWORK DEVICE NAMING） 。
可以根据固件、拓扑、位置信息来设置固定名字，带来的好处是命名自动化，名字完全可预测，在硬件坏了以后更换也不会影响设备的命名，
这样可以让硬件的更换无缝化。带来的不利是新的设备名称比传统的名称难以阅读。比如心得名称是enp5s0.

关于网卡一致性命名规则更详细说明，可参考如下资料：  
[Predictable Network Interface Names](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/)  
[Centos 7中的网卡一致性命名规则 ](http://blog.sina.com.cn/s/blog_704836f40102w36n.html)  

了解了一致性网络设备命名规则和优缺点后，根据自己的需求选择是否接受，这里我这边不想使用一致网络设备命名这种方式，想使用旧式的网卡命名方式。
下面来看看具体怎么设置。  

# CentOS 7下恢复旧式网卡命名方式

参考CentOS官方文档，如下：  

> 
And what if I want the old naming back?  
These are the necessary steps:  
1.Add "net.ifnames=0" and "biosdevname=0" as kernel arguments to grub  
2.In '/etc/sysconfig/network-scripts/' Change your configured NIC config file to 'ifcfg-ethX'  
3.If you have multiple interfaces and want to control naming of each device rather than letting the kernel do in its own way, 
/etc/udev/rules.d/60-net.rules seems necessary to override /usr/lib/udev/rules.d/60-net.rules.

# Ref
[Questions about CentOS-7](https://wiki.centos.org/FAQ/CentOS7#head-31ebc6642958a0df12304d6aab9a49034a3b7802)  
[RHEL7: How to restore the old network interface name.](https://www.certdepot.net/rhel7-restore-old-network-interface-name/)  
[Centos 7 系统安装完毕修改网卡名为eth0](http://jingyan.baidu.com/article/7f41ecec1b022e593d095c1e.html)  
[CentOS 7下网卡重新命名](http://www.linuxidc.com/Linux/2014-07/104537.htm)  





