---
layout: post
title: VMware 中克隆 CentOS 后的网卡配置
description: "VMware 中克隆 CentOS 后的网卡配置"
category: Linux
avatarimg:
tags: [VMware, CentOS]
duoshuo: true
---

# 引言

新换办公电脑，重新安装了 VMware Workstation，安装 CentOS 6.8 系统进行测试。  
安装好 CentOS 系统后，进行克隆，然后再克隆后的虚拟机中，网卡启动不了。  
提示“device eth0 does not seem to be present”。

# 原因分析

使用 VMware 的克隆功能，会为新产生的虚拟机配置一个与原始虚拟机网卡 MAC 地址不同的网卡。  
对于 CentOS 这样的 Linux 系统，会把运行时的网卡 MAC 地址记入`/etc/udev/rules.d/70-persistent-net.rules`文件中。  
这样克隆好的新系统里也保存了这个记录。  
当新系统启动时，由于 VMware 已经为其配置了不同的 MAC 地址，
因此系统会在启动扫描硬件时把这个新的 MAC 地址的网卡当做是 eth1，并且增加记入上述文件中。
而此时配置文件里的`/etc/sysconfig/network-scripts/ifcfg-eth0`里记录的还是原来的 MAC 地址，  
而这个 MAC 地址在新系统里是不存在的，所以无法启动。


# 解决办法

在新系统里，把 rules 文件里记录的老 MAC 对应的那个 eth0 一行删除掉，然后把新 MAC 对应的 eth1 的名字改为 eth0。  
然后在 ifcfg-eth0 文件里把 HDADDR 的值改为新的 MAC 地址。  
(PS：我遇到的情况与上面有些区别，`/etc/udev/rules.d/70-persistent-net.rules`并没有记录 eth1 的配置，
所以我直接在 ifcfg-eth0 文件里把 HDADDR 的值改为新的 MAC 地址。)

这样 rules 和 ifcfg-eth0 就彼此对应（rules 里的 eth0 对应 ifcfg-eth0 文件名，rules 里的 MAC 对应 ifcfg-eth0 文件里的 HDADDR)好了。
此时需要重新启动系统一切就 OK 了。

# Ref
[CentOS 虚机克隆/复制后网络设置](http://welcome66.iteye.com/blog/2187923)  
[VMware 克隆 CentOS 6后网卡配置](http://www.centoscn.com/CentOS/config/2015/0129/4589.html)  
[克隆 CentOS 6 网卡无法自动识别的解决方法](http://www.ahlinux.com/centos/20603.html)  

