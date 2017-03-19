---
layout: post
title: Docker Registry 构建私有镜像仓库
description: "Docker Registry 构建私有镜像仓库"
category: Docker
avatarimg:
tags: [Docker, Registry]
duoshuo: true
---


Docker Registry 构建私有镜像仓库

# Docker Registry 简介

Docker Registry 是官方提供的工具，可以用于构建私有的镜像仓库。  
私有镜像仓库的好处有很多，官方列举了如下几点：

* tightly control where your images are being stored 
* fully own your images distribution pipeline
* integrate image storage and distribution tightly into your in-house development workflow


我将在 docker registry 前端配置 Nginx 代理（提供 SSL、基本认证支持）。  

# 1 申请免费的 SSL 证书并配置 Nginx SSL 和基本认证

## 1.1 申请免费的 SSL 证书

在沃通官网申请免费 SSL 证书  
[申请地址](https://buy.wosign.com/free/)  

## 1.2 配置 Nginx SSL 

参考沃通[官网文档](http://www.wosign.com/Docdownload/Nginx%20SSL%E8%AF%81%E4%B9%A6%E9%83%A8%E7%BD%B2%E6%8C%87%E5%8D%97.pdf)部署 Nginx SSL 证书  

```bash

# 将 SSL 证书放置在 /etc/nginx/ssl/ 下
[root@linux-node1 ~]# ll /etc/nginx/ssl/
total 12
-rw-r--r-- 1 root root 6664 Sep 21 18:41 domain.crt
-rw-r--r-- 1 root root 1674 Sep 21 18:41 domain.key

```    

## 1.3 生成基本认证用户名密码文件

```bash

[root@linux-node1 ~]# yum install httpd-tools -y
[root@linux-node1 ~]# htpasswd -c /etc/nginx/conf.d/nginx.htpasswd admin
New password: # 密码为 admin
Re-type new password: 
Adding password for user admin
[root@linux-node1 ~]# cat /etc/nginx/conf.d/nginx.htpasswd
admin:$apr1$i0szKFN2$0aiDnahUbl7EA4HK7wxwz.

```    

## 1.4 添加 Nginx 配置文件

添加如下的 nginx 配置文件（根据上面的相关配置指定好 SSL 证书/基本认证） ：

```bash

[root@linux-node1 ~]# cat /etc/nginx/conf.d/registry.jaminzhang.me.conf 
server {
  listen 443 ssl;
  server_name registry.jaminzhang.me;

  # SSL
  ssl_certificate "/etc/nginx/ssl/domain.crt";			# 指定 SSL 证书
  ssl_certificate_key "/etc/nginx/ssl/domain.key";		# 指定 SSL 证书私钥

  # Recommendations from https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
  ssl_session_timeout 5m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers AESGCM:ALL:!DH:!EXPORT:!RC4:+HIGH:!MEDIUM:!LOW:!aNull:!eNULL;
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;

  # disable any limits to avoid HTTP 413 for large image uploads
  client_max_body_size 0;

  # required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
  chunked_transfer_encoding on;

  
  location /v2/ {
    #root        /usr/share/nginx/html;
    #index       index.html;
    # Do not allow connections from docker 1.5 and earlier
    # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
    if ($http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*\$" ) {
      return 404;
    }

    # To add basic authentication to v2 use auth_basic setting.
    auth_basic "Registry realm";
    auth_basic_user_file /etc/nginx/conf.d/nginx.htpasswd;

    ## If $docker_distribution_api_version is empty, the header will not be added.
    ## See the map directive above where this variable is defined.
    add_header 'Docker-Distribution-Api-Version' 'registry/2.0' always;		# 此处需要配置，不然会出现后面会说到的问题

    proxy_pass                          http://127.0.0.1:5000;				# nginx 将收到的请求转发给本机的 Registry 容器
    proxy_set_header  Host              $http_host;   # required for docker client's sake
    proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
    proxy_read_timeout                  900;
  }
}

```    


# 2 安装运行 Docker Registry

```bash

# 运行 docker registry 容器，镜像存储目录为 /opt/data/registry
[root@linux-node1 ~]# docker run -d --name registry \
-p 5000:5000 \
-v /opt/data/registry:/var/lib/registry \
registry:2
bdd0ef575a65397351cbb4034f18042b80de47916bf24806f48a0126c633ce3a
[root@linux-node1 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
bdd0ef575a65        registry:2          "/entrypoint.sh /etc/"   11 seconds ago      Up 11 seconds       0.0.0.0:5000->5000/tcp   registry
```    

# 3 测试验证 Docker Registry 

# 3.1 连通性验证

```bash

[root@linux-node1 ~]# curl -i -k -v https://admin:admin@registry.jaminzhang.me/v2/
* About to connect() to registry.jaminzhang.me port 443 (#0)			# 如果域名没在公网解析，需要在 /etc/hosts 中添加解析
*   Trying 192.168.56.11...
* Connected to registry.jaminzhang.me (192.168.56.11) port 443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
* skipping SSL peer certificate verification
* SSL connection using TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
* Server certificate:
* 	subject: CN=registry.jaminzhang.me,C=CN
* 	start date: Sep 21 10:08:39 2016 GMT
* 	expire date: Sep 21 10:08:39 2019 GMT
* 	common name: registry.jaminzhang.me
* 	issuer: CN=CA 沃通免费SSL证书 G2,O=WoSign CA Limited,C=CN
* Server auth using Basic with user 'admin'
> GET /v2/ HTTP/1.1
> Authorization: Basic YWRtaW46YWRtaW4=
> User-Agent: curl/7.29.0
> Host: registry.jaminzhang.me
> Accept: */*
> 
< HTTP/1.1 200 OK
HTTP/1.1 200 OK
< Server: nginx/1.10.1
Server: nginx/1.10.1
< Date: Fri, 30 Sep 2016 10:39:05 GMT
Date: Fri, 30 Sep 2016 10:39:05 GMT
< Content-Type: application/json; charset=utf-8
Content-Type: application/json; charset=utf-8
< Content-Length: 2
Content-Length: 2
< Connection: keep-alive
Connection: keep-alive
< Docker-Distribution-Api-Version: registry/2.0
Docker-Distribution-Api-Version: registry/2.0
< X-Content-Type-Options: nosniff
X-Content-Type-Options: nosniff
< Docker-Distribution-Api-Version: registry/2.0
Docker-Distribution-Api-Version: registry/2.0

< 
* Connection #0 to host registry.jaminzhang.me left intact

```    

## 3.2 身份验证

```bash

[root@linux-node1 ~]# docker login -u admin -p admin -e "zhangjamin@163.com" registry.jaminzhang.me
WARNING: login credentials saved in /root/.docker/config.json
Login Succeeded

```    

## 3.3 上传、查看镜像

```bash

[root@linux-node1 ~]# docker tag centos registry.jaminzhang.me/centos
[root@linux-node1 ~]# docker push registry.jaminzhang.me/centos
The push refers to a repository [registry.jaminzhang.me/centos]
0aeb287b1ba9: Pushed 
latest: digest: sha256:2ae0d2c881c7123870114fb9cc7afabd1e31f9888dac8286884f6cf59373ed9b size: 507

# 文件目录结构
[root@linux-node1 repositories]# pwd
/opt/data/registry/docker/registry/v2/repositories	# 启动 Registry 容器时 /var/lib/registry 是挂载到 /opt/data/registry/ 的
[root@linux-node1 repositories]# tree
.
└── centos
    ├── _layers
    │   └── sha256
    │       ├── 8d30e94188e7f13642d975e70c484e48c33867f3ede3277df1145803fa996ac1
    │       │   └── link
    │       └── 980e0e4c79ec933406e467a296ce3b86685e6b42eed2f873745e6a91d718e37a
    │           └── link
    ├── _manifests
    │   ├── revisions
    │   │   └── sha256
    │   │       └── 2ae0d2c881c7123870114fb9cc7afabd1e31f9888dac8286884f6cf59373ed9b
    │   │           └── link
    │   └── tags
    │       └── latest
    │           ├── current
    │           │   └── link
    │           └── index
    │               └── sha256
    │                   └── 2ae0d2c881c7123870114fb9cc7afabd1e31f9888dac8286884f6cf59373ed9b
    │                       └── link
    └── _uploads

16 directories, 5 files

[root@linux-node1 ~]# docker pull registry.jaminzhang.me/centos
Using default tag: latest
Trying to pull repository registry.jaminzhang.me/centos ... 
latest: Pulling from registry.jaminzhang.me/centos
Digest: sha256:2ae0d2c881c7123870114fb9cc7afabd1e31f9888dac8286884f6cf59373ed9b
Status: Image is up to date for registry.jaminzhang.me/centos:latest

```    


# 遇到的问题

这次 Docker Registry 遇到了太多的问题，弄了几天了，网上一搜索，也是各种吐槽坑太多，现在应该好好总结一下。  
首先第一个感想是首先要明白 Docker Registry 是什么，先按照官方文档来理解熟悉它的安装配置及使用。  
这次思路太乱，Docker Registry 本身没有按照官方文档来安装配置一遍，好多模棱两可，
然后再结合 Nginx 前端代理 SSL、基本认证，把问题弄得更复杂了。

**总结：学习一项具体技术方案时要严格按照官方文档（或其他一份较好的文档，不能看太多，不然会混乱）来安装搭建一次，
不要加任何自定义自以为正确的处理，搭建成功后再进行自定义操作，然后可以再看看其他的文档怎么做。**

## 1. 本地测试 docker login 出现 Service Unavailable，是由于使用了 HTTP 代理

```bash

[root@linux-node1 ~]# docker login https://registry.jaminzhang.me
Error response from daemon: invalid registry endpoint https://registry.jaminzhang.me/v0/: unable to ping registry endpoint https://registry.jaminzhang.me/v0/
v2 ping attempt failed with error: Get https://registry.jaminzhang.me/v2/: Service Unavailable
 v1 ping attempt failed with error: Get https://registry.jaminzhang.me/v1/_ping: Service Unavailable. If this private registry supports only HTTP or HTTPS with an unknown CA certificate, please add `--insecure-registry registry.jaminzhang.me` to the daemon's arguments. In the case of HTTPS, if you have access to the registry's CA certificate, no need for the flag; simply place the CA certificate at /etc/docker/certs.d/registry.jaminzhang.me/ca.crt

```     
 
这个坑是由于之前功夫网原因，下载官方镜像太慢，添加了公司代理，需要删除然后重启 Docker。

## 2. nginx 配置文件问题

Nginx 很久没接触（生产直接使用私有 yum 源上的 nginx），修改配置文件后，没有监听 443 端口，排错花了些时间。  
配置文件检查有语法错误，然后使用独立的配置文件时，yum 安装的 nginx 配置文件 nginx.conf 中默认没有 `include conf.d/*.conf;`，需要额外添加。

## 3. Docker login fails with v2.1.1 registry because auth fails and calls v1 endpoints

和这位一样的问题 [Docker login fails with v2.1.1 registry because auth fails and calls v1 endpoints](https://github.com/docker/docker/issues/16676)，我就不再细说了。
这个问题是由于没有仔细使用官网的配置文件，漏掉了一行 `add_header 'Docker-Distribution-Api-Version' 'registry/2.0' always;` 配置


# Ref
[Docker Registry](https://docs.docker.com/registry/)  
[Deploying a registry server](https://github.com/docker/distribution/blob/master/docs/deploying.md)  
[Authenticating proxy with nginx](https://docs.docker.com/registry/recipes/nginx/)
[Docker Registry V2(distribution) & Proxy(nginx) 的搭建经历](http://unixman.blog.51cto.com/10163040/1707423)  
[部署私有 Docker Registry](http://tonybai.com/2016/02/26/deploy-a-private-docker-registry/)  

