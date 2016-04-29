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



