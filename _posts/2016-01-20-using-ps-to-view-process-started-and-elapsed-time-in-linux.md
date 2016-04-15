---
layout: post
title: Linux ps命令查看进程启动及运行时间
description: "Linux ps命令查看进程启动及运行时间"
category: Linux
avatarimg:
tags: [Linux, ps]
duoshuo: true
---

# 引言
同事问我怎样看一个进程的启动时间和运行时间，我第一反应当然是说用ps命令啦。  
ps aux 或 ps -ef 不就可以看时间吗？

# ps aux 选项及输出说明
我们来重新复习下ps aux的选项，这是类BSD风格的命令选项，因为不带“-”。  

通过man可以aux选项解释如下：
<pre>
       a      Lift the BSD-style "only yourself" restriction, which is imposed upon the set of all processes when some BSD-style (without "-") options are used or when the ps personality setting is
              BSD-like.  The set of processes selected in this manner is in addition to the set of processes selected by other means.  An alternate description is that this option causes ps to list all
              processes with a terminal (tty), or to list all processes when used together with the x option.
       x      Lift the BSD-style "must have a tty" restriction, which is imposed upon the set of all processes when some BSD-style (without "-") options are used or when the ps personality setting is
              BSD-like.  The set of processes selected in this manner is in addition to the set of processes selected by other means.  An alternate description is that this option causes ps to list all
              processes owned by you (same EUID as ps), or to list all processes when used together with the a option.
       u      Display user-oriented format.
              
</pre>

然后再来看下ps aux的输出结果，其首行如下，说明了输出的各列：
> 
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND

我们可以看到START和TIME列，通过man其说明如下：
<pre>
       bsdstart    START     time the command started.  If the process was started less than 24 hours ago, the output format is " HH:MM", else it is " Mmm:SS" (where Mmm is the three letters of the
                             month).  See also lstart, start, start_time, and stime.
       bsdtime     TIME      accumulated cpu time, user + system.  The display format is usually "MMM:SS", but can be shifted to the right if the process used more than 999 minutes of cpu time.
</pre>

START是命令启动的时间，如果在24小时之内启动的，则输出格式为"HH:MM"（小时：分钟），否则就是" Mmm:SS"（月份英语单词前3个字母：一月的第几号？[SS这里面怎么理解？为什么有冒号呢？输出并没冒号]）
可以知道，这里并不能直接看出24小时之前启动的命令的精确启动时间。

TIME是累积的CPU时间（user+system），显示格式通常是"MMM:SS"。（分钟：秒）
可以看出，这里并不是指从命令启动开始到现在所花的时间。


# ps -ef 选项及输出说明
带一个“-”为UNIX风格的命令选项。
<pre>
       -e     Select all processes.  Identical to -A.
       -f     Do full-format listing. This option can be combined with many other UNIX-style options to add additional columns.  It also causes the command arguments to be printed.  When used with -L, the
              NLWP (number of threads) and LWP (thread ID) columns will be added.  See the c option, the format keyword args, and the format keyword comm.
       -o format
              User-defined format.  format is a single argument in the form of a blank-separated or comma-separated list, which offers a way to specify individual output columns.  The recognized keywords
              are described in the STANDARD FORMAT SPECIFIERS section below.  Headers may be renamed (ps -o pid,ruser=RealUser -o comm=Command) as desired.  If all column headers are empty (ps -o pid= -o
              comm=) then the header line will not be output.  Column width will increase as needed for wide headers; this may be used to widen up columns such as WCHAN (ps -o pid,wchan=WIDE-WCHAN-COLUMN
              -o comm).  Explicit width control (ps opid,wchan:42,cmd) is offered too.  The behavior of ps -o pid=X,comm=Y varies with personality; output may be one column named "X,comm=Y" or two columns
              named "X" and "Y".  Use multiple -o options when in doubt.  Use the PS_FORMAT environment variable to specify a default as desired; DefSysV and DefBSD are macros that may be used to choose
              the default UNIX or BSD columns.              
</pre>

然后再来看下ps -ef的输出结果，其首行如下，说明了输出的各列：
> 
UID        PID  PPID  C STIME TTY          TIME CMD

我们可以看到STIME和TIME列，通过man其说明如下(我这台服务器上ps版本为procps-ng version 3.3.9，man中找不到STIME的解释，通过观察输出，我们可以推断这个STIME其实和前面START是一样的，指的是命令启动的时间，[这里](http://www.linfo.org/ps.html)有这个说明。）：

TIME列也和前面说的TIME列一样指的命令使用的累积CPU时间。

# 使用ps命令查看进程启动的精确时间和启动后所流逝的时间
回到引言中的问题，同事实际要问的是一个进程启动的精确时间和进程启动后所流逝的时间。  
其实这2个时间也是可以通过ps命令输出的。
标识符如下：
<pre>
       lstart      STARTED   time the command started.  See also bsdstart, start, start_time, and stime.
       etime       ELAPSED   elapsed time since the process was started, in the form [[DD-]hh:]mm:ss.
</pre>

例子：
查看nginx进程启动的精确时间和启动后所流逝的时间：
<pre>
[root@iZ25p102vo3Z ~]# ps -eo pid,lstart,etime,cmd | grep nginx
16968 Fri Mar  4 16:04:27 2016 41-21:14:04 nginx: master process /usr/sbin/nginx
17826 Fri Mar  4 22:53:51 2016 41-14:24:40 nginx: worker process
18312 Fri Apr 15 13:18:31 2016       00:00 grep --color=auto nginx
</pre>


# Ref
man ps  
[The ps Command](http://www.linfo.org/ps.html)
