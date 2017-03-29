---
layout: post
title: CentOS 下 netstat 命令显示不完整程序名的原因
description: "CentOS 下 netstat 命令显示不完整程序名的原因"
category: Linux
avatarimg:
tags: [Linux, CentOS, netstat]
duoshuo: true
---

# 引言

使用`netstat -lntp`查看业务进程，发现显示程序名称显示不完整。
如下：

<pre>

tcp        0      0 0.0.0.0:20811               0.0.0.0:*                   LISTEN      15459/./gate_s9990  
tcp        0      0 0.0.0.0:843                 0.0.0.0:*                   LISTEN      15431/./flash_s9990 
tcp        0      0 0.0.0.0:20812               0.0.0.0:*                   LISTEN      15481/./gate_s9990  
tcp        0      0 127.0.0.1:20821             0.0.0.0:*                   LISTEN      15438/./game_s9990  
tcp        0      0 127.0.0.1:20822             0.0.0.0:*                   LISTEN      15442/./game_s9990  
tcp        0      0 127.0.0.1:20823             0.0.0.0:*                   LISTEN      15446/./game_s9990  
tcp        0      0 127.0.0.1:20824             0.0.0.0:*                   LISTEN      15450/./game_s9990  
tcp        0      0 10.2.80.224:20832           0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 10.2.80.224:20833           0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20801             0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 0.0.0.0:20802               0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20803             0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20804             0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20805             0.0.0.0:*                   LISTEN      15434/./center_s999 

</pre>

上面可以看到 center_s999 应该是 center_s9990，但没显示出来，于是我就想为什么不能显示出来？  
观察了几个实例，推断 PID/Porgram Name 宽度限制在 19 位。  
于是我想 netstat 没有选项控制显示完整 Program Name 吗？ 通过`man netstat`并没有发现有相关选项。

# netstat --wide 选项

继续搜索，发现 netstat 的新版本有 --wide 选项，有人说了如下内容（--wide 选项解释起来不太正确）：

<pre>

netstat as shipped with modern OSes (including Ubuntu) has a -W (--wide) switch 
that disables column width restrictions. 
This is definitely present since net-tools 1.60-23, documented in netstat(8), 
and listed in Changelog as an addition to 1.60-22.

</pre>

在 CentOS 7 下新版本 netstat 的 --wide 选项并不是像上面说的取消宽度限制。  

通过`man netstat`，-W 选项功能如下：

<pre>

   --wide , -W
       Do not truncate IP addresses by using output as wide as needed. This is
       optional for now to not break existing scripts.

</pre>

我在 CentOS 7 上使用新版本的 netstat 验证了下，结果如下：

<pre>

[root@centos-512mb-sgp1-01 ~]# netstat -lntp -W
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      695/sshd            
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      915/master          
tcp        0      0 0.0.0.0:19999           0.0.0.0:*               LISTEN      1974/very-loooooooo 
tcp6       0      0 :::22                   :::*                    LISTEN      695/sshd            
tcp6       0      0 ::1:25                  :::*                    LISTEN      915/master          
tcp6       0      0 :::19999                :::*                    LISTEN      1974/very-loooooooo 

</pre>

上面“1974/very-loooooooo”是一个测试监听进程，可以看到，使用了 -W 选项，Program name 还是显示不全的，而且 PID/Program name 长度是 19 位。

# 总结

netstat 输出的 Program name 在遇到较长进程程序名时，会截取，PID/Program name 长度是19位。  
不知道这算不算一个 bug?

# Ref
[Netstat output line width limit](http://unix.stackexchange.com/questions/212096/netstat-output-line-width-limit)  
[Wiki-netstat](https://en.wikipedia.org/wiki/Netstat)  
[ecki/net-tools](https://github.com/ecki/net-tools)  
[PID/program output wrong](http://sourceforge.net/p/net-tools/bugs/10/)  
