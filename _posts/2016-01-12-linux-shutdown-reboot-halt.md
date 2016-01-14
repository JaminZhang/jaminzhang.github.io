---
layout: post
title: Linux下的shutdown/reboot/halt等关机命令
description: "Linux下的shutdown/reboot/halt等关机命令"
category: Linux
avatarimg:
tags: [shutdown, reboot, halt, poweroff]
duoshuo: true
---

# 引言
一个业务压测要进行非正常关机，如何模拟呢？这让我首先重新去深入理解Linux系统中的几个关机命令（shutdown/halt）。

# shutdown
man shutdown:
> 
shutdown  arranges for the system to be brought down in a safe way.  All logged-in users are
notified that the system is going down and, within the last five minutes of TIME, new logins
are prevented.

从上面的说明可以看到，shutdown是一个安全的正常关机的命令。

以下是来自网友详细一点shutdown过程的说明：

<pre>
shutdown -h now will call /etc/rc.d/rc or /etc/init.d/rc. The rc script will call the kill scripts for the new runlevel (0 for -h, 6 for -r), followed by any start scripts.

You'll see S30killprocs or S00killall or something like that depending on your distro. This comes after all the kill scripts have been called to attempt to stop each service gracefully in turn. It will try kill -15 first, followed by kill -9.

Short answer: shutdown -h now or shutdown -r now are graceful. 
</pre>

# reboot/halt/poweroff
我们首先要看下这3个命令所处路径：

<pre>
[root@Aliyun-BJ-01 ~]# ll /sbin/halt /sbin/reboot /sbin/poweroff
lrwxrwxrwx. 1 root root     6 Aug 14  2014 /sbin/halt -> reboot
lrwxrwxrwx. 1 root root     6 Aug 14  2014 /sbin/poweroff -> reboot
-rwxr-xr-x. 1 root root 14832 Mar 12  2014 /sbin/reboot
</pre>

上面是在CentOS系统下，可以看到halt/poweroff命令实际是指向reboot命令的软链接。所以我们man reboot/man halt/man poweroff
会得到相同的结果，

<pre>
       These programs allow a system administrator to reboot, halt or poweroff the system.

       When  called with --force or when in runlevel 0 or 6, this tool invokes the reboot(2) system call itself and directly reboots the system.  Otherwise this simply invokes the shutdown(8) tool with the appropriate arguments.

       -f, --force
              Does not invoke shutdown(8) and instead performs the actual action you would expect from the name.
</pre>

从上面可以看出不带-f选项，则就会调用shutdown命令执行正常重启或关机，如果带-f选项就是强制直接重启或关机，非正常关机应该可以这样模拟。
群里一朋友说了另一个简单的方法：kill -9 1，直接强制杀掉init进程，这个应该也算是非正常关机。


# 总结
模拟非正常关机/重启的方法：
## 1.halt -f / reboot -f
## 2.kill -9 1

# Ref
[Linux Graceful Shutdown](http://serverfault.com/questions/327758/linux-graceful-shutdown)  
[Linux关机/重启命令详解](https://linux.cn/blog-15563-5833.html)  


