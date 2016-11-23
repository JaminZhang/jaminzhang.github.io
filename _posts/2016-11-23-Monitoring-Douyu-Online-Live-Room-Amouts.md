---
layout: post
title: 监控斗鱼在线直播间数
description: "监控斗鱼在线直播间数"
category: Monitoring
avatarimg:
tags: [Douyu, API]
duoshuo: true
---

# 引言
访问斗鱼首页，会显示当前在线的直播间数量，我想获取这个数据并出图，  
这是一个最常见的监控需求。那么如何从外部第三方来实现呢？

# 思路及实现

## 1. 首先要获取这个数据

一开始，我想到的最直接的方式是，下载首页 HTML，然后提取出数据。（提取方式可以直接用 Shell 或更专业的 Python）  
但下载首页后，并没有发现相关的数据。数据并不是写死在 HTML 中的，而是动态载入的。  
直接从网页上抓取无法获得数据。  
于是我们通过 Chrome 浏览器开发者工具来对其进行分析，可以找到在线直播间数是在这个 API 接口中：`https://www.douyu.com/home/api`  
于是我们就可以通过这个 API 来提取这个数据了。  
由于我现在只需要获取这一个数据，使用 Shell 就足够了。（Python 可能在做复杂提取解析时更高效。）

可以马上写出提取在线直播间数的脚本：

```bash
[root@VM_15_187_centos ~]# cat /usr/local/sbin/get_douyu_live_room.sh 
#!/bin/bash
ALL_COUNT=`/usr/bin/curl -s https://www.douyu.com/home/api  | egrep -o '"all_count":.*,"live_room"' | egrep -o "[0-9]*"`

cat > /usr/share/nginx/html/douyu/live_room.html <<  EOF
<pre>
douyu_online_room:${ALL_COUNT}
</pre>
EOF

```    

上面的脚本我们可以看到，将数据写到了 1 个 HTML 中了，这个后面出图时会用到，因为要从这里获取数据。  
然后我们使用 crontab 定时获取数据(使用 5 分钟间隔，因为后面的出图监控频率也是 5 分钟)：

```bash
[root@VM_15_187_centos ~]# crontab -l
# Get Douyu Live Room
*/5 * * * * /bin/sh /usr/local/sbin/get_douyu_live_room.sh
```    


## 2. 根据这个数据来出图

第一步中，我们获取到了数据，一般情况下，我们需要将这个数据保存到一个位置，然后通过绘图软件读取这个数据并出图。  
作为运维，我们常使用的 Zabbix 等可以实现，但是实现方式太重了（依赖数据库）。  
我只有这个简单的需求，并不想安装配置重量级的监控软件，先找到了 Munin 这个轻量级的监控软件。  
它可以支持自定义监控和出图。它还是需要安装配置。  
在这个过程中，我想到，现在是云计算的时代，第三方也有监控服务，比如监控宝，他们应该有类似自定义监控及出图服务。我们应该学会利用。  
我的这个获取网页中一个动态数据并出图的小需求是很简单，但却是非常通用的。
在监控宝的网站中，可以找到[ 自定义监控功能及配置 ](http://wiki.jiankongbao.com/doku.php/%E6%96%87%E6%A1%A3:%E8%87%AA%E5%AE%9A%E4%B9%89%E7%9B%91%E6%8E%A7)

根据上面的文档我们就能配置出图了。  
下面就是最终的监控图。  

![]()


# Ref
[浅谈如何使用python抓取网页中的动态数据](http://www.cnblogs.com/saintlas/p/5740241.html)  

