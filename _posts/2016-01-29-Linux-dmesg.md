---
layout: post
title: Linux dmesg
description: "Linux dmesg"
category: Linux
avatarimg:
tags: [Linux, dmesg]
duoshuo: true
---

# 引言

一直用 dmesg，但在服务器上查看时，时间戳不易读。  
所以查下用什么方法让其变成 human readable.

# dmesg 简介

<pre>

dmesg - print or control the kernel ring buffer
dmesg is used to examine or control the kernel ring buffer.

The default action is to read all messages from kernel ring buffer.

</pre>

终端输入 dmesg，可以看到每行最开始显示的是一个中括号，里面的数字为 timestamp，时间戳，
该时间指示的系统从开机到现在的运行时间，单位为秒。

# dmesg 时间戳转换

## 1.dmesg -T 参数

<pre>

-T, --ctime
       Print human readable timestamps.  The timestamp could be inaccurate!
       The time source used for the logs is not updated after system SUSPEND/RESUME.

</pre>

这个参数在较老版本的 util-linux 中并没有，还要注意这个时间可能不准确。

## 2. 使用命令或其他工具转换

使用 bash 命令转换：

``` bash
date -d "1970-01-01 UTC `echo "$(date +%s)-$(cat /proc/uptime|cut -f 1 -d' ')+[dmesg显示的时间]"|bc ` seconds"
```    
    
当然还有其他工具，比如这个上 Python 写的[pydmesg](https://gist.github.com/saghul/542780)  

## 3. 配置 rsyslog,将 kernel 日志输出到文件

修改`/etc/[r]syslog.conf`，添加如下配置：

<pre>

kern.*                                                  /var/log/kern.log

</pre>

后续可以在`/var/log/kern.log`中查看 kernel 日志信息。

# Ref
[Linux dmesg 输出没有时间列](http://blog.chinaunix.net/uid-29054214-id-5114125.html)  
[Linux 时间戳转换/dmesg 时间转换](http://blog.csdn.net/buptapple/article/details/8568938) 
[关于 dmesg 的 timestamp](http://blog.tankywoo.com/2015/02/03/about-timestamp-in-dmesg.html)  
[Linux 系统中‘dmesg’命令处理故障和收集系统信息的 7 种用法](https://linux.cn/article-3587-1.html)  
[dmesg 以 human readable 的方式显示时间](http://jaseywang.me/2012/07/27/dmesg-%E4%BB%A5-human-readable-%E7%9A%84%E6%96%B9%E5%BC%8F%E6%98%BE%E7%A4%BA%E6%97%B6%E9%97%B4/)  
[CentOS 上配置 rsyslog 客户端用以远程记录日志](https://linux.cn/article-4835-1.html)  
