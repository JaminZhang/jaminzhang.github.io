---
layout: post
title: 了解NTP DDOS攻击原理
description: "了解NTP DDOS攻击原理"
category: Security
avatarimg:
tags: [Network, UDP, NTP, DDOS]
duoshuo: true
---

# 引言
某业务的一台服务器遭受攻击，机房反馈是受到了UDP流量DDOS攻击。  
那么什么是UDP流量DDOS攻击呢？有必要了解一下。  

# NTP流量DDOS攻击原理

> 
无论是基于 DNS 还是基于 NTP，其最终都是基于 UDP 协议的。在 UDP 协议中正常情况下客户端发送请求包到服务端，服务端返回响应包到客户端，  
但是 UDP 协议是面向无连接的，所以客户端发送请求包的源 IP 很容易进行伪造，当把源 IP 修改为受害者的 IP，  
最终服务端返回的响应包就会返回到受害者的 IP。这就形成了一次反射攻击。  

> 
放大攻击呢就是一次小的请求包最终会收到一个或者多个多于请求包许多倍的响应包，这样就达到了四两拨千斤的效果。

>
那我们接着来看什么是 NTP 的反射和放大攻击，NTP 包含一个 monlist 功能，也被成为 MON_GETLIST，主要用于监控 NTP 服务器，  
NTP 服务器响应 monlist 后就会返回与 NTP 服务器进行过时间同步的最后 600 个客户端的 IP，响应包按照每 6 个 IP 进行分割，  最多有 100 个响应包。


各具体的说明参考以下文章：  
[浅谈基于 NTP 的反射和放大攻击](http://drops.wooyun.org/papers/926)  
[NTP反射型DDos攻击FAQ/补遗](http://drops.wooyun.org/papers/955)  


# 防御方法
## 1、NTP服务器端加固服务
1.1 NTP 服务器升级到 4.2.7p26或更高版本  
1.2 关闭现在 NTP 服务的 monlist 功能，在ntp.conf配置文件中增加`disable monitor`选项  

## 2、防御 NTP 反射和放大攻击
2.1 由于这种攻击的特征比较明显，所以可以通过网络层或者借助运营商实施 ACL 来防御  
2.2 使用防 DDoS 设备进行清洗

一般受攻击后，使用第二类解决方法。  
我们这边让机房在网络层禁用了受攻击的服务器的UDP数据包。  

# Ref
[浅谈基于 NTP 的反射和放大攻击](http://drops.wooyun.org/papers/926)  
[NTP反射型DDos攻击FAQ/补遗](http://drops.wooyun.org/papers/955)  
[udp flood 攻击防御总结](http://helonghua.com/2015/06/23/udp-flood/)  

