---
layout: post
title: Python Socket 编程入门与演示
description: "Python Socket 编程入门与演示"
category: Python
avatarimg:
tags: [Python, Socket]
duoshuo: true
---


Python Socket 编程入门演示

# 引言
今天电话面试有个问题，是问我怎么用 Python 进行 Socket 编程，因为自己很久没有用 Python 写过东西了，Socket 编程记得很久之前看过，但具体怎么编写，Socket 模块相关的方法，确实忘记了。  
一直没有碰到写这个的需求，所以就不知道具体怎么写了。  
所以现在我就把这个问题当做一个需求，重新学习一下 Python Socket 编程具体过程与编码。
看了 Python Socket 编程相关资料演示，还是比较容易快速上手的。

# TCP Socket 编程过程与方法图示

![TCP Socket 编程过程与方法图示](http://s3.51cto.com/wyfs02/M01/8A/DD/wKiom1g9Z5iS1tf9AAFr9XDUJts955.png)  

# Python 简单 Socket 通信模型编程过程与演示


## socket server 服务端脚本文件

```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-

import socket

# 以元组形式定义一个 IP 地址和端口
ip_port = ('127.0.0.1',9999)

# 创建对象并绑定 IP 地址开始监听
sk = socket.socket()
sk.bind(ip_port)
sk.listen(5)

# 开始接收消息
while True:
    print 'server waiting...'
    # conn 表示客户端与服务端建立连接后的专有通信线路
    conn,addr = sk.accept() # accept 属于阻塞式，没有收到连接请求就不会继续向下运行

    # 接收客户端发来的消息
    client_data = conn.recv(1024) # recv 也属于阻塞式
    print client_data

    # 回复消息
    conn.sendall('服务端已收到消息！')

    # 关闭连接
    conn.close()
```

## socket client 客户端脚本文件

```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-

import socket

ip_port = ('127.0.0.1',9999)

sk = socket.socket()

sk.connect(ip_port)

sk.sendall('服务器端！我是客户端...')

server_reply = sk.recv(1024)

print server_reply
sk.close

```    

## Python 简单 Socket 通信模型过程演示

### 1. 启动 Socket Server，开始监听 Socket
```bash
[root@VM_15_187_centos socket]# python socket_server.py # 前台运行 socket_server.py, 开始监听 Socket 端口
server waiting...

[root@VM_15_187_centos socket]# netstat -lntp | grep 9999 #  socket_server 监听 Socket IP 和端口为 127.0.0.1:9999
tcp        0      0 127.0.0.1:9999              0.0.0.0:*                   LISTEN      17411/python  
```    

### 2. 启动 Socket Client，向 Socket Server 发送数据

```bash
[root@VM_15_187_centos socket]# python socket_client.py 
服务端已收到消息！				# 此处是接收到的来自于服务端返回的消息
```    

### 3. Socket Server 接收到来自客户端的数据

```bash
[root@VM_15_187_centos socket]# python socket_server.py 
server waiting...
服务器端！我是客户端...			# 此处是接收到的来自于客户端发送过来消息

```    

# Ref
[自动化运维Python系列（七）之Socket编程](http://lilongzi.blog.51cto.com/5519072/1877897)  
[python socket编程详细介绍](http://yangrong.blog.51cto.com/6945369/1339593)  
[Socket Programming HOWTO](https://docs.python.org/2/howto/sockets.html)  
[17.2. socket — Low-level networking interface](https://docs.python.org/2/library/socket.html)  

