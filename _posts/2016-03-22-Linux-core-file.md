---
layout: post
title: Linux core文件
description: "Linux core文件"
category: Linux
avatarimg:
tags: [core]
duoshuo: true
---

# 引言
某台服务器业务进程挂了，研发反映没看到core生成。  
于是我们来排查下是什么原因造成core文件没生成。 

# 什么是core文件

>
NAME
core - core dump file

> 
The  default  action  of  certain  signals is to cause a process to terminate and produce a core dump file, a disk file containing an image of the process's memory at the time of termination.  This
image can be used in a debugger (e.g., gdb(1)) to inspect the state of the program at the time that it terminated.  A list of the signals which cause a process to dump core can  be  found  in  sig‐
nal(7).

简介：
在一个程序崩溃时，它一般会在指定目录下生成一个core文件。core文件是一个内存映象(同时加上调试信息)，主要是用来调试的。

# 配置系统生成core文件

## 使用ulimit配置生成core文件大小
首先使用ulimit -a确认系统是否生成core文件
看第一行core file size，若为0，说明禁用了core文件生成，若要启用，根据需要配置core文件生成大小。
如不限制core文件大小，如下设置：
>
ulimit -c unlimited

# 系统没生成core的原因
如在ulimit设置了生成core文件，还是没有生成core，可能是什么原因呢？

man core里面说了可能的原因，如下：

```bash
There are various circumstances in which a core dump file is not produced:

*  The process does not have permission to write the core file.  (By default the core file is called core, and is created in the current working directory.  See below for details on naming.)  Writ‐
   ing  the  core  file  will  fail  if the directory in which it is to be created is nonwritable, or if a file with the same name exists and is not writable or is not a regular file (e.g., it is a
   directory or a symbolic link).

*  A (writable, regular) file with the same name as would be used for the core dump already exists, but there is more than one hard link to that file.

*  The file system where the core dump file would be created is full; or has run out of inodes; or is mounted read-only; or the user has reached their quota for the file system.

*  The directory in which the core dump file is to be created does not exist.

*  The RLIMIT_CORE (core file size) or RLIMIT_FSIZE (file size) resource limits for the process are set to zero; see getrlimit(2) and the documentation of  the  shell's  ulimit  command  (limit  in
   csh(1)).

*  The binary being executed by the process does not have read permission enabled.

*  The  process  is executing a set-user-ID (set-group-ID) program that is owned by a user (group) other than the real user (group) ID of the process.  (However, see the description of the prctl(2)
   PR_SET_DUMPABLE operation, and the description of the /proc/sys/fs/suid_dumpable file in proc(5).)

*  (Since Linux 3.7) The kernel was configured without the CONFIG_COREDUMP option.

In addition, a core dump may exclude part of the address space of the process if the madvise(2) MADV_DONTDUMP flag was employed.

```    

可能的情况比较多。

以下引用他人总结的：

> 
　　一、要保证存放Coredump的目录存在且进程对该目录有写权限。存放Coredump的目录即进程的当前目录，一般就是当初发出命令启动该进程时所在的目录。但如果是通过脚本启动，则脚本可能会修改当前目录，这时进程真正的当前目录就会与当初执行脚本所在目录不同。这时可以查看”/proc/<进程pid>/cwd“符号链接的目标来确定进程真正的当前目录地址。通过系统服务启动的进程也可通过这一方法查看。

 
>
　　二、若程序调用了seteuid()/setegid()改变了进程的有效用户或组，则在默认情况下系统不会为这些进程生成Coredump。很多服务程序都会调用seteuid()，如MySQL，不论你用什么用户运行mysqld_safe启动MySQL，mysqld进行的有效用户始终是msyql用户。如果你当初是以用户A运行了某个程序，但在ps里看到的这个程序的用户却是B的话，那么这些进程就是调用了seteuid了。为了能够让这些进程生成core dump，需要将/proc/sys/fs /suid_dumpable文件的内容改为1（一般默认是0）。

 
>
　　三、要设置足够大的Core文件大小限制了。程序崩溃时生成的Core文件大小即为程序运行时占用的内存大小。但程序崩溃时的行为不可按平常时的行为来估计，比如缓冲区溢出等错误可能导致堆栈被破坏，因此经常会出现某个变量的值被修改成乱七八糟的，然后程序用这个大小去申请内存就可能导致程序比平常时多占用很多内存。因此无论程序正常运行时占用的内存多么少，要保证生成Core文件还是将大小限制设为unlimited为好。
    
# 实例分析
```bash

#1、业务进程设置了SUID
[root@xxx_game ~]# ll /home/xxx/global/app/globalserver
-rws--s--x 1 root root 737162 Mar 11 04:07 /home/xxx/global/app/globalserver

#2、普通用户启动了该业务进程
[root@xxx_game ~]# grep su /home/xxx/global/start.sh 
su - xxx -c "cd /home/xxx/global/app;./globalserver -d"

[root@xxx_game ~]# ps aux | grep globalserver | grep -v grep
root     28448  0.2  1.2 270452 208996 ?       Sl   11:16   0:55 ./globalserver -d

#3、suid_dumpable为0，所以suid程序不能生成core
[root@xxx_game ~]# cat /proc/sys/fs/suid_dumpable 
0

```    

以上情况的解决方法是设置/proc/sys/fs/suid_dumpable成1


# Ref
[Linux core 文件介绍](http://www.cnblogs.com/dongzhiquan/archive/2012/01/20/2328355.html)  
[Linux下core文件产生的一些注意问题](http://blog.csdn.net/fengxinze/article/details/6800175)  
[Linux 下如何产生core文件（core dump设置）](http://blog.csdn.net/star_xiong/article/details/43529637)  
[coredump设置方法](http://blog.csdn.net/wj_j2ee/article/details/7161586)  



