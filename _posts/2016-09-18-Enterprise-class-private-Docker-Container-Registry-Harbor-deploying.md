---
layout: post
title: Docker 企业级私有镜像仓库 Harbor 部署
description: "Docker 企业级私有镜像仓库 Harbor 部署"
category: Docker
avatarimg:
tags: [Docker, Registry, Harbor]
duoshuo: true
---


Docker 企业级私有镜像仓库 Harbor 部署

# 引言
前一篇文章，我们部署官方的 Docker Registry 作为镜像仓库，部署过程中遇到了很多问题。  
除此之处，Docker Registry 没有管理页面，甚至连一些运维必备的功能都是缺失的，还有什么
Docker 镜像仓库管理工具呢？这里有一个简单好用的企业级 Registry 服务器 - Harbor，推荐在生产环境上使用。

# Harbor 简介

<pre>
Harbor 是一个用于存储和分发 Docker 镜像的企业级 Registry 服务器，通过添加一些企业必需的功能特性，
例如安全、标识和管理等，扩展了开源 Docker Distribution。
作为一个企业级私有 Registry 服务器，Harbor 提供了更好的性能和安全。提升用户使用 Registry 构建和运行环境传输镜像的效率。
Harbor 支持安装在多个 Registry 节点的镜像资源复制，镜像全部保存在私有 Registry 中，确保数据和知识产权在公司内部网络中管控。
另外，Harbor也提供了高级的安全特性，诸如用户管理，访问控制和活动审计等。
</pre>

<pre>
Harbor 是由 VMware 中国研发团队负责开发的开源企业级 Docker Registry，不仅解决了我们直接使用 Docker Registry 的功能缺失，
更解决了我们在生产使用 Docker Registry 面临的高可用、镜像仓库直接复制、镜像仓库性能等运维痛点。
</pre>

# Harbor 部署

## 目标主机环境准备

* Python 版本 2.7 及以上
* Docker engine 版本 1.10 及以上
* Docker Compose 版本 1.6.0 及以上

## 安装步骤

### 1. 下载安装包

