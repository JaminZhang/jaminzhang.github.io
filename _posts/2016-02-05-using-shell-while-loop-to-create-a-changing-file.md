---
layout: post
title: 使用Shell中的while loop模拟一个实时变化的日志文件
description: "使用Shell中的while loop模拟一个实时变化的日志文件"
category: Linux
avatarimg:
tags: [Shell]
duoshuo: true
---

# 引言
要模拟一个实时变化的日志文件，就是一直不停地往一个文件中追加记录，我首先想的用Shell脚本中的while loop来做。

# 模拟实时变化的日志文件 
现在使用Shell中的while loop来写个生成实时变化的日志文件的脚本，首先复习下while loop的结构，如下：
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

然后运行2分钟后发现，CPU占用率达到100%，机器hang住了，原因可以看[这里的一个解释](http://www.lfyzjck.com/why-infinite-loop-increase-cpu-use/)。

避免CPU占用率100%可以增加一个usleep (微秒)。

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

