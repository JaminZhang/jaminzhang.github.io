---
layout: post
title: OpenWrt 简介
description: "OpenWrt 简介 "
category: Network
avatarimg:
tags: [Router, Wireless, OpenWrt]
duoshuo: true
---


# 引言
最近在看无线路由器，无线路由器是嵌入式计算设备，它自带的是官方固件，
如果想换成第三方的固件，OpenWrt 就是一个选择（具体是否支持请查看官方硬件支持列表）。  
下面对 OpenWrt 进行一个简单了解。

# OpenWrt 简介

<pre>

OpenWrt is described as a Linux distribution for embedded devices.

Instead of trying to create a single, static firmware, 
OpenWrt provides a fully writable filesystem with package management.
This frees you from the application selection and configuration provided by the vendor
and allows you to customize the device through the use of packages to suit any application.
For developer, 
OpenWrt is the framework to build an application without having to build a complete firmware around it;
for users this means the ability for full customization, to use the device in ways never envisioned.

</pre>


<pre>

OpenWrt 项目始于 2004 年 1 月。
最早的 OpenWrt 版本基于 Linksys 为遵守 GPL 而放出的、为 WRT54G 所编写的代码，以及 uclibc 项目的 buildroot。 

Linksys 放出了 WRT54G 的源代码之后，
开源爱好者便清楚了 Linksys 是如何操作这些硬件的，这样 WRT54G 就从黑盒子变为了白盒子。
OpenWRT 的和 WRT54G 相关的内核驱动的代码都经过了重写，以保证其版权 100% 属于 OpenWRT 的版权所有人。

</pre>

# Ref

[OpenWrt]( https://openwrt.org/)  
[OpenWrt Wikipedia](https://en.wikipedia.org/wiki/OpenWrt)  
[pandorabox、openwrt、ddwrt 是什么关系？](https://www.zhihu.com/question/33277589)　
