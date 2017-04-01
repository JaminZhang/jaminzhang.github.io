---
layout: post
title: MySQL 主从复制原理
description: "MySQL 主从复制原理"
category: MySQL
avatarimg:
tags: [Database, MySQL, Replication, binlog]
duoshuo: true
---



# 引言

MySQL 主从复制原理是相当基础的知识，很久没有接触过 MySQL 主从复制了，因为我这边负责的业务暂时没用使用 MySQL 主从复制。  
既然有些忘记了，现在我重新复习记录下。

# MySQL 主从复制介绍

<pre>

MySQL 的主从复制是一个异步的复制过程（但一般情况下感觉是实时同步的），
数据库数据从一个 MySQL 数据库（我们称之为 Master）复制到另一个 MySQL 数据库（我们称之为 Slave）。
在 Master 与 Slave 之间实现整个主从复制的过程是由三个线程参与完成的。
其中有两个线程（SQL 线程和 IO 线程）在 Slave 端，另外一个线程（IO 线程）在 Master 端。（来自 MySQL 帮助文档）

</pre>


# MySQL Replication 复制过程

1. Slave 服务器上执行`start slave`，开启主从复制开关。
2. 此时，Slave 服务器上的 IO 线程会通过 Master 服务器上授权的有复制权限的用户请求连接 Master 服务器，  
   并请求从指定 binlog 日志文件的指定位置之后发送 binlog 日志内容。  
   （日志文件名和位置就是在配置主从复制任务时执行`change master`命令时指定的）  
3. Master 服务器接收到来自 Slave 服务器的 IO 线程的请求后，  
   Master 服务器上的 IO 线程根据 Slave 服务器的 IO 线程请求的信息，  
   读取指定 binlog 日志文件指定位置之后的 binlog 日志信息，然后返回给 Slave 端的 IO 线程。  
   返回的信息中除了 binlog 日志内容外，  
   还有本次返回日志内容后在 Master 服务器端的新的 binlog 文件名以及在 binlog 中的下一个指定更新位置。  
4. 当 Slave 服务器的 IO 线程获取来自 Master 服务器上 IO 线程发送的日志内容及日志文件和位置点后，
   将 binlog 日志内容依次写入到 Slave 端自身的 relay log（即中继日志）文件（mysql-relay-bin.xxxxxx）的最末端，  
   并将新的 binlog 文件名和位置记录到 `master-info` 文件中，  
   以便下一次读取 Master 端新 binlog 日志时，  
   能告诉 Master 服务器需要从新 binlog 日志的哪个文件哪个位置开始请求新的 binlog 日志内容。
5. Slave 服务器端的 SQL 线程会实时检测本地 relay log 中新增加的日志内容，  
   然后及时的把 relay log 文件中的内容解析成在 Master 端曾经执行的 SQL 语句的内容，  
   并在自身 Slave 服务器上按语句的顺序执行应用这些 SQL 语句，应用完毕后清理应用过的日志。
6. 经过了上面的过程，就可以确保在 Master 端和 Slave 端执行了同样的 SQL 语句。  
   当复制状态正常的情况下，Master 端和 Slave 端的数据是完全一样的。  
   
![MySQL-Master-Slave-Replication-Principle-Scheme](http://s3.51cto.com/wyfs02/M02/29/5A/wKiom1N9fw-jbU08AAN-tSxOxl0447.jpg)  

# Ref
[mysql 主从复制](http://chocolee.blog.51cto.com/8158455/1415173)  
