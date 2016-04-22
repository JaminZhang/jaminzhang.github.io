---
layout: post
title: yum [Errno 14] problem making ssl connection 问题解决
description: "yum [Errno 14] problem making ssl connection 问题解决"
category: Linux
avatarimg:
tags: [yum]
duoshuo: true
---

# 引言
通过SaltStack官方yum源升级安装最新稳定版本的salt时，遇到如下yum错误：  
> 
[Errno 14] problem making ssl connection
Trying other mirror.

# 安装ca-certificates解决yum Errno 14错误提示
查了下，yum安装ca-certificates即可。  
ca-certificates具体是什么？字面上看是和CA认证相关。
通过yum search all ca-certificates查询如下：
> 
ca-certificates.noarch : The Mozilla CA root certificate bundle

# Ref  
[yum Errno 14 问题解决](http://www.koalaxiaot.me/2015/01/10/yum-Errno14-fixed.html)  
[[Errno 14] problem making ssl connection问题解决](http://blog.csdn.net/houdl_love/article/details/44153895)  




