---
layout: post
title: DNS 系统性学习 02 - 部署配置 BIND 及 DNS 主从
description: "DNS 系统性学习 02 - 部署配置 BIND 及 DNS 主从"
category: Network
avatarimg:
tags: [Network, DNS, BIND]
duoshuo: true
---


# 1 安装 bind 相关软件

系统环境：CentOS 6.8 x86_64
服务器规划：  

* 192.168.56.13 主 DNS 服务器
* 192.168.56.14 从 DNS 服务器

```bash
[root@ns-master ~]# yum install bind bind-utils bind-devel bind-chroot -y

[root@ns-master ~]# rpm -qa | grep bind
bind-utils-9.8.2-0.47.rc1.el6.x86_64
bind-libs-9.8.2-0.47.rc1.el6.x86_64
bind-chroot-9.8.2-0.47.rc1.el6.x86_64
bind-9.8.2-0.47.rc1.el6.x86_64
bind-devel-9.8.2-0.47.rc1.el6.x86_64

```    
同样在从 DNS 服务器上安装以上软件

# 2 配置文件配置

## 2.1 主 DNS 服务器配置

以下为主 DNS 服务器上面的配置文件 

```bash
# /etc/named.conf bind 主配置文件内容如下：
[root@ns-master ~]# cat /etc/named.conf
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

include "/var/named/chroot/etc/view.conf";

# /etc/rndc.key 配置文件内容如下：
[root@ns-master ~]# cat /etc/rndc.key
key "rndc-key" {
        algorithm hmac-md5;
        secret "Eqw4hClGExUWeDkKBX/pBg==";
};

# /etc/rndc.conf 配置文件内容如下：
[root@ns-master ~]# cat /etc/rndc.conf
key "rndc-key" {
        algorithm hmac-md5;
        secret "Eqw4hClGExUWeDkKBX/pBg==";
};

options {
        default-key "rndc-key";
        default-server 127.0.0.1;
        default-port 953;
};


# /var/named/chroot/etc/view.conf 配置文件内容如下：
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
};

# /var/named/chroot/etc/example.com.zone 区域文件内容如下：
[root@ns-master ~]# cat /var/named/chroot/etc/example.com.zone
$ORIGIN .
$TTL 3600       ; 1 hour
example.com                  IN SOA  op.example.com. dns.example.com. (
                                2000       ; serial
                                900        ; refresh (15 minutes)
                                600        ; retry (10 minutes)
                                86400      ; expire (1 day)
                                3600       ; minimum (1 hour)
                                )
                        NS      op.example.com.
$ORIGIN example.com.
shanks              A       1.2.3.4
op              A       1.2.3.4

# 以上配置文件配置好以后，修改目录权限，启动 named
[root@ns-master ~]# cd /var && chown -R named.named named/
[root@ns-master var]# /etc/init.d/named start
Starting named:                                            [  OK  ]
[root@ns-master var]# chkconfig named on

# 测试 DNS 服务器响应
[root@ns-master var]# dig @127.0.0.1 a.example.com

; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.47.rc1.el6 <<>> @127.0.0.1 a.example.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 29101
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 0

;; QUESTION SECTION:
;a.example.com.			IN	A

;; AUTHORITY SECTION:
example.com.		3600	IN	SOA	op.example.com. dns.example.com. 2000 900 600 86400 3600

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Fri Jul  8 20:00:59 2016
;; MSG SIZE  rcvd: 74

# 以上就是配置好了主 DNS 服务器
```    

## 2.2 从 DNS 服务器配置


从 DNS 服务器上面的以下配置文件与主 DNS 服务器上面的相同：

* /etc/named.conf  
* /etc/rndc.key  
* /etc/rndc.conf  

从 DNS 服务器上配置以上文件（与主 DNS 服务器上面的相同）。

```bash
cat > /etc/named.conf << EOF
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

include "/var/named/chroot/etc/view.conf";
EOF

cat > /etc/rndc.key << EOF
key "rndc-key" {
        algorithm hmac-md5;
        secret "Eqw4hClGExUWeDkKBX/pBg==";
};
EOF

cat > /etc/rndc.conf << EOF
key "rndc-key" {
        algorithm hmac-md5;
        secret "Eqw4hClGExUWeDkKBX/pBg==";
};

options {
        default-key "rndc-key";
        default-server 127.0.0.1;
        default-port 953;
};
EOF

# 从 DNS 服务器上 /var/named/chroot/etc/view.conf 和主 DNS 服务器不一样，配置如下：

[root@ns-slave ~]# cat /var/named/chroot/etc/view.conf
view "SlaveView" {
        zone "example.com" {
             type    slave;
             masters {192.168.56.13; };
             file    "slave.example.com.zone";
        };
};

# 以上配置文件配置好以后，修改目录权限，启动 named
cd /var && chown -R named.named named/
/etc/init.d/named start
chkconfig named on

# 当在 /var/named/chroot/etc 目录下有 slave.example.com.zone 这个文件时就说明 DNS 主从同步成功了
[root@ns-slave var]# ll /var/named/chroot/etc/slave.example.com.zone 
-rw-r--r-- 1 named named 331 Jul  8 20:43 /var/named/chroot/etc/slave.example.com.zone

# 使用 dig 命令测试
[root@ns-slave var]# dig @192.168.56.14 op.example.com

; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.47.rc1.el6 <<>> @192.168.56.14 op.example.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 4234
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0

;; QUESTION SECTION:
;op.example.com.			IN	A

;; ANSWER SECTION:
op.example.com.		3600	IN	A	1.2.3.4

;; AUTHORITY SECTION:
example.com.		3600	IN	NS	op.example.com.

;; Query time: 0 msec
;; SERVER: 192.168.56.14#53(192.168.56.14)
;; WHEN: Fri Jul  8 20:45:24 2016
;; MSG SIZE  rcvd: 62

```    
