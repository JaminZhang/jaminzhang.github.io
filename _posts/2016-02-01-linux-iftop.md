---
layout: post
title: Linux iftop 命令
description: "Linux iftop 命令"
category: Linux
avatarimg:
tags: [Linux, iftop]
duoshuo: true
---

# 引言

通常查看 Linux 系统的实时网卡速率及流量，我会使用 iftop 命令。  
但有时会对命令输出底部的数据各代表什么有些模棱两可，今天就确认一下他们的确切含义。  
虽然这些可以通过 man 就可以获得，但好记性不如烂笔头，这里还是记录下。

# TX/RX/cum/peak/rates 参数说明

TX/RX 经常会出现网络流量图表中，那他们具体指什么？

<pre>

TX and RX are abbreviations for Transmit and Receive, respectively.
Note that these metrics are referenced to the server being monitored; 
Transmit FROM this server, and Receive TO this server.

</pre>

“TX”表示发送数据，“RX”表示接收数据，“TOTAL”表示发送和接收全部流量。

<pre> 

"cumm" should be "cum" (short for "cumulative") in the summary of uploaded/downloaded data.

</pre>

“cum”列表示从运行 iftop 到目前的发送、接收的总数据流量。

<pre>

At the bottom of the display, various totals are shown, including peak traffic over the last 40s, 
total traffic transferred (after filtering), and total transfer rates averaged over 2s, 10s and 40s.

</pre>

“peak”列表示发送、接收以及总的流量峰值。

“rates”列表示过去 2s、10s、40s 的平均流量速率。


# Ref
[What do 'TX' and 'RX' refer to in the Network Charts?](https://copperegg.zendesk.com/entries/21750191-What-do-TX-and-RX-refer-to-in-the-Network-Charts-)  
[安全运维之：网络实时流量监测工具 iftop](http://ixdba.blog.51cto.com/2895551/1559362)  
