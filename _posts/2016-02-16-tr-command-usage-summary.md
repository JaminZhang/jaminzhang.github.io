---
layout: post
title: tr 命令用法总结
description: "tr 命令用法总结"
category: Linux
avatarimg:
tags: [Linux, tr]
duoshuo: true
---

## 用例 1： 删除换行符

一个 IP 列表文件如下，实现将空行去掉，并删除逗号后面的换行，变成这样：  
192.168.56.1,192.168.56.2,192.168.56.3,192.168.56.4,192.168.56.5,

```bash

[root@Jamin-SFO1 ~]# cat test.txt
192.168.56.1,

192.168.56.2,

192.168.56.3,

192.168.56.4,

192.168.56.5,
[root@Jamin-SFO1 ~]# tr -s "\r\n" "," < test.txt
192.168.56.1,192.168.56.2,192.168.56.3,192.168.56.4,192.168.56.5,

```

# Ref
[linux tr 命令详解](http://blog.csdn.net/jeffreyst_zb/article/details/8047065)  
[tr 命令](http://man.linuxde.net/tr)  

