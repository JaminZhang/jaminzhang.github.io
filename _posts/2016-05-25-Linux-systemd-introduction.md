---
layout: post
title: Linux systemd介绍
description: "Linux systemd介绍"
category: Linux
avatarimg:
tags: [Linux, systemd]
duoshuo: true
---

#  引言
最近才开始接触CentOS 7系统（生产环境基本都是CentOS 6），里面的服务管理用的是全新的systemd，替代了以前的SysV init。  
感觉需要很多新东西要学习掌握。

# 什么是systemd

>  
systemd is a suite of basic building blocks for a Linux system.   
It provides a system and service manager that runs as PID 1 and starts the rest of the system. 
systemd provides aggressive parallelization capabilities, uses socket and D-Bus activation for starting services, 
offers on-demand starting of daemons, keeps track of processes using Linux control groups, 
supports snapshotting and restoring of the system state, maintains mount and automount points and implements an elaborate 
transactional dependency-based service control logic. systemd supports SysV and LSB init scripts and works as a replacement for sysvinit.
Other parts include a logging daemon, utilities to control basic system configuration like the hostname, date, locale, maintain 
a list of logged-in users and running containers and virtual machines, system accounts, runtime directories and settings, 
and daemons to manage simple network configuration, network time synchronization, log forwarding, and name resolution.

中文介绍：
> 
systemd是Linux下的一种init软件，由Lennart Poettering带头开发，并在LGPL 2.1及其后续版本许可证下开源发布。其开发目标是提供更优秀的框架以表示系统服务间的依赖关系，并依此实现系统初始化时服务的并行启动，同时达到降低Shell的系统开销的效果，最终代替现在常用的System V与BSD风格init程序。
与多数发行版使用的System V风格init相比，systemd采用了以下新技术：
采用Socket激活式与总线激活式服务，以提高相互依赖的各服务的并行运行性能；
用cgroups代替PID来追踪进程，以此即使是两次fork之后生成的守护进程也不会脱离systemd的控制。
从设计构思上说，由于systemd使用了cgroup与fanotify等组件以实现其特性，所以只适用于Linux。

> 
SystemD被设计用来改进SysVinit的缺点，与Ubuntu的upstart形成技术竞争。SystemD的很多概念来源于苹果的launchd。
目标是尽可能启动更少进程；尽可能将更多进程并行启动（这是性能优于SysVinit的理念基础）。SystemD尽可能减少对Shell脚本的依赖。
传统SysVinit使用inittab来决定运行哪些Shell脚本，大量使用Shell脚本被认为是效率低下无法并行的原因。
SystemD使用了Linux专属技术，不再顾及POSIX兼容，只要能满足社会变革的需要，突破一些可能过时的技术约束，这也是当今创信理念的需要
，相信市场会给出评判。


# 为什么会使用systemd
上面的对systemd的说明中其实已经提到了。
时过境迁，传统的SysVinit已经不能满足现代服务器的需求了。

> 
Well, to be overly simplistic, it was time. Now that our servers have graduated into the modern age where they are asked to 
do everything including make us dinner (well, maybe not that far yet), there were a whole lot of things that the older ‘init’ based 
systems (to be complete, the ‘init’ systems are technically grouped into the ‘sysvinit’ category to mark their compatibility with 
Unix System V from quite some time ago) are not very good at or require a lot of extra hacking around.

# Ref
[systemd Wikipedia](https://en.wikipedia.org/wiki/Systemd)  
[CentOS 7: Take the Plunge into SystemD](https://linuxacademy.com/blog/linux/centos-7-take-the-plunge-into-systemd/)  
[systemd System and Service Manager](https://www.freedesktop.org/wiki/Software/systemd/)  
[CHAPTER 8. MANAGING SERVICES WITH SYSTEMD](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/chap-Managing_Services_with_systemd.html)  
[Systemd 入门教程：命令篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)  
[systemd详解](http://www.huzs.net/?p=2180)  
[RHEL/CentOS 7.x的几点新改变](http://www.ha97.com/5657.html)  
