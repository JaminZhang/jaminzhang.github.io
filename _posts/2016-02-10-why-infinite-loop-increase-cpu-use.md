---
layout: post
title: 为什么一个无限循环会使 CPU 占用达到 100%
description: "为什么一个无限循环会使 CPU 占用达到 100%"
category: OS
avatarimg:
tags: [OS, CPU]
duoshuo: true
---

# 引言 

之前用 while 写了一个无限循环的脚本会不停占用 CPU，直到 100%，当时提到了原因与解释。  
这里重新复习理解下。

# 分析与解释

> 
一个空的死循环不会做任何事情，但是会不断向 CPU 申请时间片，直到把每一片时间都占用完。
这样 CPU 就没有空余的时间片来做其他有用的事情了。

<pre>

The CPU cannot do anything else while it's executing that loop (which never ends).
Even if you're using a pre-emptive multi-tasking system (so that infinite loop will only clog forever its own process or thread), 
the loop will "eat" its time slice each time the OS's pre-emptive scheduler hands it the CPU for the next slice -- doing nothing, 
but eating up one slice's worth of CPU time each and every time, 
so that much CPU is lost to all other threads which could otherwise be doing useful work.

</pre>

# Ref
[为什么一个空的死循环会让 CPU 占用达到 100%](http://www.lfyzjck.com/why-infinite-loop-increase-cpu-use/)  
[why does an infinite loop of the unintended kind increase the CPU use?](http://stackoverflow.com/questions/2846165/why-does-an-infinite-loop-of-the-unintended-kind-increase-the-cpu-use)  
