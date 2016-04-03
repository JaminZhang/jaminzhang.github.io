---
layout: post
title: Linux screen命令使用
description: "Linux screen命令使用"
category: Linux
avatarimg:
tags: [Linux, screen]
duoshuo: true
---

# 引言
IT相关领域的知识学习，如果没有事先系统的学习，就根据具体的事例来学习实践，我自己现在把它称为"learning by case and practise"。
大意就是在工作或学习中遇到一个问题，但是不明白其中的一些概念、原理、用法，于是由此展开进行学习实践。  
这种是以点开始学习的方法。

Linux进程后台运行的方法，之前曾介绍过几种，screen也只稍微提了下，现在遇到一个实际使用screen的场景。于是，从man开始，  
首先了解screen的常用选项意义，扩展到其他的各种用法。

# screen常用选项
以下为一种常见的通过screen使程序后台运行用法的场景：
> 
SCREENRC=/dev/null SYSSCREENRC=/dev/null screen -dmS murder_tracker python murder_tracker.py && sleep 0.2

首先screen被调用时，会执行初始化命令（默认来自于用户家目录下的.screenrc文件和/usr/local/etc/screenrc。 ）这些默认配置可以被重写，对于全局的screenrc文件，查找全局系统环境变量SYSSCREENRC的值。然后查找用户指定的screenrc文件，对应的环境变量是SCREENRC，然后才是$HOME/.screenrc。

-d -m   Start screen in "detached" mode. This creates a new session but doesn't attach to it. This is useful
        for system startup scripts.

-S sessionname
     When creating a new session, this option can be used to specify a meaningful name  for  the  session.
     This  name  identifies  the  session  for  "screen -list" and "screen -r" actions. It substitutes the
     default [tty.host] suffix.


# Ref
[linux 技巧：使用 screen 管理你的远程会话](https://www.ibm.com/developerworks/cn/linux/l-cn-screen/)  
[The .screenrc file](https://www.gnu.org/software/screen/manual/html_node/Startup-Files.html)  
[Linux 命令 screen 用法初探](https://www.hclrc.com/744)  
[使用Screen跑后台命令](http://www.opstool.com/article/304)  


