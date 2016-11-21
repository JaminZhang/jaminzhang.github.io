---
layout: post
title: 
description: "CentOS 7 重置 root 密码"
category: Liunx
avatarimg:
tags: [CentOS, Password]
duoshuo: true
---

# 引言
最近 VMware Workstation 下一台 CentOS 7 测试机的 root 密码忘记了，需要重置下，  
很久没有重置过 root 密码了， CentOS 6 和 CentOS 7 重置密码还是有点区别。这里记录下。  

# CentOS 7 重置 root 密码

与之前的 CentOS 5、 CentOS 6 不同的是，当忘记 CentOS 7 root 密码，并采用 GRUB2 为启动器时，将无法通过单用户模式重置 root 密码，下面介绍 CentOS 7 如何重置 root 密码。  

1. 启动系统，并在 GRUB2 启动屏显时，按下 e 键进入编辑模式。
2. 在 `linux16/linux/linuxefi` 所在参数行尾添加以下内容： `init=/bin/sh`  
3. 按 Ctrl + X 启动到 Shell。
4. 挂载文件系统为可写模式：`mount -o remount,rw /`
5. 运行 passwd， 并按提示修改 root 密码。
6. 运行命令 `exec /sbin/init` 来正常启动，或者用命令 `exec /sbin/reboot` 重启

>
遇到的问题，不确认是 VMware Workstation 有 Bug 还是键盘问题，进行密码重置时，  
输入 2 次密码很多次，总是提示密码不匹配，用很简单的密码也提示。  
然后采用直接清空 root 密码的方式（/etc/passwd root 用户密码列 x 删除）先登录系统，然后再修改。


# Ref
[centos7忘记密码 重置root密码](http://www.centoscn.com/CentOS/config/2014/0829/3595.html)  
 	
    
