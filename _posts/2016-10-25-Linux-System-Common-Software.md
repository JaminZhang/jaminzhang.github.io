---
layout: post
title: Linux 系统常用软件
description: "Linux 系统常用软件"
category: Linux
avatarimg:
tags: [Linux, sysstat]
duoshuo: true
---

# 引言

通常我们最小化安装 Linux 系统时，有许多常用软件工具没有默认安装，这里需要我们安装，
这步我们通常放在系统初始化脚本中。  
下面我重新记录下我在生产和学习中所遇到要使用的常用软件（会不定期更新）。

#  Linux 系统常用软件

**sysstat**  

<pre>

Summary     : The sar and iostat system monitoring commands
Description : This package provides the sar and iostat commands for Linux. Sar and
            : iostat enable system monitoring of disk, network, and other IO
            : activity.

[root@VM_15_187_centos ~]# rpm -ql sysstat | grep bin
/usr/bin/cifsiostat
/usr/bin/iostat
/usr/bin/mpstat
/usr/bin/pidstat
/usr/bin/sadf
/usr/bin/sar
			
</pre>
