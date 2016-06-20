---
layout: post
title: CentOS Bash 命令补全增强软件包 bash-completion
description: "CentOS Bash 命令补全增强软件包 bash-completion"
category: Linux
avatarimg: 
tags: [CentOS, Bash]
duoshuo: true
---


# 引言
之前安装的 CentOS 7 是最小化安装，在使用 systemctl 命令进行服务的管理时，经常手动输入相关服务名。  
如果对一个服务名称不熟悉，这样可以迫使我们记住它，但如果对一个服务名已经很熟悉了，再手动输入就比较浪费时间了。  
这时我们可以安装使用 Bash 命令补全增强软件包 bash-completion，这个包支持对 systemctl 命令服务名称的补全。

# bash-completion 简介及安装使用

<pre>
在RHEL7/CentOS7以前的版本中，bash自动补全功能仅限于命令和文件名，然而网络设备往往可以自动补全命令的参数，常常让搞网络出身的工程师唏嘘不已。

在新出的RHEL7/CentOS7中的Bash已经可以自动补全命令参数了，需要注意的是RHEL7/CentOS7的默认安装类型是最小安装，它是没有这个功能的。
要启用这个功能，你需要安装一个bash-completion包，然后退出bash，重新登录即可（未重启bash的情况下继续使用可能出现补全功能异常，出现一堆代码）。

bash-2.05及以后的版本提供了自动补齐的编程接口，通过安装 bash-completion 来使用TAB键自动补齐几乎任何内容，
包括参数、文件、目录甚至包名称等等。在最近的Linux各个发行版中基本都带有bash-completion包。
</pre>

```bash
Summary     : Programmable completion for Bash
URL         : http://bash-completion.alioth.debian.org/
License     : GPLv2+
Description : bash-completion is a collection of shell functions that take advantage
            : of the programmable completion feature of bash.

yum install bash-completion 

# 安装完成后，退出 bash，重新登录即可			
```    

# Ref
[bash-completion 自动补全功能增强](http://foolishfish.blog.51cto.com/3822001/1610101)  
[编写 Bash 补全脚本](http://kodango.com/bash-competion-programming)  
