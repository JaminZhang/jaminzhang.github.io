---
layout: post
title: 无线路由器配置优化
description: "无线路由器配置优化"
category: Network
avatarimg:
tags: [Network, WiFi, Wireless, WLAN]
duoshuo: true
---

# 引言
这几天搬了新住处，无线网络是个大问题，开始并没有太在意，因为之前并没有遇到这种情况。
问题现象就是：每天晚上08:00-12:00，无线网络质量非常差，ping网关IP丢包率和延迟很高，而12:00过后和早上就很正常。

# 问题原因
通过上面的现象，我们应该可以分析出无线网络的问题，在晚高峰时段无线网络质量差，而闲时网络就正常。  
为什么呢？首先我们下载一款无线网络扫描软件，扫描周围的无线网络情况。  
我在自己的笔记本运行WiFi扫描软件后，发现我这周围竟然有几十个无线网络！！！之前住处从没有这么复杂拥挤的无线网络环境。  
这就是原因了。


# 解决方法
无线网络太多，而且路由器默认的自动信道选择功能并不智能，我们就要根据无线网络扫描软件扫描出来的各个无线信道的占用的情况，  
手动选择使用较少的无线信道。  

我手动在路由器设置中选择了一个使用较少的信道，无线网络质量稍微好些了。
根源还是无线网络太多造成的无线信道拥挤。

# Ref
[List of WLAN channels](https://en.wikipedia.org/wiki/List_of_WLAN_channels)  
[How to boost your Wi-Fi speed by choosing the right channel](http://www.extremetech.com/computing/179344-how-to-boost-your-wifi-speed-by-choosing-the-right-channel)  
[一种检测各个信道wifi信号质量的方法 ](http://www.google.com/patents/CN104507113A?cl=zh)  
[无线 WIFI 的13个信道频率范围](https://cnzhx.net/blog/13-channels-of-wifi/)  
[（有图有真相）2.4G频段的WiFi干扰有多严重](http://bbs.c114.net/thread-824234-1-1.html)  
[2.4G wifi 的频道/信道 20M 40M的概念，区别](http://blog.csdn.net/strugglelg/article/details/38893287)  
[频段带宽怎么设置？频段带宽20好还是40好？](http://jingyan.baidu.com/article/e4511cf3570ae62b845eaf98.html)  




