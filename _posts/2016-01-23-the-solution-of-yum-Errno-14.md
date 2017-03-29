---
layout: post
title: yum [Errno 14] problem making ssl connection 问题解决
description: "yum [Errno 14] problem making ssl connection 问题解决"
category: Linux
avatarimg:
tags: [Linux, Yum]
duoshuo: true
---

# 引言

通过 SaltStack 官方 yum 源升级安装最新稳定版本的 salt 时，遇到如下 yum 错误：  

```bash
[Errno 14] problem making ssl connection
Trying other mirror.
```    

# 安装 ca-certificates 解决 yum Errno 14 错误提示

查了下，yum 安装 ca-certificates 即可。  
ca-certificates 具体是什么？字面上看是和 CA 认证相关。通过`yum search all ca-certificates`查询如下：

```bash
ca-certificates.noarch : The Mozilla CA root certificate bundle
```    

# Ref  
[yum Errno 14 问题解决](http://www.koalaxiaot.me/2015/01/10/yum-Errno14-fixed.html)  
[[Errno 14] problem making ssl connection 问题解决](http://blog.csdn.net/houdl_love/article/details/44153895)  

