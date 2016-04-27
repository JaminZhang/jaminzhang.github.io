---
layout: post
title: 软件版本号分类
description: "软件版本号分类"
category: Programming
avatarimg:
tags: [Software, GNU]
duoshuo: true
---

# 引言
某研发提供的程序版本包，版本号命名比较简单，由此让我想到了开源软件的版本号规则不那么简单，开源软件的看起来更加专业。  
于是查了下资料学习一下各种不同的软件版本号分类方式。

# 软件版本号规则分类
> 
软件版本编号订定是指为软件设置版本号码的方式。通常，版本号码会以数字订定，但亦有不同的方式。

## 1.小数

## 2.日期

## 3.年份

## 4.数学常数

## 5.英文缩写

以上分类对应实例请参考[Wikipedia-软件版本号](https://zh.wikipedia.org/wiki/%E8%BB%9F%E4%BB%B6%E7%89%88%E6%9C%AC%E8%99%9F)  

# GNU软件的版本号命名规则
<pre>
在GNU项目的FTP服务器上 ftp.gnu.org/gnu 可以看到那些软件的版本号命名风格，有3个编号的风格，也有两个编号的版本。其中，GCC和Binutils采用了3个编号的风格。
从其中可以看出，GNU发布的软件版本号命名规则是：主版本号 . 子版本号 . [ . 修正版本号 [ . 编译版本号 ]]。

对于软件开发人员来说，了解软件版本号的命名方式是很有必要的，如今许多开源项目都在学习借鉴GNU项目的软件代码，
如果不知道他们的软件版本号的意义，就可能会引入一些已知的bug到自己的项目上，这当然是一件令人哭笑不得的事情。
引用一次代码却引进了一批bug，这值得很多开发者去警惕之。
</pre>

# Ref
[Wikipedia-软件版本号](https://zh.wikipedia.org/wiki/%E8%BB%9F%E4%BB%B6%E7%89%88%E6%9C%AC%E8%99%9F)   
[关于GNU软件的版本号命名规则](http://www.cnblogs.com/vnix/p/about-version-number.html)  


