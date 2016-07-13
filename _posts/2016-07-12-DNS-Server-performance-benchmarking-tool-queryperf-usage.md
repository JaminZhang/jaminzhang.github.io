---
layout: post
title: DNS 服务器压测工具 queryperf 使用
description: "DNS 服务器压测工具 queryperf 使用"
category: Network
avatarimg:
tags: [Network, DNS, BIND, queryperf]
duoshuo: true
---


# DNS 服务器压测工具 queryperf

# 安装 queryperf

```bash
cd /usr/local/src
wget http://ftp.isc.org/isc/bind9/9.7.3/bind-9.7.3.tar.gz
tar xf bind-9.7.3.tar.gz
cd /usr/local/src/bind-9.7.3/contrib/queryperf
./configure
make
cp queryperf /usr/bin/
```    

# 使用 queryperf

```bash
# 将需要压测的 DNS 资源记录放置在一个文件中
[root@ns-master queryperf]# cat test.txt 
view.viewexample.com A

# 使用 queryperf 测试及结果查看，主要关注 QPS
[root@ns-master queryperf]# queryperf -d test.txt -s 192.168.56.13

DNS Query Performance Testing Tool
Version: $Id: queryperf.c,v 1.12 2007-09-05 07:36:04 marka Exp $

[Status] Processing input data
[Status] Sending queries (beginning with 192.168.56.13)
[Status] Testing complete

Statistics:

  Parse input file:     once
  Ended due to:         reaching end of file

  Queries sent:         1 queries
  Queries completed:    1 queries
  Queries lost:         0 queries
  Queries delayed(?):   0 queries

  RTT max:         	0.000011 sec
  RTT min:              0.000011 sec
  RTT average:          0.000011 sec
  RTT std deviation:    0.000039 sec
  RTT out of range:     0 queries

  Percentage completed: 100.00%
  Percentage lost:        0.00%

  Started at:           Sat Jul  9 04:21:57 2016
  Finished at:          Sat Jul  9 04:21:57 2016
  Ran for:              0.000047 seconds

  Queries per second:   21276.595745 qps
```      
  
# Ref
[DNS服务器(五)：使用queryperf对DNS服务器作压力测试](http://wubinary.blog.51cto.com/8570032/1379595)  
[使用queryperf对DNS服务器作压力测试](http://sw5720.blog.51cto.com/8812314/1614087)  

