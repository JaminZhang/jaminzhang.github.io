---
layout: post
title: SaltStack API 配置使用
description: "SaltStack API 配置使用"
category: SaltStack
avatarimg:
tags: [SaltStack, API, RESTful]
duoshuo: true
---

# 通过 RESTful API 调用 SaltStack

当我们需要在其他机器或者通过第三方调用 SaltStack 时，通过 SaltStack Python API 可能就不是那么方便了，这个时候我们可以使用 SaltStack 提供的基于 RESTful 风格的 HTTP 的 API。这里需要注意的是 SaltStack 的 API 模块并不是 SaltStack 内置的，而是另外一个独立的模块，需要单独安装并部署。

# RESTful API 配置环境部署

SaltStack 的 API 是在 Master 和 Minion 之外的一个独立的服务，所以需要独立部署，API 服务需要部署在 Master 服务器上。

## 1 部署 Salt-API 服务

```bash
# 环境准备，建议对 salt-api 使用 HTTPS，生成签名证书，这里我们通过 salt 的模块生成
[root@linux-node1 ~]# yum install gcc make python-devel libffi-devel -y
[root@linux-node1 ~]# pip install PyOpenSSL

# 生成证书
[root@linux-node1 ~]# salt-call tls.create_self_signed_cert
local:
    Created Private Key: "/etc/pki/tls/certs/localhost.key." Created Certificate: "/etc/pki/tls/certs/localhost.crt."

# 安装 CherryPy
pip install --upgrade pip
pip install CherryPy==3.2.6 (yum install python-cherrypy)

# 安装 salt-api
yum install salt-api -y

```    

## 2 配置用户及权限

```bash
vim /etc/salt/master.d/eauth.conf
external_auth:
  pam:
    saltapi:
      - .*
      - '@wheel'
      - '@runner'

# 添加用户
useradd -M -s /sbin/nologin saltapi
echo "saltapi" | passwd saltapi --stdin
```    

## 3 配置 salt-api 服务

```bash
vim /etc/salt/master.d/api.conf
rest_cherrypy:
  host: 192.168.56.11
  port: 8000
  ssl_crt: /etc/pki/tls/certs/localhost.crt
  ssl_key: /etc/pki/tls/certs/localhost.key
```    

## 4 启动服务

```bash
systemctl restart salt-master
systemctl start salt-api
netstat -lnpt | grep 8000
```    

## 5 测试

使用 curl 模仿一个请求，来测试 API 服务是否正常。

```bash
[root@linux-node1 salt]# curl -k https://192.168.56.11:8000/login \
> -H 'Accept: application/x-yaml' \
> -d username='saltapi' \
> -d password='saltapi' \
> -d eauth='pam'
return:
- eauth: pam
  expire: 1470176855.47513
  perms:
  - .*
  - '@wheel'
  - '@runner'
  start: 1470133655.475129
  token: 2b98c3ad28cc52d31c1d7b38a4ffe67814b9afdf		# 认证成功后获得的令牌
  user: saltapi

  
curl -k https://192.168.56.11:8000/minions/ \
-H 'Accept: application/x-yaml' \
-H 'X-Auth-Token: 2b98c3ad28cc52d31c1d7b38a4ffe67814b9afdf'
return:
- linux-node1.example.com:
    SSDs: []
    biosreleasedate: 07/02/2015
    biosversion: '6.00'
    cloud: openstack
... 省略很多行 ...
    username: root
    uuid: 564dcbfc-e24a-a02d-f0f2-7698d8bfc016
    virtual: VMWare
    zmqversion: 4.0.5  
```    

上面各项测试正常。
  
# 通过 RESTful API 实现日常操作

## 1 运行远程模块

