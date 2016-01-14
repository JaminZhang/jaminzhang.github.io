---
layout: post
title: Linux中的TCP端口
description: "Linux中的TCP端口"
category: Network
avatarimg:
tags: [TCP, Port]
duoshuo: true
---

# 引言
CentOS系统下某个业务进程需要监听843端口，但该业务进程是用普通用户运行。此进程可以运行起来，但是通过netstat命令查看到这个进程并没有在843端口监听。为什么呢？


# TCP端口范围规范

> 
The first 1000 ports are reserved for specific applications, and on Linux can normally own be used by a daemon / application that has super user privileges. These are referred to as well known ports. Some are defined in RFC 1340, and more are defined by IANA.

> 
The latest IANA port assignments can be gotten from
      http://www.iana.org/assignments/port-numbers
The Well Known Ports are those from 0 through 1023.
The Registered Ports are those from 1024 through 49151
The Dynamic and/or Private Ports are those from 49152 through 65535


从上面可以规范可以看出来，在Linux下1024以下的端口只能被超级用户权限的进程使用。即普通用户运行的进程是不能使用这个843这个端口。

那么如何让普通用户使用1024以下的端口？

# 普通用户进程使用1024以下端口的方法
## 1.1 setcap配置
setcap 'cap_net_bind_service=+ep' /path/to/program
这个是配置指定的进程。我没有使用过。

## 1.2 sudo配置
将普通用户添加到sudoers，这个普通用户运行时就具有root权限了。

## 1.3 端口转发
使用iptalbes进行端口转发。

## 1.4 authbind
这个没有见过。

PS:我们的这个业务进程最后直接使用root用户运行。

# Ref
[TCP and UDP port numbers (/etc/services) quick reference](http://www.penguintutor.com/linux/network-services-ports)  
[Linux: allowing an user to listen to a port below 1024](http://unix.stackexchange.com/questions/10735/linux-allowing-an-user-to-listen-to-a-port-below-1024)  
[Is there a way for non-root processes to bind to “privileged” ports (<1024) on Linux?](http://stackoverflow.com/questions/413807/is-there-a-way-for-non-root-processes-to-bind-to-privileged-ports-1024-on-l)  
[Why are ports below 1024 privileged? ](http://stackoverflow.com/questions/10182798/why-are-ports-below-1024-privileged)  
[UNIX网络编程卷1：套接字联网API（第3版）2.9端口号 2.10 TCP端口号与并发服务器]  


