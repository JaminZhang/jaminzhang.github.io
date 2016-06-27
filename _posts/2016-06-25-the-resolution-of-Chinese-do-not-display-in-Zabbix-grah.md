---
layout: post
title: Zabbix 监控图上中文不显示解决方法
description: "Zabbix 监控图上中文不显示解决方法"
category: Monitoring
avatarimg: 
tags: [Zabbix, Fonts]
duoshuo: true
---

# 引言
今天碰到有人说Zabbix 监控图上中文不显示，由于自己一直是使用英文界面，所以并没有碰到这个情况。  
于是我自己切换到中文界面，确实出现了监控图上中文显示不出来的问题。下面给出解决方法。  

# 原因

> 
zabbix使用DejaVuSan.ttf字体，不支持中文，导致中文出现乱码。

# 解决方法
解决方法很简单，可以把我们电脑里面字体文件传到 Zabbix 服务器上并修改相应配置。

## 1 上传中文字体文件到 Zabbix 服务器上
中文字体文件可以使用 Windows 系统字体文件，目录：C:\Windows\Fonts  

## 2 查看 Zabbix 字体配置并修改成中文字体

定位 Zabbxi Web 程序目录下的此配置文件 ：./include/defines.inc.php   

```bash
# 搜索 font 相关参数，如下：
define('ZBX_FONTPATH',                          realpath('fonts')); // where to search for font (GD > 2.0.18)
define('ZBX_GRAPH_FONT_NAME',           'graphfont'); // font file name

# 查看 grahfont 字体文件具体指向
[root@linux-node1 /usr/share/zabbix]# ll /usr/share/zabbix/fonts/
total 0
lrwxrwxrwx 1 root root 33 Jun  1 22:10 graphfont.ttf -> /etc/alternatives/zabbix-web-font

[root@linux-node1 /usr/share/zabbix]# ll /etc/alternatives/zabbix-web-font
lrwxrwxrwx 1 root root 27 Jun 25 13:39 /etc/alternatives/zabbix-web-font -> /usr/share/fonts/dejavu/DejaVuSans.ttf

# 从上面可以看出，是连续 2 个软链接，最终指向 /usr/share/fonts/ 下的一个字体文件。  
# 于是我们的解决方法是上传中文字体文件到 /usr/share/fonts/ 下，  
# 然后重新将 /etc/alternatives/zabbix-web-font 软链接到刚才上传的中文字体文件，如下：  

[root@linux-node1 /usr/share/zabbix]# ll /etc/alternatives/zabbix-web-font
lrwxrwxrwx 1 root root 27 Jun 25 13:39 /etc/alternatives/zabbix-web-font -> /usr/share/fonts/simsun.ttc

```    

# Ref
[zabbix中文乱码解决方法（13）](http://www.ttlsa.com/zabbix/zabbix-chinese-garbled-ttlsa/)  
