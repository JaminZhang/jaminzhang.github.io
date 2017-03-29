---
layout: post
title: Linux 中查找库文件所属软件包
description: "Linux 中查找库文件所属软件包"
category: Linux
avatarimg:
tags: [Linux, Lib, Yum]
duoshuo: true
---

# 引言

新接一个项目，在系统环境需求方面，程序的运行需要几个库文件，研发直接提供了这几个库文件，让其放置到系统 /lib 目录下。  
但作为一个强迫症，我不放心研发们直接提供的来路不明的库文件，
于是自然地就提出标题中的问题：我想查找一个库文件所属的软件包是哪一个？怎么查询？

# 方法 1：使用 yum provides 命令查找

provides       Find what package provides the given value  

这个命令可以查找在 yum 源中有的大部分常用软件的 lib 库文件。 

# 方法2：编译生成或 rpm 网站上查找

但也有部分库文件所属软件包并没有在常用系统的 yum 源中，
比如`libluajit-5.1.so.2`这个库文件，一般 yum 源没有软件包提供这个库文件，那这种情况怎么获得呢？ 
通过 Google 搜索结果，我们可以知道 libluajit 是 luajit 的库文件，libluajit 可以通过编译 luajit 生成。  
我们还看到另外一种方式，就是在提供 RPM 包网站上可以找到相关的 libluajit RPM 安装包，可以在比较知名的大网站上下载使用。 

# Linux 库文件知识扩展

通过上面实例，我系统了解了下 Linux 库文件的相关知识，库文件实际上就是一段公共代码，可以被多次复用，类似函数吧。  
库文件又分为静态库、动态库。扩展开来，使动态库被系统共享的方法，动态库版本的问题等等，深入下去都有更多内容需要了解（这些我附加到 Ref）。

# Ref
[Linux 库文件编写·入门](http://www.cnblogs.com/lcw/p/3169285.html)  
[Linux 程序编译链接动态库版本的问题](http://littlewhite.us/archives/301)  
[Linux 下动态库及版本号控制](http://blog.csdn.net/alspwx/article/details/36655645)  
[Linux 下如何查看某个文件在哪个软件包中？](http://www.linuxsong.org/2010/09/find-which-rpm/)  
[Yum](https://wiki.centos.org/PackageManagement/Yum)  

