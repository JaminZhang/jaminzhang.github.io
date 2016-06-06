---
layout: post
title: IPMI 学习
description: "IPMI 学习"
category: Hardware
avatarimg:
tags: [Hardware, Monitoring, IPMI]
duoshuo: true
---

# IPMI 简介
> 
IPMI是智能型平台管理接口（Intelligent Platform Management Interface）的缩写，是管理基于 Intel结构的企业系统中所使用的外围设备采用的
一种工业标准，该标准由英特尔、惠普、NEC、美国戴尔电脑和SuperMicro等公司制定。用户可以利用IPMI监视服务器的物理健康特征，
如温度、电压、风扇工作状态、电源状态等。而且更为重要的是IPMI是一个开放的免费标准，用户无需为使用该标准而支付额外的费用。

Linux 可以使用 IPMI 和 BMC 控制器通信，监控和控制硬件设备。
  
  ipmitool  
    1. 硬件要支持  
    2. 操作系统要支持  Linux IPMI  
    3. 管理工具 ipmitool  
    
  安装：  
  yum install OpenIPMI ipmitool -y  
  lsmod | grep ipmi  
  启动：  
  systemctl start ipmi  
  
  ipmitool --help  
    
  使用 IPMI 有两种方式：  
    1. 本地调用  
    2. 远程调用 （IP 地址 用户名 密码）  
    
  IPMI 配置网络，有两种方式：  
    1. ipmi over LAN  
    2. 独立  (DELL 服务器前面板配置)  

# Ref
[Intelligent Platform Management Interface - Wiki](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface)  
[IPMI - Wiki](https://zh.wikipedia.org/wiki/IPMI)  
[使用IPMI工具实现对服务器的远程管理](http://servers.pconline.com.cn/evaluating/0808/1385312_all.html)  

