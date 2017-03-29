---
layout: post
title: /etc/skel 使用
description: "/etc/skel 使用"
category: Linux
avatarimg:
tags: [Linux, Shell]
duoshuo: true
---

# 引言

前 2 天进行自动化部署时，使用 www 用户，切换到 www 用户后，Shell 终端提示符显示 `-bash-4.2#`  
这是 Linux 基础知识，这是 bash 环境变量丢失的原因，因为当时创建 www 用户并没有创建家目录。  
家目录下的相关配置文件和`/etc/skel`有关，我们重新学习一下。

# /etc/skel 目录作用

`/etc/skel`包含的文件和目录会被自动复制到一个新用户的家目录（当使用 useradd 程序创建用户时）。  
`/etc/skel`允许系统管理员给所有的新用户创建一个默认的家目录，这样所有的新用户都有一样的初始化配置或环境。  

# `-bash-4.2#` 显示不正常的终端提示符处理方法

```bash

# 1. 查看 /etc/skel 相关文件

[root@linux-node1 ~]# ll /etc/skel/ -a
total 24
drwxr-xr-x.  2 root root   59 May 18 22:32 .
drwxr-xr-x. 90 root root 8192 Aug  9 16:12 ..
-rw-r--r--.  1 root root   18 Nov 20  2015 .bash_logout
-rw-r--r--.  1 root root  193 Nov 20  2015 .bash_profile
-rw-r--r--.  1 root root  231 Nov 20  2015 .bashrc

# 2. 拷贝 /etc/skel 下的文件到对应用户家目录
[root@linux-node1 ~]# cp /etc/skel/.bash* /home/www/

# 3. 修改 .bash* 文件的属主和权限 （不修改也能生效）
[root@linux-node1 ~]# chown -R www.www /home/www/{.bash_logout,.bash_profile,.bashrc}
[root@linux-node1 ~]# ll /home/www/{.bash_logout,.bash_profile,.bashrc}
-rw-r--r-- 1 www www  18 Aug 10 16:18 /home/www/.bash_logout
-rw-r--r-- 1 www www 193 Aug 10 16:18 /home/www/.bash_profile
-rw-r--r-- 1 www www 231 Aug 10 16:18 /home/www/.bashrc

# 4. 重新登录就可以恢复正常。 

```   

# Ref
[The /etc/skel Directory](http://www.linfo.org/etc_skel.html)  
[Using /etc/skel](http://www.linuxhowtos.org/Tips%20and%20Tricks/using_skel.htm)  
[Linux 命令终端提示符显示 -bash-4.1# 解决方法](http://blog.csdn.net/zouqingfang/article/details/13768661)  
