---
layout: post
title: Bash Shell 中的 PROMPT_COMMAND
description: "Bash Shell 中的 PROMPT_COMMAND"
category: Shell
avatarimg:
tags: [Linux, Shell, Bash]
duoshuo: true
---

今天查看了一个系统初始化的 Shell 脚本，其中有一段命令是配置记录 bash 命令日志的，如下：  

```bash
LOGIN_IP=$(who am i | awk '{print $NF}')  
export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });echo $(date +"%Y-%m-%d %H:%M:%S") [$(whoami)@$SSH_USER$LOGIN_IP `pwd` ]" $msg" >> /var/log/.history; }'
```    

其中的 PROMPT_COMMAND 是 bash 的环境变量，这个变量的中内容是作为一个普通的 bash 命令执行的，而且执行时间是在 bash 显示 prompt 之前。
这个好理解，就是说每执行一个命令前，PROMPT_COMMAND 里面先执行，然后是 prompt。

但里面的 `msg=$(history 1 | { read x y; echo $y; });` 让我迷惑了，现在我来把它拆解，

先来理解 history 1 命令，它的输出总是 $COMMAND_Number history 1， 也就是理解成它的输出总是最后一次执行的命令?  
bash 会最先记录下这个命令：`history 1 | { read x y; echo $y; }`？ 
接着 history 1 加管道处理后就变成它本身，而不带 $COMMAND_Number，于是输出就是命令它本身：`history 1 | { read x y; echo $y; }`？  
于是`msg=$(history 1 | { read x y; echo $y; });`，$msg 变量总是表示当前执行的命令？  

上面是我的理解，结果是明显的，就是 $msg 变量保存的是 bash 最后执行的命令。
但还是觉得讲不明白，history 1 和管道结合还是感觉没太理解。  
如果那个高手看到了，麻烦指点下到底怎么理解它。



# Ref 
[PROMPT_COMMAND](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x264.html)  
[通过syslog远程发送bash 命令日志](http://0cx.cc/tag/bash-history/)  

