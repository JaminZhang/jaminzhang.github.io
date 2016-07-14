---
layout: post
title: DNS 系统性学习 03 - BIND 域名配置管理
description: "DNS 系统性学习 03 - BIND 域名配置管理"
category: Network
avatarimg:
tags: [Network, DNS, BIND, CNAME, MX]
duoshuo: true
---


# 1 添加A、CNAME、MX、PTR记录

以下操作都在 Master DNS 上做操作：

增加一条 A 记录 和 一条 MX 记录： 

* a               A       192.168.122.100  
* mx               MX 5       192.168.122.101  

```bash
# 如下：

[root@ns-master ~]# tail -2 /var/named/chroot/etc/example.com.zone 
a               A       192.168.122.100  
mx               MX 5       192.168.122.101  

# 重新加载区域文件
[root@ns-master ~]# rndc reload
WARNING: key file (/etc/rndc.key) exists, but using default configuration file (/etc/rndc.conf)
server reload successful


# 检查增加的 DNS 记录

[root@ns-master ~]# dig @192.168.56.13 a.example.com

; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.47.rc1.el6 <<>> @192.168.56.13 a.example.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 49576
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; QUESTION SECTION:
;a.example.com.			IN	A

;; ANSWER SECTION:
a.example.com.		3600	IN	A	192.168.122.100			# 查询到了 a.example.com 的 A 记录

;; AUTHORITY SECTION:
example.com.		3600	IN	NS	op.example.com.

;; ADDITIONAL SECTION:
op.example.com.		3600	IN	A	1.2.3.4

;; Query time: 1 msec
;; SERVER: 192.168.56.13#53(192.168.56.13)
;; WHEN: Fri Jul  8 23:44:35 2016
;; MSG SIZE  rcvd: 80

[root@ns-master ~]# dig @192.168.56.13 mx.example.com

; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.47.rc1.el6 <<>> @192.168.56.13 mx.example.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60566
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 0

;; QUESTION SECTION:
;mx.example.com.			IN	A

;; AUTHORITY SECTION:
example.com.		3600	IN	SOA	op.example.com. dns.example.com. 2000 900 600 86400 3600	# 并没有立即查询到 mx.example.com 的 和 MX 记录

;; Query time: 1 msec
;; SERVER: 192.168.56.13#53(192.168.56.13)
;; WHEN: Fri Jul  8 23:44:50 2016
;; MSG SIZE  rcvd: 75

[root@ns-master ~]# host mx.example.com 192.168.56.13
Using domain server:
Name: 192.168.56.13
Address: 192.168.56.13#53
Aliases: 

mx.example.com mail is handled by 5 192.168.122.101.example.com.	# host 命令可以查询到 mx.example.com 的 和 MX 记录

```    
# 2 配置反向解析

# 2.1 view.conf 配置文件中增加反向解析区域配置

内容如下：

```bash
[root@ns-master ~]# cat /var/named/chroot/etc/view.conf 
view "View" {
  zone "example.com" {
        type    master;
        file    "example.com.zone";
        allow-transfer {
                192.168.56.14;
        };
        notify  yes;
        also-notify {
                192.168.56.14;
        };
  };
  zone "168.192.in-addr.arpa" {		# 从此处开始，增加反向解析区域配置
        type    master;
        file    "168.192.zone";
        allow-transfer {
                192.168.56.14;
        };
        notify  yes;
        also-notify {
                192.168.56.14;
        };
  };								# 此处结束
};
```    

# 2.2 增加反向解析区域文件

内容如下：

```bash
[root@ns-master ~]# cat /var/named/chroot/etc/168.192.zone
$TTL 3600       ; 1 hour
@                  IN SOA  op.example.com. dns.example.com. (
                                2004       ; serial
                                900        ; refresh (15 minutes)
                                600        ; retry (10 minutes)
                                86400      ; expire (1 day)
                                3600       ; minimum (1 hour)
                                )
                        NS      op.example.com.
102.122     IN      PTR     a.example.com.

# 修改区域文件属主
[root@ns-master ~]# chown named.named  /var/named/chroot/etc/168.192.zone
[root@ns-master ~]# rndc reload

# 使用 host 命令测试反向解析

[root@ns-master ~]# host 192.168.122.102 192.168.56.13
Using domain server:
Name: 192.168.56.13
Address: 192.168.56.13#53
Aliases: 

102.122.168.192.in-addr.arpa domain name pointer a.example.com.


```    

# 3 主从DNS下，Slave DNS 服务器 view.conf 配置文件增加反向解析区域配置

```bash
[root@ns-slave ~]# cat /var/named/chroot/etc/view.conf
view "SlaveView" {
        zone "example.com" {
             type    slave;
             masters {192.168.56.13; };
             file    "slave.example.com.zone";
        };
	zone "168.192.in-addr.arpa" {
             type    slave;
             masters {192.168.56.13; };
             file    "slave.168.192.zone";
        };
};
[root@ns-slave ~]# rndc reload
WARNING: key file (/etc/rndc.key) exists, but using default configuration file (/etc/rndc.conf)
server reload successful

# 使用 host 命令测试反向解析 
[root@ns-slave ~]# host 192.168.122.102 192.168.56.14
Using domain server:
Name: 192.168.56.14
Address: 192.168.56.14#53
Aliases: 

102.122.168.192.in-addr.arpa domain name pointer a.example.com.

```        
