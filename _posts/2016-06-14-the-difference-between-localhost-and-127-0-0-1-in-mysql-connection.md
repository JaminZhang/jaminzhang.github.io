---
layout: post
title:  mysql 连接中 localhost 和 127.0.0.1 的区别
description: "mysql 连接中 localhost 和 127.0.0.1 的区别"
category: MySQL
avatarimg:
tags: [MySQL, localhost, Socket]
duoshuo: true
---

# 引言
在聊天群里看到有人提到 mysql 中 localhost 和 127.0.0.1 的区别，这个之前并没有仔细考虑过。  
现在来学习下。

# localhost 与 127.0.0.1 区别

	localhot(local) 是不经网卡传输！这点很重要，它不受网络防火墙和网卡相关的的限制。
	127.0.0.1 是通过网卡传输，依赖网卡，并受到网络防火墙和网卡相关的限制。
	一般设置程序时本地服务用 localhost 是最好的，localhost 不会解析成 IP，也不会占用网卡、网络资源。
	有时候用 localhost 可以，但用 127.0.0.1 就不可以的情况就是在于此。猜想 localhost 访问时，系统带的本机当前用户的权限去访问，
	而用 IP 的时候，等于本机是通过网络再去访问本机，可能涉及到网络用户的权限。

# MySQL 连接时主机类型

1. mysql -h 127.0.0.1 的时候，使用 TCP/IP 连接
2. mysql -h localhost 的时候，是不使用 TCP/IP 连接的，而使用 Unix socket；此时，mysql server 则认为该 client 是来自 "localhost"

> 
MySQL 手册 5.6.4 ..... A Host value may be a hostname or an IP number, or 'localhost' to indicate the local host.

简而言之：主要区别是 localhost 是通过 unix domain socket 方式来连接，而 127.0.0.1 则是走的 TCP 协议方式连接


# 实例说明

```bash

[root@linux-node1 ~]# mysql -h 127.0.0.1 -P 3306 -uroot -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 853
Server version: 5.5.47-MariaDB MariaDB Server

Copyright (c) 2000, 2015, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> status
--------------
mysql  Ver 15.1 Distrib 5.5.47-MariaDB, for Linux (x86_64) using readline 5.1

Connection id:		853
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server:			MariaDB
Server version:		5.5.47-MariaDB MariaDB Server
Protocol version:	10
Connection:		127.0.0.1 via TCP/IP	# 注意这里
Server characterset:	latin1
Db     characterset:	latin1
Client characterset:	utf8
Conn.  characterset:	utf8
TCP port:		3306
Uptime:			2 days 23 hours 55 min 8 sec

Threads: 1  Questions: 21005  Slow queries: 0  Opens: 72  Flush tables: 2  Open tables: 58  Queries per second avg: 0.081
--------------



[root@linux-node1 ~]# mysql -h localhost -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 857
Server version: 5.5.47-MariaDB MariaDB Server

Copyright (c) 2000, 2015, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> status
--------------
mysql  Ver 15.1 Distrib 5.5.47-MariaDB, for Linux (x86_64) using readline 5.1

Connection id:		857
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server:			MariaDB
Server version:		5.5.47-MariaDB MariaDB Server
Protocol version:	10
Connection:		Localhost via UNIX socket	# 注意这里
Server characterset:	latin1
Db     characterset:	latin1
Client characterset:	utf8
Conn.  characterset:	utf8
UNIX socket:		/var/lib/mysql/mysql.sock
Uptime:			3 days 6 sec

Threads: 1  Questions: 21018  Slow queries: 0  Opens: 72  Flush tables: 2  Open tables: 58  Queries per second avg: 0.081
--------------
```    

# Ref
[mysql连接类型与socket通信原理说明](http://blog.fity.cn/post/348/)  
[Unix Socket 与 IP Socket (TCP/IP) 的区别](http://coseylee.com/2012-04-13-unix-socket-ip-vs-ip-socket.html)  
