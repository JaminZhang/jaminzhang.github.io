---
layout: post
title: 更改 Linux 系统语言环境变量
description: "更改 Linux 系统语言环境变量"
category: Linux
avatarimg:
tags: [Linux, LANG, locale]
duoshuo: true
---

# 引言

在腾讯云一台云主机上编写 Python 脚本时发现乱码，猜测便是字符编码的问题。
`echo $LANG`，果然输出 `C`。下面我查找了相关资料深入重新学习了下系统语言环境变量 LANG 及 locale 相关知识。

#  `LC_ALL=C` 含义

`LC_ALL=C` 是为了去除所有本地化的设置，让命令能正确执行。  
C 是系统默认的 locale，"POSIX"是"C"的别名。所以当我们新安装完一个系统时，默认的 locale 就是 C 或 POSIX。

# 更改系统语言环境变量

locale 命令可以查看当前系统语言环境相关的设置。

LANG 变量的值是 `LC_*`的默认值，是最低级别的设置，如果`LC_*` 没有设置，则使用该值。类似于 LC_ALL。
LC_ALL 它是一个宏，如果该值设置了，则该值会覆盖所有`LC_*`的设置值。注意，LANG 的值不受该宏影响。

一般生产环境服务都是使用 `LANG="en_US.utf8"`，那么如何永久修改呢？  
这个配置在 CentOS 6.X 系列操作系统中是在 `/etc/sysconfig/i18n` 配置文件中，我们只要修改这个文件 LANG 变量即可。  
然后我们使用 locale 命令查看是否修改成功。

```bash

[root@VM_15_187_centos ]# locale 
LANG=en_US.utf8
LC_CTYPE="en_US.utf8"
LC_NUMERIC="en_US.utf8"
LC_TIME="en_US.utf8"
LC_COLLATE="en_US.utf8"
LC_MONETARY="en_US.utf8"
LC_MESSAGES="en_US.utf8"
LC_PAPER="en_US.utf8"
LC_NAME="en_US.utf8"
LC_ADDRESS="en_US.utf8"
LC_TELEPHONE="en_US.utf8"
LC_MEASUREMENT="en_US.utf8"
LC_IDENTIFICATION="en_US.utf8"
LC_ALL=

```    


# Ref
[10.2.4 影響顯示結果的語系變數 (locale)](http://linux.vbird.org/linux_basic/0320bash.php#variable_locale)  
[在 Linux 和 UNIX 系统中更改您的语言环境](http://www.ibm.com/support/knowledgecenter/zh/SSMKHH_9.0.0/com.ibm.etools.mft.doc/ae19494_.htm)  
[Linux下 LC_ALL=C 的含义](http://blog.csdn.net/ict2014/article/details/23946471)    
