---
layout: post
title: 使用 Shell 中的 while loop 模拟一个实时变化的日志文件
description: "使用 Shell 中的 while loop 模拟一个实时变化的日志文件"
category: Shell
avatarimg:
tags: [Shell, CPU, Loop]
duoshuo: true
---

# 引言
要模拟一个实时变化的日志文件，就是一直不停地往一个文件中追加记录，我首先想的用 Shell 脚本中的 while loop 来做。

# 模拟实时变化的日志文件 

现在使用 Shell 中的 while loop 来写个生成实时变化的日志文件的脚本，首先复习下 while loop 的结构，如下：

<pre>

while [ condition ]
do 
 command(s)... 
done

</pre>

测试脚本如下：  

<pre>

while true
do
	date >> /tmp/test.log
done

</pre>

然后运行 2 分钟后发现，CPU 占用率达到 100%，机器 hang 住了，原因可以看[这里的一个解释](http://www.lfyzjck.com/why-infinite-loop-increase-cpu-use/)。

避免 CPU 占用率 100% 可以增加一个 usleep (微秒)。

测试脚本如下：  

<pre>

while true
do
	date >> /tmp/test.log
	usleep 1000
done

</pre>

# Ref
[为什么一个空的死循环会让CPU占用达到100%](http://www.lfyzjck.com/why-infinite-loop-increase-cpu-use/)  
[cpu使用率跟什么因素有关](http://bbs.csdn.net/topics/390212551)  
[Loops](http://www.tldp.org/LDP/abs/html/loops1.html)  

