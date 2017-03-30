---
layout: post
title: HAProxy 入门
description: "HAProxy 入门"
category: LB
avatarimg:
tags: [Web, LB, HAProxy, Nginx]
duoshuo: true
---

# 引言

为什么要使用 HAProxy？因为有一些功能 Nginx 实现不了，而 HAProxy 可以。   
Nginx 和 HAProxy 对比有下面的不足：

1. 默认不支持自定义 URL 检测（第三方模块可以）
2. 会话保持默认只有 ip_hash（没有 URL Hash 算法）
3. 负载均衡算法少(rr, wrr, lc, ip_hash)  

HAProxy 支持如下负载均衡算法：
`rr/wrr/lc/wlc/sh/uri/hdr(Based on HTTP header)/first` 等

<pre>

no less than 9 load balancing algorithms are supported, 
some of which apply to input data to offer an infinite list of possibilities. 
The most common ones are round-robin (for short connections, pick each server in turn),
leastconn (for long connections, pick the least recently used of the servers with the lowest connection count),
source (for SSL farms or terminal server farms, the server directly depends on the client's source address), 
uri (for HTTP caches, the server directly depends on the HTTP URI), 
hdr (the server directly depends on the contents of a specific HTTP header field), 
first (for short-lived virtual machines, all connections are packed on the smallest possible subset of servers 
so that unused ones can be powered down)

</pre>

HAProxy 支持不少于 9 种的负载均衡算法。  
最常见的算法有：

* rr 轮询算法（用于短连接，轮流选取每台服务器） 
* lc 最少连接数算法（用于长连接，选择含有最少连接数的最近最少使用的服务器） 
* source 源地址算法（用于 SSL 集群或者终端服务器集群，直接依据客户端的源 IP 地址来选择对应服务器）  
* uri 算法（用于 HTTP 缓存，直接依据 HTTP URI 地址来选择对应服务器）
* hdr 算法（直接依据指定的 HTTP heder 内容来选择对应服务器）  
* first 算法（用于短生命周期的虚拟机，所有的连接集合到一个最小的服务器子网，没使用的服务器因此可以关机）  


现在的缓存集群架构有的会在前端配置使用 Nginx 作为负载均衡器：

* Nginx + Squid
* Nginx + Varnish
* Nginx + ATS

`
因为 HAProxy 中文资料较少，所以国内的 HAProxy 并没有像 Nginx 那样使用普遍。
`

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


`一般不推荐在 LB 上记录访问日志。`

## HAProxy 状态页面的配置

详细看下面的配置文件内容。

下面我们自己重新配置一下`/etc/haproxy/haproxy.cfg`，内容如下：

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


`对比 Nginx，只有 Nginx Plus（Nginx 企业版）才有类似 HAProxy 的 Web 状态页面的 Dashboard`

# HAProxy 在线维护

## 在线增加、删除节点

配置文件`/etc/haproxy/haproxy.cfg` 中的 stat socket 修改如下：  
`stats socket /var/lib/haproxy/haproxy.sock mode 600 level admin`  
然后重启 HAProxy `systemctl restart haproxy`  

```bash

# 需要安装 socat 传递信息给 socket 
[root@linux-node1 ~]# yum install socat -y

# 查看 help
[root@linux-node1 ~]# echo "help" | socat stdio /var/lib/haproxy/haproxy.sock 
Unknown command. Please enter one of the following commands only :
  clear counters : clear max statistics counters (add 'all' for all counters)
  clear table    : remove an entry from a table
  help           : this message
  prompt         : toggle interactive mode with prompt
  quit           : disconnect
  show info      : report information about the running process
  show pools     : report information about the memory pools usage
  show stat      : report counters for each proxy and server
  show errors    : report last request and response errors for each proxy
  show sess [id] : report the list of current sessions or dump this session
  show table [id]: report table usage stats or dump this table's contents
  get weight     : report a server's current weight
  set weight     : change a server's weight
  set server     : change a server's state or weight
  set table [id] : update or create a table entry's data
  set timeout    : change a timeout setting
  set maxconn    : change a maxconn setting
  set rate-limit : change a rate limiting value
  disable        : put a server or frontend in maintenance mode
  enable         : re-enable a server or frontend which is in maintenance mode
  shutdown       : kill a session or a frontend (eg:to release listening ports)
  show acl [id]  : report avalaible acls or dump an acl's contents
  get acl        : reports the patterns matching a sample for an ACL
  add acl        : add acl entry
  del acl        : delete acl entry
  clear acl <id> : clear the content of this acl
  show map [id]  : report avalaible maps or dump a map's contents
  get map        : reports the keys and values matching a sample for a map
  set map        : modify map entry
  add map        : add map entry
  del map        : delete map entry
  clear map <id> : clear the content of this map
  set ssl <stmt> : set statement for ssl

# 查看 HAProxy 信息及状态
[root@linux-node1 ~]# echo "show info;show stat" | socat stdio /var/lib/haproxy/haproxy.sock
Name: HAProxy
Version: 1.5.14
Release_date: 2015/07/02
Nbproc: 1
Process_num: 1
Pid: 13110
Uptime: 0d 0h02m57s
Uptime_sec: 177
Memmax_MB: 0
Ulimit-n: 8033
Maxsock: 8033
Maxconn: 4000
Hard_maxconn: 4000
CurrConns: 0
CumConns: 2
CumReq: 2
MaxSslConns: 0
CurrSslConns: 0
CumSslConns: 0
Maxpipes: 0
PipesUsed: 0
PipesFree: 0
ConnRate: 0
ConnRateLimit: 0
MaxConnRate: 0
SessRate: 0
SessRateLimit: 0
MaxSessRate: 0
SslRate: 0
SslRateLimit: 0
MaxSslRate: 0
SslFrontendKeyRate: 0
SslFrontendMaxKeyRate: 0
SslFrontendSessionReuse_pct: 0
SslBackendKeyRate: 0
SslBackendMaxKeyRate: 0
SslCacheLookups: 0
SslCacheMisses: 0
CompressBpsIn: 0
CompressBpsOut: 0
CompressBpsRateLim: 0
ZlibMemUsage: 0
MaxZlibMemUsage: 0
Tasks: 7
Run_queue: 1
Idle_pct: 100
node: linux-node1
description: 

# pxname,svname,qcur,qmax,scur,smax,slim,stot,bin,bout,dreq,dresp,ereq,econ,eresp,wretr,wredis,status,weight,act,bck,chkfail,chkdown,lastchg,downtime,qlimit,pid,iid,sid,throttle,lbtot,tracked,type,rate,rate_lim,rate_max,check_status,check_code,check_duration,hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,hanafail,req_rate,req_rate_max,req_tot,cli_abrt,srv_abrt,comp_in,comp_out,comp_byp,comp_rsp,lastsess,last_chk,last_agt,qtime,ctime,rtime,ttime,
stats,FRONTEND,,,0,0,3000,0,0,0,0,0,0,,,,,OPEN,,,,,,,,,1,2,0,,,,0,0,0,0,,,,0,0,0,0,0,0,,0,0,0,,,0,0,0,0,,,,,,,,
stats,BACKEND,0,0,0,0,300,0,0,0,0,0,,0,0,0,0,UP,0,0,0,,0,177,0,,1,2,0,,0,,1,0,,0,,,,0,0,0,0,0,0,,,,,0,0,0,0,0,0,-1,,,0,0,0,0,
frontend_www_example_com,FRONTEND,,,0,0,3000,0,0,0,0,0,0,,,,,OPEN,,,,,,,,,1,3,0,,,,0,0,0,0,,,,0,0,0,0,0,0,,0,0,0,,,0,0,0,0,,,,,,,,
backend_www_example_com,web-node1,0,0,0,0,,0,0,0,,0,,0,0,0,0,UP,1,1,0,0,0,177,0,,1,4,1,,0,,2,0,,0,L7OK,200,0,0,0,0,0,0,0,0,,,,0,0,,,,,-1,OK,,0,0,0,0,
backend_www_example_com,BACKEND,0,0,0,0,300,0,0,0,0,0,,0,0,0,0,UP,1,1,0,,0,177,0,,1,4,0,,0,,1,0,,0,,,,0,0,0,0,0,0,,,,,0,0,0,0,0,0,-1,,,0,0,0,0,

# 禁用一个节集群中的节点，常用于对节点进行维护操作
[root@linux-node1 ~]# echo "disable server backend_www_example_com/web-node1" | socat stdio /var/lib/haproxy/haproxy.sock 

Message from syslogd@localhost at Dec  1 14:33:26 ...
 haproxy[13110]: backend backend_www_example_com has no server available!

# 启用一个集群中的节点
[root@linux-node1 ~]# echo "enable server backend_www_example_com/web-node1" | socat stdio /var/lib/haproxy/haproxy.sock 
 
```    


# Ref
[Using nginx as HTTP load balancer](http://nginx.org/en/docs/http/load_balancing.html)  
[Basic features : Load balancing](http://cbonte.github.io/haproxy-dconv/1.6/intro.html#3.3.5)  
[Centos7 HAProxy 日志配置](http://www.javacoder.cn/?p=840)  
[Centos 下 HAProxy 日志的配置](http://leboit.blog.51cto.com/1465210/1695516)  

