---
layout: post
title: SaltStack 系统性学习 04 - SaltStack 与 ZeroMQ
description: "SaltStack 系统性学习 04 - SaltStack 与 ZeroMQ"
category: SaltStack
avatarimg:
tags: [SaltStack, ZeroMQ]
duoshuo: true
---

# 引言

<pre>
我们进行自动化运维大多数情况下，是我们的服务器数量已经远远超过人工 SSH 维护的范围，SaltStack 可以支数以千计，甚至更多的服务器。   
这些性能的提供主要来自于 ZeroMQ，因为 SaltStack 底层是基于 ZeroMQ 进行高效的网络通信。   
ZMQ 用于 node 与 node 间的通信，node 可以是主机也可以是进程。    
</pre>

# ZeroMQ 简介
<pre>
  ZeroMQ（我们通常还会用ØMQ , 0MQ, zmq等来表示）是一个简单好用的传输层，像框架一样的一个套接字库，他使得Socket编程更加简单、简洁和性能更高。它还是一个消息处理队列库，可在多个线程、内核和主机盒之间弹性伸缩。
</pre>

# 发布与订阅

ZeroMQ 支持 Publish/Subscribe，即发布与订阅模式，我们经常简称 Pub/Sub。

![Publish/Subscribe](https://www.unixhot.com/uploads/article/20151027/055f24981e25860e08942d7f0aa9d0ab.png)  

Salt Master 运行两个网络服务，其中一个是 ZeroMQ PUB 系统，默认监听 4505 端口。可以通过修改 /etc/salt/master 配置文件的 publish_port 参数设置。它是 Salt 的消息发布系统，如果查看 4505 端口，会发现所有的 Minion 连接到 Master 的 4505 端口，TCP 状态持续保持为 ESTABLISHED。  

```bash
[root@linux-node1 ~]# lsof -i:4505
COMMAND     PID USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
salt-mini  6850 root   25u  IPv4 9026901      0t0  TCP linux-node1:57317->linux-node1:4505 (ESTABLISHED)
salt-mast 23866 root   16u  IPv4 8202334      0t0  TCP *:4505 (LISTEN)
salt-mast 23866 root   18u  IPv4 8402107      0t0  TCP linux-node1:4505->linux-node2:54245 (ESTABLISHED)
salt-mast 23866 root   19u  IPv4 9026902      0t0  TCP linux-node1:4505->linux-node1:57317 (ESTABLISHED)

```    

这样 Salt Master 发布一个消息，所有连接到 4505 这个 Pub 端口上的 Minion 都会接收到这个消息。然后每个 Minion 会再判断自己是否需要执行这个消息。


# 请求与响应
ZeroMQ 支持 Request-Reply，即请求与响应模式，我们经常简称 REQ/REP。  
![Request-Reply](https://www.unixhot.com/uploads/article/20151027/26dac78d08953a61af295d376ca29cfe.png)  

Salt Master 运行的第二个网络服务就是 ZeroMQ REP 系统，默认监听 4506 端口，可以通过修改 /etc/salt/master 配置文件的 ret_port 参数设置。它是 Salt 客户端与服务端通信的端口。比如说 Minion 执行某个命令后的返回值就是发送给 Master 的 4506 这个 REP 端口
我们可以安装 python-setproctitle 软件包，这样我们可以直接看到 Salt Master 启动的进程的名称。

```bash
[root@linux-node1 ~]# yum install python-setproctitle -y
[root@linux-node1 ~]# systemctl restart salt-master
[root@linux-node1 ~]# ps aux | grep salt-master
root     ...... /usr/bin/python /usr/bin/salt-master ProcessManager					# 中心进程管理器
root     ...... /usr/bin/python /usr/bin/salt-master MultiprocessingLoggingQueue	
root     ...... /usr/bin/python /usr/bin/salt-master ZeroMQPubServerChannel			# 将任务 PUB 到 Minion 端
root     ...... /usr/bin/python /usr/bin/salt-master EventPublisher					# Event Publisher 进程
root     ...... /usr/bin/python /usr/bin/salt-master Maintenance
root     ...... /usr/bin/python /usr/bin/salt-master Reactor
root     ...... /usr/bin/python /usr/bin/salt-master ReqServer_ProcessManager		# ReqServer 进程管理器
root     ...... /usr/bin/python /usr/bin/salt-master MWorkerQueue					# 将 Ret 接口(ROUTER)数据转发到 Worker(DEALER)
root     ...... /usr/bin/python /usr/bin/salt-master MWorker-0						# 工作进程
root     ...... /usr/bin/python /usr/bin/salt-master MWorker-1						# 工作进程
root     ...... /usr/bin/python /usr/bin/salt-master MWorker-2						# 工作进程
root     ...... /usr/bin/python /usr/bin/salt-master MWorker-3						# 工作进程
root     ...... /usr/bin/python /usr/bin/salt-master MWorker-4						# 工作进程
root     ...... grep --color=auto salt-master

```    

# Ref
[SaltStack快速入门（5）-SaltStack与ZeroMQ](https://www.unixhot.com/article/15)  
[ØMQ(ZeroMQ)简介](http://www.infoq.com/cn/news/2010/09/introduction-zero-mq)  
[ZeroMQ简介](http://holbrook.github.io/2013/07/03/zeromq_intro.html)  

