---
layout: post
title: salt命令中的glob参数理解
description: "salt命令中的glob参数理解"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 引言
这几天配置SaltStack WebGUI，遇到了glob这个salt命令默认匹配目标的方式，有些不太理解。  
所以查了下。

# Linux Shell中使用的通配符称为glob

> 
glob听起来不太懂，其实就shell-style，shell里能用的，它也就能用。
在Linux中，glob是用来匹配路径名的通配符。
具体man 7 glob

salt命令中的glob也应该是shell中的glob。

# Ref 
[saltstack（二）target](http://lixcto.blog.51cto.com/4834175/1428659)  
[Shell glob](http://www.cnblogs.com/chaoguo1234/p/5313721.html)  
man 7 glob  

