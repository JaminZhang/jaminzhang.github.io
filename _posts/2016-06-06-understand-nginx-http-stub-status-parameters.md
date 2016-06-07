---
layout: post
title: 理解 nginx http_stub_status 相关参数
description: "理解 nginx http_stub_status 相关参数"
category: Nginx
avatarimg:
tags: [Nginx, HTTP]
duoshuo: true
---

# 引言
前一篇运维监控体系笔记中谈到了应用服务的监控，拿 nginx 举例，其中提到的 nginx status 相关参数，需要重新学习确认下。  

# ngx_http_stub_status_module 简介
> 
The ngx_http_stub_status_module module provides access to basic status information.  
This module is not built by default, it should be enabled with the --with-http_stub_status_module configuration parameter.

# 模块提供的状态信息说明

```bash
Active connections
  The current number of active client connections including Waiting connections.
accepts
  The total number of accepted client connections.
handled
  The total number of handled connections. Generally, the parameter value is the same as accepts unless some resource limits have been reached (for example, the worker_connections limit).
requests
  The total number of client requests.
Reading
  The current number of connections where nginx is reading the request header.
Writing
  The current number of connections where nginx is writing the response back to the client.
Waiting
  The current number of idle client connections waiting for a request.
```    

```bash
Active connections – Number of all open connections. This doesn’t mean number of users. A single user, for a single pageview can open many concurrent connections to your server.
Server accepts handled requests – This shows three values.
First is total accepted connections.
Second is total handled connections. Usually first 2 values are same.
Third value is number of and handles requests. This is usually greater than second value.
Dividing third-value by second-one will give you number of requests per connection handled by Nginx. In above example, 10993/7368, 1.49 requests per connections.
Reading – nginx reads request header
Writing – nginx reads request body, processes request, or writes response to a client
Waiting – keep-alive connections, actually it is active – (reading + writing).This value depends on keepalive-timeout. 
Do not confuse non-zero waiting value for poor performance. It can be ignored. Although, you can force zero waiting by setting keepalive_timeout 0;
```    

# Ref
[Module ngx_http_stub_status_module](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html)　 
[Enable Nginx Status Page](https://easyengine.io/tutorials/nginx/status-page/)  

