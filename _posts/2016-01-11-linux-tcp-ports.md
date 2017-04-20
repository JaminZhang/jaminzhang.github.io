---
layout: post
title: Linux 中的 TCP 端口
description: "Linux 中的 TCP 端口"
category: Network
avatarimg:
tags: [Linux, TCP, Port]
duoshuo: true
---

# 引言

CentOS 系统下某个业务进程需要监听 843 端口，但该业务进程是用普通用户运行。  
此进程可以运行起来，但是通过 netstat 命令查看到这个进程并没有在 843 端口监听。为什么呢？


# TCP 端口范围规范

<pre>

The first 1000 ports are reserved for specific applications, 
and on Linux can normally own be used by a daemon / application that has super user privileges. 
These are referred to as well known ports. Some are defined in RFC 1340, and more are defined by IANA.
 
The latest IANA port assignments can be gotten from
      http://www.iana.org/assignments/port-numbers
The Well Known Ports are those from 0 through 1023.
The Registered Ports are those from 1024 through 49151
The Dynamic and/or Private Ports are those from 49152 through 65535

</pre>

从上面可以规范可以看出来，在 Linux 下 1024 以下的端口只能被超级用户权限的进程使用。  
即普通用户运行的进程是不能使用这个 843 这个端口。

那么如何让普通用户使用 1024 以下的端口？

# 普通用户进程使用 1024 以下端口的方法

## 1.1 setcap 配置

`setcap 'cap_net_bind_service=+ep' /path/to/program`
这个是配置指定的进程。我还没有使用过。

## 1.2 sudo 配置

将普通用户添加到 sudoers，这个普通用户运行时就具有 root 权限了。

## 1.3 端口转发

使用 iptalbes 进行端口转发。

## 1.4 authbind

这个没有使用过。

PS: 我们的这个业务进程最后直接使用 root 用户运行。

# Ref
[TCP and UDP port numbers (/etc/services) quick reference](http://www.penguintutor.com/linux/network-services-ports)  
[Linux: allowing an user to listen to a port below 1024](http://unix.stackexchange.com/questions/10735/linux-allowing-an-user-to-listen-to-a-port-below-1024)  
[Is there a way for non-root processes to bind to “privileged” ports (<1024) on Linux?](http://stackoverflow.com/questions/413807/is-there-a-way-for-non-root-processes-to-bind-to-privileged-ports-1024-on-l)  
[Why are ports below 1024 privileged? ](http://stackoverflow.com/questions/10182798/why-are-ports-below-1024-privileged)  
[UNIX 网络编程卷 1：套接字联网 API（第 3 版）2.9 端口号 2.10 TCP 端口号与并发服务器]  


