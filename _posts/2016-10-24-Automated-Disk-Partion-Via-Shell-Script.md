---
layout: post
title: Shell 脚本自动化分区
description: "Shell 脚本自动化分区"
category: Shell
avatarimg:
tags: [Linux, Shell, fdisk]
duoshuo: true
---


# 引言

最近一批业务需要运行在阿里云的云主机上，第三方提供我们服务器，
在准备系统初始化之前，发现服务器第二块数据盘并没有进行格式化分区。  
这个情况在之前腾讯云的服务器上也遇到过。我有些好奇，选配云主机时不能指定数据盘分区？  
于是去选购了，确实不行。那现在就由我们自己来分区吧。这个是基础知识了。很久没接触了，现在回顾下。    
手动分区的过程就不说了，现在是要实现 Shell 脚本自动化分区。

# Shell 脚本自动化分区

本篇很基础，话不多说，直接展示 Shell 脚本吧：  

```bash
#!/bin/bash
echo "n
p
1


w
" | fdisk /dev/vdb && mkfs.ext3 /dev/vdb1
echo "/dev/vdb1 /data ext3 defaults 0 0" >> /etc/fstab
mkdir /data
mount /dev/vdb1 /data
df -h

```

具体磁盘文件可根据具体情况修改或进一步改进脚本。  
上面的分区 Shell 代码可以进一步集成到系统初始化脚本中。

# Ref
[步骤 4：格式化和挂载数据盘](https://help.aliyun.com/document_detail/25426.html?spm=5176.7738005.2.1.ycGocS)  
[fdisk分区硬盘并shell脚本自动化](http://www.cnblogs.com/lienhua34/p/5958559.html)  

