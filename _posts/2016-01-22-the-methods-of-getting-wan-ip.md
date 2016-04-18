---
layout: post
title: 获取外网IP方法
description: "获取外网IP方法"
category: Network
avatarimg:
tags: [Netowrk, IP]
duoshuo: true
---

# 引言
最近要在云主机上获取外网IP，因为云主机上只配置了内网IP，我推测是使用了地址转换。

# 使用各大门户网站和专门厂商提供的API接口

## 1、腾讯IP分享计划
http://ip.qq.com/

因为我是在Shell脚本中获取IP，所以使用的以下命令(暂时找不到它的接口URL，只能以这种直接的方式来获取了)：
> 
curl -s  ip.qq.com | grep "ip_contend" | awk -F'"' '{print $16}'

## 2、淘宝IP地址库
http://ip.taobao.com/instructions.php


获取本机IP使用以下命令：
> 
curl -s  http://ip.taobao.com/service/getIpInfo2.php?ip=myip | awk -F"ip" '{print $2}' | awk -F'"' '{print $3}'

## 3、搜狐IP API接口
http://pv.sohu.com/cityjson

## 4、ipip.net
未找到接口URL
http://www.ipip.net/

## 5、ip.cn
未找到接口URL
http://ip.cn/


