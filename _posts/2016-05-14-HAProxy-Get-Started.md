---
layout: post
title: HAProxy 入门
description: "HAProxy 入门"
category: Web
avatarimg:
tags: [LB, HAProxy, Nginx]
duoshuo: true
---

# 引言

为什么要使用 HAProxy？因为一般有些功能 Nginx 实现不了，而 HAProxy 可以。   
Nginx 和 HAProxy 对比有下面的不足：

1. 默认不支持自定义 URL 检测（第三方模块可以）
2. 会话保持默认只有 ip_hash（没有 URL Hash 算法）
3. 负载均衡算法少(rr,wrr,lc,ip_hash)  

HAProxy 支持如下负载均衡算法:  
rr/wrr/lc/wlc/sh/uri/hdr(Based on HTTP header)/first 等

<pre>
no less than 9 load balancing algorithms are supported, some of which apply
to input data to offer an infinite list of possibilities. The most common
ones are round-robin (for short connections, pick each server in turn),
leastconn (for long connections, pick the least recently used of the servers
with the lowest connection count), source (for SSL farms or terminal server
farms, the server directly depends on the client's source address), uri (for
HTTP caches, the server directly depends on the HTTP URI), hdr (the server
directly depends on the contents of a specific HTTP header field), first
(for short-lived virtual machines, all connections are packed on the
smallest possible subset of servers so that unused ones can be powered
down);
</pre>


现在的缓存集群架构有的会在前端配置使用 Nginx 作为负载均衡器：

* Nginx + Squid
* Nginx + Varnish
* Nginx + ATS

>  
因为HAProxy 中文资料较少，所以国内的 HAProxy 并没有像 Nginx 那样使用普遍。

# HAProxy 安装

HAProxy、Nginx 一般推荐使用最新稳定版本（一般需要编译安装）。

本文为了演示方便，使用 yum 安装方式。  
`yum install haproxy -y`

# HAProxy 配置文件

HAProxy 配置文件为 `/etc/haproxy/haproxy.cfg`，默认里面有比较详细的注释。
主要下面几个配置段：  

* global(Global settings，进程全局级别参数)
* defaults(一些常用默认值，如果在 listen 和 backend 配置段没有特别指定的话)
* fronted (前端配置段)
* backend (后端配置段)

## 配置 HAProxy 日志记录到文件
参考 Ref 中的资料，CentOS 7 下 rsyslog 配置，配置文件中注释没有说


>
一般不推荐在 LB 上记录访问日志。

## HAProxy 状态页面的配置

详细看下面的配置文件内容。

下面我们自己重新配置一下 /etc/haproxy/haproxy.cfg，内容如下：

```bash
#---------------------------------------------------------------------
# Example configuration for a possible web application.  See the
# full configuration options online.
#
#   http://haproxy.1wt.eu/download/1.4/doc/configuration.txt
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Global settings
#---------------------------------------------------------------------
global
    # to have these messages end up in /var/log/haproxy.log you will
    # need to:
    #
    # 1) configure syslog to accept network log events.  This is done
    #    by adding the '-r' option to the SYSLOGD_OPTIONS in
    #    /etc/sysconfig/syslog
    #
    # 2) configure local2 events to go to the /var/log/haproxy.log
    #   file. A line like the following can be added to
    #   /etc/sysconfig/syslog
    #
    #    local2.*                       /var/log/haproxy.log
    #
    log         127.0.0.1 local2

    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

# 此处增加 HAProxy 状态页面的配置
listen stats
    mode http
    bind 0.0.0.0:8888
    stats enable
    stats uri     /haproxy-status 
    stats auth    haproxy:saltstack

frontend frontend_www_example_com
    bind 192.168.56.11:80
    mode http
    option httplog
    log global
    default_backend backend_www_example_com

backend backend_www_example_com
    option forwardfor header X-REAL-IP
    option httpchk HEAD / HTTP/1.0
    balance source			# 此处表示使用源 IP HASH 负载均衡算法，用于会话保持
    server web-node1  192.168.56.11:8080 check inter 2000 rise 30 fall 15
	# 上面这段配置后端服务器及相关检查，表示每 2 秒检查一次，如果连续失败了 15 次（也就是 30s），
	# 就把这台服务器移除集群，如果连续成功了 30 次（也就是 60s），就把这台服务器加入集群，一般加入集群检查时间要长些
	# 具体检查次数及时间根据实际需求配置
```    

然后启动 HAProxy `systemctl start haproxy`，启动成功后，便可以通过以下 URL 访问 HAProxy Web 状态页面：  
http://192.168.56.11:8888/haproxy-status  

![HAProxy-Status](http://jaminzhang.github.io/images/HAProxy/HAProxy-Status.png)


>
对比 Nginx，只有 Nginx Plus（Nginx 企业版）才有类似 HAProxy Web 状态页面的 Dashboard


# Ref
[Using nginx as HTTP load balancer](http://nginx.org/en/docs/http/load_balancing.html)  
[Basic features : Load balancing](http://cbonte.github.io/haproxy-dconv/1.6/intro.html#3.3.5)  
[Centos7 Haproxy 日志配置](http://www.javacoder.cn/?p=840)  
[centos下haproxy日志的配置](http://leboit.blog.51cto.com/1465210/1695516)  

