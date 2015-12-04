---
layout: post
title: 字符编码(ASCII/Unicode/UTF-8)学习笔记
description: "字符编码(ASCII/Unicode/UTF-8)学习笔记"
category: Computer
avatarimg:
tags: [Character Set, Encodings, ASCII, Unicode, UTF-8]
duoshuo: true
---
一直对字符编码的理解模棱两可，这两天对字符编码有疑问，于是决定找资料好好学习下。  
查找到阮一峰的一篇笔记[字符编码笔记：ASCII，Unicode和UTF-8](http://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)，  
看完了，觉得这是我见过的写得最好的对字符编码的简单介绍。  
看完一遍，有豁然开朗的感觉，值得反复阅读。现在才看到这篇07年的文章，实在是晚了点。。。  
文中的扩展阅读部分也需花时间好好看下。  

小插曲：根据文中实例进行16进制查看几个不同编码的文件时，我直接在Linux上使用od -x命令查看的，字符排列顺序和文中讲解的相反，当时还怀疑是不是文章讲解错了，然后查到了原来是od -x选项导致的，汗。。。  
-x = -t x2 输出单元为双字节（注意：每单元内排列顺序从左到右为 [高字节｜低字节]）  
应该使用od -t x1 这样每单元为单字节，排列顺序才和文章符合。 

# References:
[字符编码笔记：ASCII，Unicode和UTF-8](http://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)  
[Linux 16进制查看命令、工具](http://blog.csdn.net/chenglian_999/article/details/4672177)  
