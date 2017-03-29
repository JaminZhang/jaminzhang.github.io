---
layout: post
title:  Linux udev 简介
description: "Linux udev 简介"
category: Linux
avatarimg:
tags: [Linux, udev]
duoshuo: true
---


# 引言

上篇文章说到 biosdevname 是一款 udev 帮助程序，那么什么是 udev 呢？  
这个之前没有仔细看过，这里我来重新学习一下。

# Linux udev 简介

## 什么是 udev?

udev 是 Linux 2.6 内核里的一个功能，它替代了原来的 devfs，成为当前 Linux 默认的设备管理工具。  
udev 以守护进程的形式运行，通过侦听内核发出来的 uevent 来管理 /dev 目录下的设备文件。  
不像之前的设备管理工具，udev 在用户空间 (user space) 运行，而不在内核空间 (kernel space) 运行。  

## 使用 udev 的好处

<pre>

我们都知道，所有的设备在 Linux 里都是以设备文件的形式存在。
在早期的 Linux 版本中，/dev 目录包含了所有可能出现的设备的设备文件。
很难想象 Linux 用户如何在这些大量的设备文件中找到匹配条件的设备文件。
现在 udev 只为那些连接到 Linux 操作系统的设备产生设备文件。
并且 udev 能通过定义一个 udev 规则 (rule) 来产生匹配设备属性的设备文件，
这些设备属性可以是内核设备名称、总线路径、厂商名称、型号、序列号或者磁盘大小等等。

动态管理：
当设备添加/删除时，udev 的守护进程侦听来自内核的 uevent，以此添加或者删除 /dev 下的设备文件，
所以 udev 只为已经连接的设备产生设备文件，而不会在 /dev 下产生大量虚无的设备文件。

自定义命名规则：
通过 Linux 默认的规则文件，udev 在 /dev/ 里为所有的设备定义了内核设备名称，
比如 /dev/sda、/dev/hda、/dev/fd 等等。
由于 udev 是在用户空间 (user space) 运行，Linux 用户可以通过自定义的规则文件，灵活地产生标识性强的设备文件名，
比如 /dev/boot_disk、/dev/root_disk、/dev/color_printer 等等。

设定设备的权限和所有者/组：
udev 可以按一定的条件来设置设备文件的权限和设备文件所有者/组。
在不同的 udev 版本中，实现的方法不同。

</pre>

下面的流程图显示 udev 添加/删除设备文件的过程。

![udev Workflow Chart](https://www.ibm.com/developerworks/cn/linux/l-cn-udev/image001.jpg)  


# Ref
[使用 udev 高效、动态地管理 Linux 设备文件](https://www.ibm.com/developerworks/cn/linux/l-cn-udev/)  
