---
layout: post
title: VMware中克隆CentOS后的网卡配置
description: "VMware中克隆CentOS后的网卡配置"
category: Linux
avatarimg:
tags: [VMware, CentOS]
duoshuo: true
---

# 引言
新换办公电脑，重新安装了VMware Workstation，安装CentOS 6.8系统进行测试。  
安装好CentOS系统后，进行克隆，然后再克隆后的虚拟机中，网卡启动不了。提示“device eth0 does not seem to be present”。

# 原因分析
使用VMware的克隆功能，会为新产生的虚拟机配置一个与原始虚拟机网卡MAC地址不同的网卡。对于CentOS这样的Linux系统，会把运行时的网卡MAC地址记入/etc/udev/rules.d/70-persistent-net.rules文件中。这样克隆好的新系统里也保存了这个记录。
当新系统启动时，由于VMware已经为其配置了不同的MAC地址，因此系统会在启动扫描硬件时把这个新的MAC地址的网卡当做是eth1，并且增加记入上述文件中。而此时配置文件里的/etc/sysconfig/network-scripts/ifcfg-eth0里记录的还是原来的MAC地址，而这个MAC地址在新系统里是不存在的，所以无法启动。


#解决办法
在新系统里，把rules文件里记录的老MAC对应的那个eth0一行删除掉，然后把新MAC对应的eth1的名字改为eth0。然后在ifcfg-eth0文件里把HDADDR的值改为新的MAC地址。
(PS:我遇到的情况与上面有些区别，/etc/udev/rules.d/70-persistent-net.rules并没有记录eth1的配置，所以我直接在ifcfg-eth0文件里把HDADDR的值改为新的MAC地址。)

这样rules和ifcfg-eth0就彼此对应（rules里的eth0对应ifcfg-eth0文件名，rules里的mac对应ifcfg-eth0文件里的HDADDR)好了。此时需要重新启动系统一切就OK了。

# Ref
[centos虚机克隆/复制后网络设置](http://welcome66.iteye.com/blog/2187923)  
[VMware克隆CentOS 6后网卡配置](http://www.centoscn.com/CentOS/config/2015/0129/4589.html)  
[克隆CentOS 6网卡无法自动识别的解决方法](http://www.ahlinux.com/centos/20603.html)  

