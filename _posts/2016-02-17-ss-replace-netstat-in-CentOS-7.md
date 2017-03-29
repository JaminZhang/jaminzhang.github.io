---
layout: post
title: CentOS 7 下 ss 替代 netstat
description: "CentOS 7 下 ss 替代 netstat"
category: Linux
avatarimg:
tags: [Linux, CentOS, ss, netstat]
duoshuo: true
---

# 引言

在一台 CentOS 7 服务器上使用 netstat 命令时，提示没有此命令。为什么？

# CentOS 7 下 ss 替代 netstat

原因是什么？简单来说，在有大量 sockets 时，ss 更加高效快速。
下面这篇文章对此进行了详细说明。我这就不再多说了。  
[《篡权的 ss》](http://roclinux.cn/?p=2420)  

# ss 输出格式有缺憾

既然 CentOS 7 在默认最小化安装中摒弃了 netstat (属于 net-tools 包)，那么还是熟悉使用 ss 吧。  
我使用 netstat 最常用的选项是 `netstat -lntp`，转换到 ss 时，几个选项都还继承了 netstat 的意义。

```bash

[root@linux-node2 ~]# ss -ltnp
State      Recv-Q Send-Q                                                            Local Address:Port                                                                           Peer Address:Port              
LISTEN     0      50                                                                            *:3306                                                                                      *:*                   users:(("mysqld",pid=3310,fd=14))
LISTEN     0      50                                                                192.168.56.12:9200                                                                                      *:*                   users:(("java",pid=30992,fd=85))
LISTEN     0      128                                                                           *:8081                                                                                      *:*                   users:(("httpd",pid=58518,fd=3),("httpd",pid=32905,fd=3),("httpd",pid=32904,fd=3),("httpd",pid=32903,fd=3),("httpd",pid=32902,fd=3),("httpd",pid=32901,fd=3))
LISTEN     0      50                                                                192.168.56.12:9300                                                                                      *:*                   users:(("java",pid=30992,fd=80))
LISTEN     0      128                                                                           *:22                                                                                        *:*                   users:(("sshd",pid=20133,fd=3))
LISTEN     0      100                                                                   127.0.0.1:25                                                                                        *:*                   users:(("master",pid=2048,fd=13))
LISTEN     0      511                                                                           *:5601                                                                                      *:*                   users:(("node",pid=32500,fd=11))
LISTEN     0      100                                                                         ::1:25                                                                                       :::*                   users:(("master",pid=2048,fd=14))
[root@linux-node2 ~]# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      3310/mysqld         
tcp        0      0 192.168.56.12:9200      0.0.0.0:*               LISTEN      30992/java          
tcp        0      0 0.0.0.0:8081            0.0.0.0:*               LISTEN      32901/httpd         
tcp        0      0 192.168.56.12:9300      0.0.0.0:*               LISTEN      30992/java          
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      20133/sshd          
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      2048/master         
tcp        0      0 0.0.0.0:5601            0.0.0.0:*               LISTEN      32500/node          
tcp6       0      0 ::1:25                  :::*                    LISTEN      2048/master  

```    

看了上面 ss 和 netstat 的输出结果（这里显示得很长，实际在日常使用的终端连接软件上，一般最后一列会换行），  
真让我不太想用 ss 了，有没有办法格式化下输出呢？  
不止我一人这样想，[ss - linux socket statistics utility output format](http://unix.stackexchange.com/questions/252744/ss-linux-socket-statistics-utility-output-format) 里面的这位和我一样的想法。  
回答里面具体说了 ss 输出格式不太美观的原因，也推荐了几种方法稍微格式化一下输出。  
如 `ss -lntp | cat`。  

现在我还是 2 个命令都使用，因为还是看不太惯 ss 的程序信息列输出。


# Ref
[《篡权的 ss》](http://roclinux.cn/?p=2420)  
[ss - linux socket statistics utility output format](http://unix.stackexchange.com/questions/252744/ss-linux-socket-statistics-utility-output-format) 
[Commands not found: netstat, nmap on CentOS 7](http://unix.stackexchange.com/questions/146190/commands-not-found-netstat-nmap-on-centos-7)  
