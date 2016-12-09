---
layout: post
title: Linux 查看进程相关信息
description: "Linux 查看进程相关信息"
category: Linux
avatarimg:
tags: [Linux, Python]
duoshuo: true
---


Linux 查看进程相关信息

# 引言

研发需要知道某 Python 程序脚本所在目录，这研发，还好他不是后端研发。  
不过当我们使用 ps 或 top 命令查看时，并不能查看到 Python 程序脚本的绝对路径。  
我模糊地记得可以在 /proc/${PID} 下可以查到相关信息，但是很久没用过，忘记了，  
现在我来重新学习记录下。  

# Linux 查看进程的详细信息

Linux 在启动一个进程时，系统会在 /proc 下创建一个以 PID 命名的文件夹，在该文件夹下会有我们的进程的信息，
其中包括一个名为 exe 的文件即记录了绝对路径，通过 ll 或 ls –l 命令即可查看。

* cwd 符号链接的是进程运行目录；
* exe 符号连接就是执行程序的绝对路径；
* cmdline 就是程序运行时输入的命令行命令；
* environ 记录了进程运行时的环境变量；
* fd 目录下是进程打开或使用的文件的符号连接。

如下演示：

```bash
[root@xxxx_log ~]# ps aux | grep log_daemon
root     24664  1.0  0.0 280804 28432 ?        S    Dec08  14:18 python log_daemon.py start
root     32493  0.0  0.0 103256   844 pts/0    S+   17:12   0:00 grep log_daemon
[root@zmsg_log ~]# ll /proc/24664
total 0
dr-xr-xr-x 2 root root 0 Dec  8 22:24 attr
-rw-r--r-- 1 root root 0 Dec  8 22:24 autogroup
-r-------- 1 root root 0 Dec  8 22:24 auxv
-r--r--r-- 1 root root 0 Dec  8 22:24 cgroup
--w------- 1 root root 0 Dec  8 22:24 clear_refs
-r--r--r-- 1 root root 0 Dec  8 18:37 cmdline
-rw-r--r-- 1 root root 0 Dec  8 22:24 comm
-rw-r--r-- 1 root root 0 Dec  8 22:24 coredump_filter
-r--r--r-- 1 root root 0 Dec  8 22:24 cpuset
lrwxrwxrwx 1 root root 0 Dec  8 22:24 cwd -> /home/xxxx/log_to_db		# Python 脚本在此目录下
-r-------- 1 root root 0 Dec  8 22:24 environ
lrwxrwxrwx 1 root root 0 Dec  8 22:24 exe -> /usr/bin/python
dr-x------ 2 root root 0 Dec  8 22:24 fd
dr-x------ 2 root root 0 Dec  8 22:24 fdinfo
-r-------- 1 root root 0 Dec  8 22:24 io
-rw------- 1 root root 0 Dec  8 22:24 limits
-rw-r--r-- 1 root root 0 Dec  8 22:24 loginuid
-r--r--r-- 1 root root 0 Dec  8 22:24 maps
-rw------- 1 root root 0 Dec  8 22:24 mem
-r--r--r-- 1 root root 0 Dec  8 22:24 mountinfo
-r--r--r-- 1 root root 0 Dec  8 22:24 mounts
-r-------- 1 root root 0 Dec  8 22:24 mountstats
dr-xr-xr-x 4 root root 0 Dec  8 22:24 net
dr-x--x--x 2 root root 0 Dec  8 22:24 ns
-r--r--r-- 1 root root 0 Dec  8 22:24 numa_maps
-rw-r--r-- 1 root root 0 Dec  8 22:24 oom_adj
-r--r--r-- 1 root root 0 Dec  8 22:24 oom_score
-rw-r--r-- 1 root root 0 Dec  8 22:24 oom_score_adj
-r--r--r-- 1 root root 0 Dec  8 22:24 pagemap
-r--r--r-- 1 root root 0 Dec  8 22:24 personality
lrwxrwxrwx 1 root root 0 Dec  8 22:24 root -> /
-rw-r--r-- 1 root root 0 Dec  8 22:24 sched
-r--r--r-- 1 root root 0 Dec  8 22:24 schedstat
-r--r--r-- 1 root root 0 Dec  8 22:24 sessionid
-r--r--r-- 1 root root 0 Dec  8 22:24 smaps
-r--r--r-- 1 root root 0 Dec  8 22:24 stack
-r--r--r-- 1 root root 0 Dec  8 18:37 stat
-r--r--r-- 1 root root 0 Dec  8 22:24 statm
-r--r--r-- 1 root root 0 Dec  8 18:37 status
-r--r--r-- 1 root root 0 Dec  8 22:24 syscall
dr-xr-xr-x 3 root root 0 Dec  8 22:24 task
-r--r--r-- 1 root root 0 Dec  8 22:24 wchan

```    

# Ref
[Linux 查看进程运行的完整路径方法](http://lovesoo.org/view-processes-running-linux-full-path-method.html)  