如果网络环境不好或主机不连接互联网，可以下载离线安装包。[下载地址](https://github.com/vmware/harbor/releases)  

```bash
cd /usr/local
wget https://github.com/vmware/harbor/releases/download/0.4.1/harbor-offline-installer-0.4.1.tgz
tar xvf harbor-offline-installer-0.4.1.tgz
cd harbor/
```    

### 2. 配置 Harbor

Harbor 的配置文件是 harbor.cfg，里面有各种参数可以配置。  
本文演示修改以下几个参数。如果要生产上部署，其他密码相关参数也务必要修改。

```bash
hostname = registry.jaminzhang.me
ui_url_protocol = https
```    

Harbor 的每个组件都是以 Docker 容器的形式构建的，使用 Docker Compose 来对它进行部署。  
你可以查看 docker-compose.yml 文件，可以发现 Harbor 有 6 个容器组成：  

1. harbor_ui：Harbor 的核心服务
2. harbor_log：运行着 rsyslog 的容器，进行日志收集
3. harbor_mysql：由官方 mysql 镜像构成的数据库容器
4. nginx：使用 Nginx 做反向代理
5. registry：官方的 Docker Registry
6. harbor_jobservice：Harbor 的任务管理服务。


### 3. 配置 Harbor 的 HTTPS 访问

**1. 获取证书**  

默认情况下 Harbor 是使用 http 进行访问，官方提供了自签名证书的方法，不过生产环境还是建议购买 SSL 证书。  
在上一篇文章中，我们已经在沃通申请了一个免费的 SSL 证书，这里我们直接使用。

```bash
[root@linux-node1 cert]# pwd
/usr/local/harbor/config/nginx/cert         # 将 SSL 证书放置在此目录下，本文 Harbor 安装包解压后目录是 /usr/local/harbor
[root@linux-node1 cert]# ll
total 12
-rw-r--r-- 1 root root 6664 Oct  5 20:38 domain.crt
-rw-r--r-- 1 root root 1674 Oct  5 20:38 domain.key
```    

**2. 修改 Nginx 文件**  

```bash
mv nginx.conf nginx.conf.bak
cp nginx.https.conf nginx.conf
vim nginx.conf
# nginx.conf 修改以下几个参数：

# SSL 部分根据实际 SSL 证书实际支持的参数修改，以下是沃通免费 SSL 证书的相关配置参数
# SSL
ssl_certificate /etc/nginx/cert/domain.crt;
ssl_certificate_key /etc/nginx/cert/domain.key;

# Recommendations from https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_ciphers AESGCM:ALL:!DH:!EXPORT:!RC4:+HIGH:!MEDIUM:!LOW:!aNull:!eNULL;
ssl_prefer_server_ciphers on;
ssl_session_cache shared:SSL:10m;

server {
    listen 443 ssl;
    server_name registry.jaminzhang.me;
...
server {
    listen 80;
    server_name registry.jaminzhang.me;
    rewrite ^/(.*) https://$server_name:443/$1 permanent;
...

```    

### 4. 安装启动 Harbor

```bash
[root@linux-node1 harbor]# ./install.sh 
[Step 0]: checking installation environment ...
docker version: 1.10.3
docker-compose version: 1.8.1
[Step 1]: loading Harbor images ...

[Step 2]: preparing environment ...
Clearing the configuration file: ./config/ui/app.conf
Clearing the configuration file: ./config/ui/env
Clearing the configuration file: ./config/registry/config.yml
Clearing the configuration file: ./config/db/env
Clearing the configuration file: ./config/jobservice/env
Generated configuration file: ./config/ui/env
Generated configuration file: ./config/ui/app.conf
Generated configuration file: ./config/registry/config.yml
Generated configuration file: ./config/db/env
Generated configuration file: ./config/jobservice/env
Clearing the configuration file: ./config/ui/private_key.pem
Clearing the configuration file: ./config/registry/root.crt
Generated configuration file: ./config/ui/private_key.pem
Generated configuration file: ./config/registry/root.crt
The configuration files are ready, please use docker-compose to start the service.

[Step 3]: checking existing instance of Harbor ...

[Step 4]: starting Harbor ...
Creating harbor_log_1
Creating harbor_registry_1
Creating harbor_mysql_1
Creating harbor_ui_1
Creating harbor_jobservice_1
Creating harbor_proxy_1

----Harbor has been installed and started successfully.----

Now you should be able to visit the admin portal at https://registry.jaminzhang.me. 
For more details, please visit https://github.com/vmware/harbor .
```    

如果一切工作正常，可以使用浏览器访问 Harbor 管理入口 https://registry.jaminzhang.me。  
默认的管理员用户名、密码是：admin/Harbor12345。再次提醒，生产环境中部署一定要修改配置复杂密码。  

![Harbor Dashboard](http://jaminzhang.github.io/images/Docker/Harbor-Dashboard.png)  



### 5. 简单测试

在 Harbor Web 界面上创建一个私有项目，名称为 `myproject`，然后使用 docker 命令登录并上传镜像

```bash
[root@linux-node1 ~]# docker login registry.jaminzhang.me
Username: admin
Password: 
Email: zhangjamin@163.com
WARNING: login credentials saved in /root/.docker/config.json
Login Succeeded
[root@linux-node1 ~]# docker tag nginx registry.jaminzhang.me/myproject/mynginx:v1
[root@linux-node1 ~]# docker push registry.jaminzhang.me/myproject/mynginx:v1
The push refers to a repository [registry.jaminzhang.me/myproject/mynginx]
69ecf026ff94: Pushed 
d7953e5e5bba: Pushed 
2f71b45e4e25: Pushed 
v1: digest: sha256:d33834dd25d330da75dccd8add3ae2c9d7bb97f502b421b02cecb6cb7b34a1b6 size: 926

[root@linux-node1 ~]# docker pull registry.jaminzhang.me/myproject/mynginx:v1
Trying to pull repository registry.jaminzhang.me/myproject/mynginx ... 
v1: Pulling from registry.jaminzhang.me/myproject/mynginx
Digest: sha256:d33834dd25d330da75dccd8add3ae2c9d7bb97f502b421b02cecb6cb7b34a1b6
Status: Image is up to date for registry.jaminzhang.me/myproject/mynginx:v1

```    

![Harbor Repository](http://jaminzhang.github.io/images/Docker/Harbor-Repository.png)  

# 遇到的问题

## 1. pip 安装 Docker Compose 后运行报错

`pkg_resources.DistributionNotFound: backports.ssl-match-hostname>=3.5`

使用 pip 更新 backports.ssl-match-hostname 的版本  

`pip install --upgrade backports.ssl_match_hostname`
更新 backports.ssl_match_hostname 到 3.5 版本后问题解决


## 2. nginx 容器证书文件找不到报错

```bash
Oct  5 20:18:35 linux-node1 docker-current/proxy[9439]: 2016/10/05 12:18:35 [emerg] 1#1: BIO_new_file("/etc/nginx/cert/domain.crt") failed (SSL: error:02001002:system library:fopen:No such file or directory:fopen('/etc/nginx/cert/domain.crt','r') error:2006D080:BIO routines:BIO_new_file:no such file)
```    
一开始我将证书文件直接放在了本机的`/etc/nginx/cert/`下面，其实这里的 nginx 容器做了目录映射，应该放在对应的目录，本文是放在`/usr/local/harbor/config/nginx/cert`



# Ref
[VMware Harbor](http://vmware.github.io/harbor/index_cn.html)  
[Installation and Configuration Guide](https://github.com/vmware/harbor/blob/master/docs/installation_guide.md)  
[使用Harbor构建企业级Docker Registry](http://mp.weixin.qq.com/s?__biz=MzIxMDAwOTcwMA==&mid=2247483838&idx=1&sn=cb6855c6491f2d8aa02f8b4055d19c00&chksm=976a6ab5a01de3a32a0e16780aa6ce2d5157408036371cc15aee0d32b8ad50144443a5ea5e60&mpshare=1&scene=1&srcid=1005dvu4qmSm60pqyMlQ6g2w#rd)  
[Centos7 安装docker-compose](http://www.opstool.com/article/335)  
