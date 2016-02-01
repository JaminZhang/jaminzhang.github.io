---
layout: post
title: Linux iftop命令
description: "Linux iftop命令"
category: Linux
avatarimg:
tags: [iftop]
duoshuo: true
---

# 引言
通常查看Linux系统的限时网卡速率及流量，我会使用iftop命令。  
但有时会对命令输出底部的数据各代表什么有些模棱两可，今天就确认一下他们的确切含义。  
虽然这些可以通过man就可以获得，但好记性不如烂笔头，这里还是记录下。。。  

# TX/RX/cum/peak/rates参数说明

TX/RX经常会出现网络流量图表中，那他们具体指什么？
> 
TX and RX are abbreviations for Transmit and Receive, respectively.
Note that these metrics are referenced to the server being monitored; Transmit FROM this server, and Receive TO this server.

“TX”表示发送数据，“RX”表示接收数据，“TOTAL”表示发送和接收全部流量。

> 
"cumm" should be "cum" (short for "cumulative") in the summary of uploaded/downloaded data.

“cum”列表示从运行iftop到目前的发送、接收和总数据流量。

> 
At  the  bottom  of  the display, various totals are shown, including peak traffic over the last 40s, total traffic transferred (after
filtering), and total transfer rates averaged over 2s, 10s and 40s.

“peak”列表示发送、接收以及总的流量峰值。

“rates”列表示过去2s、10s、40s的平均流量值。


# Ref
[What do 'TX' and 'RX' refer to in the Network Charts?](https://copperegg.zendesk.com/entries/21750191-What-do-TX-and-RX-refer-to-in-the-Network-Charts-)  
[安全运维之：网络实时流量监测工具iftop](http://ixdba.blog.51cto.com/2895551/1559362)  
