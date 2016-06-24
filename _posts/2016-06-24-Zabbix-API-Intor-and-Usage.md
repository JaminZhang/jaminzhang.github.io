---
layout: post
title: Zabbix API 简介及使用
description: "Zabbix API 简介及使用"
category: Monitoring
avatarimg: 
tags: [Zabbix, API]
duoshuo: true
---

# Zabbix API 简介

<pre>
Zabbix API开始扮演着越来越重要的角色，尤其是在集成第三方软件和自动化日常任务时。
很难想象管理数千台服务器而没有自动化是多么的困难。
Zabbix API为批量操作、第三方软件集成以及其他作用提供可编程接口。

Zabbix API是在1.8版本中开始引进并且已经被广泛应用。所有的Zabbix移动客户端都是基于API，
甚至原生的WEB前端部分也是建立在它之上。
Zabbix API 中间件使得架构更加模块化也避免直接对数据库进行操作。
它允许你通过JSON RPC协议来创建、更新和获取Zabbix对象并且做任何你喜欢的操作【当然前提是你拥有认证账户】。

Zabbix API提供两项主要功能：

远程管理Zabbix配置
远程检索配置和历史数据

使用JSON
API 采用JSON-RPC实现。这意味着调用任何函数，都需要发送POST请求，输入输出数据都是以JSON格式。

</pre>

# Zabbix API的使用流程

## 使用 API 的基本步骤 

1. 连接 http://x.x.x.x/api_jsonrpc.php 提供用户名和密码，并标识 HTTP 头部 
Content-Type:application/json，HTTP 方法为 POST。
2. 获取 SESSIONID
3. 通过 SESSIONID 建立后续的连接
4. 提交 POST 数据，格式为 JSON，其中放对应的方法，获取需要的数据。

## 用 curl 模拟 API 的使用

```bash
# 1 获取 SESSIONID

[root@linux-node1 ~]# curl -s -X POST -H 'Content-Type:application/json' -d '
> {
>     "jsonrpc": "2.0",
>     "method": "user.login",
>     "params": {
>         "user": "Admin",
>         "password": "zabbix"
>     },
>     "id": 1
> }' http://192.168.56.11/zabbix/api_jsonrpc.php | python -m json.tool
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": "6a0d235908c25a495f0d356157fbb3d3"
}
 

# 2 用获取的 SESSIONID 去调用 API 的 host.get 方法请求 hostid

[root@linux-node1 ~]# curl -s -X POST -H 'Content-Type:application/json' -d '
> {
>     "jsonrpc": "2.0",
>     "method": "host.get",
>     "params": {
>         "output": ["hostid"]
>     },
>     "auth": "6a0d235908c25a495f0d356157fbb3d3",
>     "id": 1
> }' http://192.168.56.11/zabbix/api_jsonrpc.php | python -m json.tool
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": [
        {
            "hostid": "10084"
        },
        {
            "hostid": "10120"
        }
    ]
}

```    

可以通过 API 来添加和删除 Host，这里就不举例了，具体方法参考官网文档。  
在实际的 API 开发应用中，我们可以采用 Python 等其他编程语言中来实现。
如下，就是用 Python 写的用于认证获取 SESSIONID 的代码例子：

```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-

import requests
import json

url = 'http://192.168.56.11/zabbix/api_jsonrpc.php'
post_data = {
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password": "zabbix"
    },
    "id": 1
}
post_header = {'Content-Type': 'application/json'}

ret = requests.post(url, data=json.dumps(post_data), headers=post_header)

zabbix_ret = json.loads(ret.text)
if not zabbix_ret.has_key('result'):
    print 'login error'
else:
    print zabbix_ret.get('result')
```

执行脚本时，注意要安装 Python requests 模块。

```bash
[root@linux-node1 ~]# python  zabbix_auth.py
Traceback (most recent call last):
  File "zabbix_auth.py", line 4, in <module>
    import requests
ImportError: No module named requests

[root@linux-node1 ~]# yum install python-pip -y
[root@linux-node1 ~]# pip install requests

[root@linux-node1 ~]# python zabbix_auth.py 
f2453c4cc730d5158a87e0754940138e
```    

# Ref
[Zabbix API](https://www.zabbix.com/documentation/3.0/manual/api)  
[zabbix API二次开发使用与介绍](http://www.ttlsa.com/zabbix/zabbix-dev-api/)  
[Zabbix--API简介](http://kaibinyuan.blog.51cto.com/7304008/1632968)  
[ZABBIX API简介及使用](http://paperplane.ruhoh.com/zabbix/intro-to-zabbix-api/)  

