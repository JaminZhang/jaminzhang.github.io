---
layout: post
title: Salt 命令中的 glob 参数理解
description: "Salt 命令中的 glob 参数理解"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 引言
这几天配置 SaltStack WebGUI，遇到了 glob 这个 Salt 命令默认匹配目标的方式，有些不太理解。  
所以查了下。

# Linux Shell 中使用的通配符称为 glob

> 
glob 听起来不太懂，其实就 Shell-Style，Shell 里能用的，它也就能用。
在 Linux 中，glob 是用来匹配路径名的通配符。
具体man 7 glob

Salt 命令中的 glob 也应该是 Shell 中的 glob。

# Ref 
[saltstack（二）target](http://lixcto.blog.51cto.com/4834175/1428659)  
[Shell glob](http://www.cnblogs.com/chaoguo1234/p/5313721.html)  
man 7 glob  