```bash
curl -sk https://192.168.56.11:8000/ \
-H 'Accept: application/json' \			# 返回信息格式，默认 json，也推荐 json (兼容性强)
-H 'X-Auth-Token: 2b98c3ad28cc52d31c1d7b38a4ffe67814b9afdf' \		# 通过用户名密码获取的令牌
-d client='local' \		# 调用底层 salt 模块
-d tgt='*' \
-d fun='test.ping' \ 	# 执行函数
| python -mjson.tool	# json 格式化输出


# 以上命令无注释整理如下：
curl -sk https://192.168.56.11:8000/ \
-H 'Accept: application/json' \
-H 'X-Auth-Token: 2b98c3ad28cc52d31c1d7b38a4ffe67814b9afdf' \
-d client='local' \
-d tgt='*' \
-d fun='test.ping' \
| python -mjson.tool
{
    "return": [
        {
            "linux-node1.example.com": true,
            "linux-node2.example.com": true
        }
    ]
}
```    

## 2 查询指定 job

我们一般在其他地方调用  salt-api 或者通过第三方调用时，很少会直接同步等待 salt 的返回；  
一般情况下我们会使用 salt 的异步模块来执行命令获取一个返回的 jid,然后通过这个 jid 来获取任务的详细信息。

```bash    
# 获取任务列表如下：
curl -sk https://192.168.56.11:8000/jobs \
-H 'X-Auth-Token: 2b98c3ad28cc52d31c1d7b38a4ffe67814b9afdf' \
| python -mjson.tool
{
    "return": [
        {
            "20160801185947525506": {
                "Arguments": [],
                "Function": "test.ping",
                "StartTime": "2016, Aug 01 18:59:47.525506",
                "Target": "*",
                "Target-type": "glob",
                "User": "root"
            },
            "20160801185952596386": {
                "Arguments": [
                    "20160801185947525506"
                ],
                "Function": "saltutil.find_job",
                "StartTime": "2016, Aug 01 18:59:52.596386",
                "Target": "*",
                "Target-type": "glob",
                "User": "root"
... 省略很多行 ...
            "20160802184323260003": {
                "Arguments": [],
                "Function": "test.ping",
                "StartTime": "2016, Aug 02 18:43:23.260003",
                "Target": "*",
                "Target-type": "glob",
                "User": "saltapi"
            }
        }
    ]
}

# 获取 jid 后，即可获取到该任务的详细情况，如下：
curl -sk https://192.168.56.11:8000/jobs/20160802184323260003 \
-H 'X-Auth-Token: 2b98c3ad28cc52d31c1d7b38a4ffe67814b9afdf' \
| python -mjson.tool
{
    "info": [
        {
            "Arguments": [],
            "Function": "test.ping",
            "Minions": [
                "linux-node1.example.com",
                "linux-node2.example.com"
            ],
            "Result": {
                "linux-node1.example.com": {
                    "return": true
                },
                "linux-node2.example.com": {
                    "return": true
                }
            },
            "StartTime": "2016, Aug 02 18:43:23.260003",
            "Target": "*",
            "Target-type": "glob",
            "User": "saltapi",
            "jid": "20160802184323260003"
        }
    ],
    "return": [
        {
            "linux-node1.example.com": true,
            "linux-node2.example.com": true
        }
    ]
}

```    


## 3 运行 Runner

```bash
curl -sk https://192.168.56.11:8000/ \
-H 'X-Auth-Token: 2b98c3ad28cc52d31c1d7b38a4ffe67814b9afdf' \
-d client="runner" \
-d fun="manage.status" \
| python -mjson.tool
{
    "return": [
        {
            "down": [],
            "up": [
                "linux-node1.example.com",
                "linux-node2.example.com"
            ]
        }
    ]
}

```    


调用其他模块时，只需要将 client 的参数换成对应的参数即可。

# 开源 SaltStack Dashboard

[saltshaker](https://github.com/yueyongyue/saltshaker)  
[OMS运维管理平台](https://github.com/binbin91/oms)  
  
# 遇到的问题

curl 测试时提示：
401 Unauthorized  
Could not authenticate using provided credentials  

先检查了 eauth.conf 配置文件及语法，确认没有错误，然后发现漏掉了创建 saltapi 用户和设置其密码

# Ref
[REST_CHERRYPY](https://docs.saltstack.com/en/latest/ref/netapi/all/salt.netapi.rest_cherrypy.html)  
[配置管理(3) salt-api安装、配置、使用](https://www.xiaomastack.com/2014/11/18/salt-api/)  



