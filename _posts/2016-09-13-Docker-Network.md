---
layout: post
title: Docker 网络访问
description: "Docker 网络访问"
category: Docker
avatarimg:
tags: [Docker, Network, NAT]
duoshuo: true
---


Docker 网络访问

Docker 允许通过外部访问容器或容器互联的方式来提供网络服务。

# 外部访问容器

容器中可以运行一些网络应用，要让外部也可以访问这些应用
默认 Docker 会创建一个桥接的网卡 docker0, 然后提供了两种网络端口映射方法：

* 随机端口映射 -P 参数
* 指定端口映射 -p 参数

## 随机端口映射

当使用 -P 参数时，Docker 会随机映射一个端口到内部容器开放的网络端口。

```bash
# 运行一个守护态的 nginx 容器，使用随机端口映射
[root@linux-node1 ~]# docker run -d -P nginx
7236cf1a985aff380272cef71683413768738217831b7434cc8829632f4a144b

[root@linux-node1 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                           NAMES
7236cf1a985a        nginx               "nginx -g 'daemon off"   10 seconds ago      Up 9 seconds        0.0.0.0:32773->80/tcp, 0.0.0.0:32772->443/tcp   adoring_poincare
# 从上面可以看到，本地主机的 32773 端口映射到了容器的 80 端口，32772 端口映射到了容器的 443 端口
# 我们可以通过本地主机的端口来访问对应容器内的应用

# 查看本地主机监听端口
[root@linux-node1 ~]# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      2240/sshd           
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      2335/master         
tcp6       0      0 :::32772                :::*                    LISTEN      49792/docker-proxy  
tcp6       0      0 :::32773                :::*                    LISTEN      49799/docker-proxy  

# 查看 iptables 中 docker 对应的 NAT
[root@linux-node1 ~]# iptables -t nat -vnL
Chain PREROUTING (policy ACCEPT 2 packets, 130 bytes)
 pkts bytes target     prot opt in     out     source               destination         
  117  6012 DOCKER     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT 2 packets, 130 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 1 packets, 71 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 DOCKER     all  --  *      *       0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT 3 packets, 175 bytes)
 pkts bytes target     prot opt in     out     source               destination         
   62  3836 MASQUERADE  all  --  *      !docker0  172.17.0.0/16        0.0.0.0/0           
    0     0 MASQUERADE  tcp  --  *      *       172.17.0.2           172.17.0.2           tcp dpt:443
    0     0 MASQUERADE  tcp  --  *      *       172.17.0.2           172.17.0.2           tcp dpt:80

Chain DOCKER (2 references)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 RETURN     all  --  docker0 *       0.0.0.0/0            0.0.0.0/0           
    0     0 DNAT       tcp  --  !docker0 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:32772 to:172.17.0.2:443
    2   104 DNAT       tcp  --  !docker0 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:32773 to:172.17.0.2:80

# 进入 nginx 容器查看 IP 地址
root@7236cf1a985a:/# ip ad li
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
46: eth0@if47: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:2/64 scope link 
       valid_lft forever preferred_lft forever

# 通过 docker logs 查看 nginx 容器的日志
[root@linux-node1 ~]# docker logs -f 7236cf1a985a
192.168.56.1 - - [18/Sep/2016:11:40:18 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36" "-"
192.168.56.1 - - [18/Sep/2016:11:40:18 +0000] "GET /favicon.ico HTTP/1.1" 404 571 "http://192.168.56.11:32773/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36" "-"
2016/09/18 11:40:18 [error] 6#6: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 192.168.56.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "192.168.56.11:32773", referrer: "http://192.168.56.11:32773/"

```    

随机端口映射可用于测试环境，这样端口没有冲突。


## 指定端口映射

-p（小写的）则可以指定要映射的端口，并且，在一个指定端口上只可以绑定一个容器。支持的格式有 `ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort`。

```bash
# 运行一个 nginx 容器，指定本地主机上的 80 端口映射到容器的 80 端口
[root@linux-node1 ~]# docker run -d -p 192.168.56.11:80:80 --name mynginx nginx
420066be5a1dce1c19b3c8329177bd320c2657d58559b739a18241602f70d250
[root@linux-node1 ~]# docker ps -l
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
420066be5a1d        nginx               "nginx -g 'daemon off"   2 minutes ago       Up 2 minutes        192.168.56.11:80->80/tcp, 443/tcp   mynginx

# 使用 docker port 直接查看端口映射情况
[root@linux-node1 ~]# docker port mynginx
80/tcp -> 192.168.56.11:80

# -p 参数可以有多个，示例如下：
[root@linux-node1 ~]# docker run -d -p 82:80 -p 443:443 --name nginxv2 nginx
30fd50542bb541799c688e113f15d0094791822ea2d0370fd1cd86354501f842
[root@linux-node1 ~]# docker port nginxv2
80/tcp -> 0.0.0.0:82
443/tcp -> 0.0.0.0:443

```    
> 
Docker 的网络端口映射是用 NAT 实现，会影响网络性能，在生产环境需要注意。

# Ref
[外部访问容器](https://yeasy.gitbooks.io/docker_practice/content/network/port_mapping.html)  
