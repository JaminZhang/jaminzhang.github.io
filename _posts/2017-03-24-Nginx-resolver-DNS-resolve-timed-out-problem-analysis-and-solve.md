---
layout: post
title: Nginx resolver DNS 解析超时问题分析及解决
description: "Nginx resolver DNS 解析超时问题分析及解决"
category: Nginx
avatarimg:
tags: [Nginx, resolver, DNS]
duoshuo: true
---



Nginx resolver DNS 解析超时问题分析及解决

# 引言

今天一运维同事反映在云游戏平台操作合服时失败，查看任务日志，提示没有合服脚本。  
下面记录下问题原因分析及解决过程。  


# 问题原因分析及解决过程

1.没有合服脚本，是没有从对应服务器上下载下来，查看任务日志和下载服务器的日志，提示 HTTP 403 错误。

```bash

# Nginx Access Log 日志：

42.51.xx.xx [24/Mar/2017:11:13:20 +0800] "GET /opgame/zmsg/merge/zmsg_merge_tool.sh HTTP/1.0" 403 162 "-" "Wget/1.12 (linux-gnu)" "-" 54.459
42.51.xx.xx [24/Mar/2017:11:16:28 +0800] "GET /opgame/zmsg/merge/zmsg_merge_tool.sh HTTP/1.0" 403 162 "-" "Wget/1.12 (linux-gnu)" "-" 60.008


# Nginx Error Log 日志：

2017/03/24 11:13:20 [error] 31708#0: *237 cmdb.xxxx.cn could not be resolved (110: Operation timed out), client: 42.51.xx.xx, server: duang.xxxx.cc, request: "GET /opgame/zmsg/merge/zmsg_merge_tool.sh HTTP/1.0", subrequest: "/mcode", host: "duang.xxxx.cc:59808"
2017/03/24 11:15:58 [error] 31708#0: *238 cmdb.xxxx.cn could not be resolved (110: Operation timed out), client: 42.51.xx.xx, server: duang.xxxx.cc, request: "GET /opgame/zmsg/merge/zmsg_merge_tool.sh HTTP/1.0", host: "duang.xxxx.cc:59808"
2017/03/24 11:16:28 [error] 31708#0: *238 cmdb.xxxx.cn could not be resolved (110: Operation timed out), client: 42.51.xx.xx, server: duang.xxxx.cc, request: "GET /opgame/zmsg/merge/zmsg_merge_tool.sh HTTP/1.0", subrequest: "/mcode", host: "duang.xxxx.cc:59808"

```    

2.根据 Nginx Error Log 日志判断 Nginx DNS 解析 cmdb.xxxx.cn 超时

我当时第一反应是：既然是超时，先尝试调大超时时间看下。Nginx DNS 解析超时参数为 resolver_timeout。

```bash

Syntax:	resolver_timeout time;
Default:	resolver_timeout 30s;
Context:	http, server, location
Sets a timeout for name resolution, for example:
resolver_timeout 5s;

```    

但在这里我先有个疑问：默认的 30s 不够长吗？  
于是使用 ping 命令测试 cmdb.xxxx.cn 的解析，返回解析 IP 所花时间只有 10 多秒，Nginx 的 DNS 解析应该不会超时啊？  
这时暂时有疑问，继续上面调大 resolver_timeout 到 60s。  
重新加载 Nginx，重新下载测试，还是报 `cmdb.xxxx.cn could not be resolved (110: Operation timed out)` 错误。
那这样应该不是 DNS 超时时间的设置问题？其实一开始我就想更换一下 DNS 服务器看下。

3.更换 Nginx resolver DNS 服务器

Nginx 默认配置的 resolver DNS 服务器是 223.5.5.5，阿里的公共 DNS 服务器。如下：

```bash

        location = /token {
            resolver 223.5.5.5;
            internal; proxy_pass http://cmdb.xxxx.cn:8334/token/$arg_query;
        }                                    
                                             
        location = /mcode {                  
            resolver 223.5.5.5;              
            internal; proxy_pass http://cmdb.xxxx.cn:8334/mcode/$arg_query;
        }

```    

更换 Nginx resolver DNS 服务器为 114.114.114.114，重新加载 Nginx，重新下载测试，下载竟然正常了！
说明就是这台服务器到 233.5.5.5 DNS 端口的连接有问题。下面用 telnet 验证如下。

```bash

[root@htuidc ~]# telnet 223.5.5.5 53
Trying 223.5.5.5...
telnet: connect to address 223.5.5.5: Connection timed out
[root@htuidc ~]# telnet 114.114.114.114 53
Trying 114.114.114.114...
Connected to 114.114.114.114.
Escape character is '^]'.

```    

其实上面这步验证应该在报 `cmdb.xxxx.cn could not be resolved (110: Operation timed out)` 错误时就应该去做的。
而不是直接调整 Nginx 的 resolver_timeout。

# Ref
[ngx_http_core_module.html#resolver](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver)  
[Nginx 的 DNS 解析过程分析](http://theantway.com/2013/09/understanding_the_dns_resolving_in_nginx/)  




