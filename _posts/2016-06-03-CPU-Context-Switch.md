---
layout: post
title: CPU 上下文切换
description: "CPU 上下文切换"
category: Hardware
avatarimg:
tags: [Hardware, CPU, Context Switch]
duoshuo: true
---

# 引言
我们在进行系统监控时，首先就是监控 CPU，所以我们就必须理解 CPU 的工作原理和相关概念。  
现在我重新学习下 CPU 的上下文切换这个概念。

# CPU 的上下文切换

> 
A context switch (also sometimes referred to as a process switch or a task switch) is the switching of the CPU (central processing unit) 
from one process or thread to another.  

> 
在进程执行时，运行进程的信息存储在处理器的寄存器和cache中。上下文切换只发生在内核态。  
处理器的3种状态：  
内核态：运行于Process Context，内核代表进程运行于内核空间  
内核态：运行于Interrupt Context，内核代表硬件运行于内核空间  
用户态：运行于用户空间  

![CPU Context Switch](http://yangxikun.github.io/assets/img/201504200103.png)


> 
进程切换也叫上下文切换，contextswitch假如当前进程a的从cpu上被拿走，切换成进程B,那么A的进程描述符要被挂起，意味着它的栈指针、其他寄存器、指令计数器等等在cpu内部维持的信息，
要保存到进程描述符中，这个过程叫保存现场【Suspend】。而进程描述符是由内核维持的。所以这些信息都保存在内核中。描述符文件大小都是固定的。
把B进程的栈指针、其他寄存器、指令计数器等信息以及跟当前进程本身运行所独有的数据从内核读取出而且都必须要装载到cpu里面，
总之B进程调进来的过程叫做恢复现场【Resume】。进程间切换由内核来完成。所以整个过程就是不断的从用户空间转换到内核空间，在转换到用户空间等等所以cpu时间是由用户时间和内核时间共同组成。

# Ref
[Context switch - Wiki](https://en.wikipedia.org/wiki/Context_switch)  
[Context Switch Definition](http://www.linfo.org/context_switch.html)  
[理解Linux操作系统——Process和Memory](http://yangxikun.github.io/linux%E6%80%A7%E8%83%BD%E5%88%86%E6%9E%90/2015/04/20/linux-understanding.html)  
