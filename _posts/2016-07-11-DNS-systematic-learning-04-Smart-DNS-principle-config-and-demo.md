---
layout: post
title: DNS 系统性学习 04 - 智能 DNS 原理配置演示
description: "DNS 系统性学习 04 - 智能 DNS 原理配置演示"
category: Network
avatarimg:
tags: [Network, DNS, BIND]
duoshuo: true
---


# DNS 的负载均衡
通过 DNS 实现的负载均衡只是简单的轮询，还有就是不能对后端节点进行健康检测，了解这个特点即可，不建议使用 DNS 来做这种负载均衡。

# 配置 DNS 视图来实现智能 DNS

原理：根据客户端的 IP 来返回对应的资源记录

## 1 named.conf 增加 acl group 配置

```bash
[root@ns-master ~]# cat /var/named/chroot/etc/named.conf 
options {
  version "1.1.1";
  listen-on port 53 {any;};
  directory "/var/named/chroot/etc/";
  pid-file "/var/named/chroot/var/run/named/named.pid";
  allow-query { any; };
  Dump-file "/var/named/chroot/var/log/binddump.db";
  Statistics-file "/var/named/chroot/var/log/named_stats";
  zone-statistics yes;
  memstatistics-file "log/mem_stats";
  empty-zones-enable no;
  forwarders {202.106.196.115;8.8.8.8; };
};

key "rndc-key" {
        algorithm hmac-md5;
        secret "Eqw4hClGExUWeDkKBX/pBg==";
};

controls {
       inet 127.0.0.1 port 953
               allow { 127.0.0.1; } keys { "rndc-key"; };
 };

logging {
  channel warning {
    file "/var/named/chroot/var/log/dns_warning" versions 10 size 10m;
    severity warning;
    print-category yes;
    print-severity yes;
    print-time yes;
  };
  channel general_dns {
    file "/var/named/chroot/var/log/dns_log" versions 10 size 100m;
    severity info;
    print-category yes;
    print-severity yes;
    print-time yes;
  };
  category default {
    warning;
  };
  category queries {
    general_dns;
  };
};

acl group1 {
  192.168.56.13;
};

acl group2 {
  192.168.56.14;
};

include "/var/named/chroot/etc/view.conf";

```    

## 2 配置视图文件 view.conf 中不同的组使用不同的区域文件（同一域名下）

```bash
[root@ns-master ~]# cat /var/named/chroot/etc/view.conf
view "GROUP1" {
  match-clients { group1; };
  zone "viewexample.com" {
    type master;
    file "group1.viewexample.com.zone";
  };
};

view "GROUP2" {
  match-clients { group2; };
  zone "viewexample.com" {
    type master;
    file "group2.viewexample.com.zone";
  };
};
```    
## 3 同一域名下不同的区域文件内容

一个域名对应多个 A 记录，分别在不同的区域文件配置

```bash
vim /var/named/chroot/etc/group1.viewexample.com.zone
$ORIGIN .
$TTL 3600       ; 1 hour
viewexample.com                  IN SOA  op.viewexample.com. dns.viewexample.com. (
                                2005       ; serial
                                900        ; refresh (15 minutes)
                                600        ; retry (10 minutes)
                                86400      ; expire (1 day)
                                3600       ; minimum (1 hour)
                                )
                        NS      op.viewexample.com.
$ORIGIN viewexample.com.
op                 A       192.168.122.1
view               A       192.168.122.1

vim /var/named/chroot/etc/group2.viewexample.com.zone 
$ORIGIN .
$TTL 3600       ; 1 hour
viewexample.com                  IN SOA  op.viewexample.com. dns.viewexample.com. (
                                2005       ; serial
                                900        ; refresh (15 minutes)
                                600        ; retry (10 minutes)
                                86400      ; expire (1 day)
                                3600       ; minimum (1 hour)
                                )
                        NS      op.viewexample.com.
$ORIGIN viewexample.com.
op                 A       192.168.122.2
view               A       192.168.122.2

# 修改区域文件属主后重新加载
chown named.named /var/named/chroot/etc/group*.zone
rndc reload

```    

## 4 分别在不同 IP 的服务器上测试同一域名返回的 A 记录 

```bash
[root@ns-master ~]# ip a | grep eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    inet 192.168.56.13/24 brd 192.168.56.255 scope global eth0
[root@ns-master ~]# host view.viewexample.com 192.168.56.13
Using domain server:
Name: 192.168.56.13
Address: 192.168.56.13#53
Aliases: 

view.viewexample.com has address 192.168.122.1

[root@ns-slave ~]# host view.viewexample.com 192.168.56.13
Using domain server:
Name: 192.168.56.13
Address: 192.168.56.13#53
Aliases: 

view.viewexample.com has address 192.168.122.2

# 可以从上面的结果看到，在不同的服务器上，view.viewexample.com 返回的 IP 地址不同。
```    
