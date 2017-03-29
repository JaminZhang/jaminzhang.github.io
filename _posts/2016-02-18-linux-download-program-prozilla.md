---
layout: post
title: Linux 下的下载加速工具 prozilla
description: "Linux下的下载加速工具 prozilla"
category: Linux
avatarimg:
tags: [Linux, prozilla]
duoshuo: true
---

# 引言

某业务的海外服务器更新包需要从国内下载，通常会碰到下载速度缓慢的情况，如何能加速下载速度呢？  

# 使用 prozilla 代替 wget 下载

Linux 下的默认下载工具是 wget，wget 是一个单线程的下载工具，无法进行多线程下载，所以有时候速度不够快。  
有一些多线程的下载工具，比如 prozilla, Axel, mget 等等，可以对下载进行加速。  

这次我使用了下 prozilla，编译安装后开启了 50 个线程进行下载，相比使用 wget，确实有明显感知的下载加速效果。  

PS:有个小问题，就是 prozilla 是基于 ncurses 的字符界面的，终端窗口一般显示不了 50 个线程下载时程序界面输出。  
如果想避免基于 ncurses 的程序对终端屏幕的占用，可以使用 nohup 将程序放在后台执行。

其他的几个多线程下载工具暂时没测试使用。

# Ref
[prozilla download manager](https://github.com/totosugito/prozilla-2.0.4)  
[Prozilla – Linux Download Accelerator](http://sysadmin.compxtreme.ro/prozilla-linux-download-accelerator/)  
[Linux 多线程下载工具 Axel](https://teddysun.com/377.html)  
[mwget 多线程版本 wget 下载工具](http://www.ttlsa.com/tools/mwget-get-file/)  

