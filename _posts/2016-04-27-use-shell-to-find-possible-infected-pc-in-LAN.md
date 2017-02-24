---
layout: post
title: 使用 Shell 命令找出局域网哪台机器最可能被蠕虫感染
description: "使用 Shell 命令找出局域网哪台机器最可能被蠕虫感染"
category: Shell
avatarimg:
tags: [tcpdump, ARP, Linux]
duoshuo: true
---


# 引言

这几天在看《时间管理：给系统管理员》，里面自动化一章有个使用 Shell 命令找出局域网哪台机器最可能被蠕虫感染的例子。  
我觉得这个例子很不错，综合了 tcpdump/grep/head/awk/sort/uniq 等命令的使用和对 ARP 协议的理解。  

# 使用 Shell 命令找出局域网哪台机器最可能被蠕虫感染

使用的 Shell 命令如下： 

``` bash  
tcpdump -l -n arp | grep "who-has" | head -100 | awk -F"[ ,]+" '{print $7}' | sort  | uniq -c | sort -n
```    


上面的命令及相关选项请 man。  
上面逻辑是：使用 tcpdump 抓 ARP 的协议包，然后使用 grep 过滤出含有"who-has"的行，然后用 awk 提取出发出 ARP 请求的 IP，最后排序，去重汇总，排序。  

作者给出了一个提示：
上面的命令在不太忙碌的网络上执行时需要时间，在有 50 台 PC 的 LAN 上，人不多的时候，差不多要花 1 个小时（这个是没有蠕虫病毒感染 PC 的情况下，
如果有蠕虫病毒感染 PC，可能只要几分钟就收集到 100 个 ARP 封包）。
如果在只有几台机器的 LAN 上，这个命令可能花几天执行完。

# Ref
[《时间管理：给系统管理员》 第十三章 自动化 建立长命令行 P193] (http://item.jd.com/10042434.html)  
[《时间管理：给系统管理员》 豆瓣读书](https://book.douban.com/subject/2253513/)
