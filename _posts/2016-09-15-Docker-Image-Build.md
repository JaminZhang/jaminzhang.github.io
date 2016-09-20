---
layout: post
title: Docker 镜像构建
description: "Docker 镜像构建"
category: Docker
avatarimg:
tags: [Docker, Image, Build, Dockerfile]
duoshuo: true
---

# Docker 镜像构建

Docker 的镜像构建算是 Docker 的一个重点，因为应用的交付就是通过镜像方式。  
构建 Docker 镜像有 2 种方式：

* 手动构建
* Dockerfile


前面进行测试，运行了很多容器，下面我们将这些容器全部删除（此命令生产环境上慎用）

```bash
[root@linux-node1 ~]# docker kill $(docker ps -a -q)
ed81da17ee16
868a9e6b7aa0
9e061b675f1a
30fd50542bb5
420066be5a1d
7236cf1a985a
Failed to kill container (fa89f37d06f0): Error response from daemon: Cannot kill container fa89f37d06f0: Container fa89f37d06f01039025db83acd5af67ff90dd8c474d78872b4bf10ab3f354311 is not running
# 这个容器并没有运行，所以 docker kill 会报错
[root@linux-node1 ~]# docker rm $(docker ps -a -q)
ed81da17ee16
868a9e6b7aa0
9e061b675f1a
30fd50542bb5
420066be5a1d
7236cf1a985a
fa89f37d06f0
[root@linux-node1 ~]# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

```    

## 手动构建镜像

实质是运行一个容器后，进行相关处理，然后使用 docker commit 创建一个镜像。  
下面演示手动构建一个基于 centos 镜像的 nginx 镜像。  

```bash

# 运行一个 centos 容器
[root@linux-node1 ~]# docker run --name mynginx -it centos

# 安装阿里的 EPEL 源
[root@a8ce8388eb81 /]# rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
Retrieving http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
warning: /var/tmp/rpm-tmp.joxzhq: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Preparing...                          ################################# [100%]
Updating / installing...
   1:epel-release-7-8                 ################################# [100%]

# 安装 nginx
[root@a8ce8388eb81 /]# yum install nginx -y
...省略...

# 清除 yum 安装的缓存
[root@a8ce8388eb81 /]# yum clean all
Loaded plugins: fastestmirror, ovl
Cleaning repos: base epel extras updates
Cleaning up everything
Cleaning up list of fastest mirrors

# 配置 nginx 前台运行
[root@a8ce8388eb81 /]# vi /etc/nginx/nginx.conf
deamon off; # 增加这一行配置
user nginx;
[root@a8ce8388eb81 /]# exit

# 使用 docker commit 创建镜像
[root@linux-node1 ~]# docker commit -m "My Nginx" mynginx jaminzhang/mynginx:v1
sha256:370e352e4ed5c7edb4b34f06c9f3713112381fb618046e9d19310bfb11ca4da4
# 此处是本地提交，类似 git commit

# 使用 docker images 查看刚创建的 nginx 镜像
[root@linux-node1 ~]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
jaminzhang/mynginx          v1                  370e352e4ed5        20 seconds ago      261.9 MB
docker.io/nginx             latest              4a88d06e26f4        3 days ago          183.5 MB
docker.io/centos            latest              980e0e4c79ec        12 days ago         196.7 MB

# 以刚才创建的 nginx 镜像 运行一个容器
[root@linux-node1 ~]# docker run --name mynginxv1 -d -p 80:80 jaminzhang/mynginx:v1 nginx
90714195490bf750007eb2a583679f03b94762c382276973b06c60f3f3c49368
[root@linux-node1 ~]# docker ps
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS                NAMES
90714195490b        jaminzhang/mynginx:v1   "nginx"             22 seconds ago      Up 20 seconds       0.0.0.0:80->80/tcp   mynginxv1

# 然后通过浏览器测试访问

# 使用 docker logs mynginxv1 查看容器日志
[root@linux-node1 ~]# docker logs -f mynginxv1

# 访问时并没有在上面看到日志，因为默认 nginx 访问日志是配置在 /var/log/nginx/access.log 了，我们可以查看下
[root@linux-node1 ~]#./docker_in.sh mynginxv1
[root@90714195490b /]# tail -5 /var/log/nginx/access.log 
192.168.56.1 - - [19/Sep/2016:11:53:48 +0000] "GET /nginx-logo.png HTTP/1.1" 304 0 "http://192.168.56.11/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36" "-"
192.168.56.1 - - [19/Sep/2016:11:53:48 +0000] "GET /poweredby.png HTTP/1.1" 304 0 "http://192.168.56.11/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36" "-"
192.168.56.1 - - [19/Sep/2016:11:53:54 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36" "-"
192.168.56.1 - - [19/Sep/2016:11:53:54 +0000] "GET /nginx-logo.png HTTP/1.1" 304 0 "http://192.168.56.11/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36" "-"
192.168.56.1 - - [19/Sep/2016:11:53:54 +0000] "GET /poweredby.png HTTP/1.1" 304 0 "http://192.168.56.11/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36" "-"

```    


## 通过 Dockerfile 构建镜像

下面演示将上面手动构建镜像过程改写成基于 Dockerfile 构建。  

```bash

# 创建镜像构建准备目录
[root@linux-node1 ~]# mkdir /opt/dockerfile
[root@linux-node1 ~]# cd /opt/dockerfile
[root@linux-node1 dockerfile]# mkdir nginx
[root@linux-node1 dockerfile]# cd nginx 

# 编写 Dockerfile
[root@linux-node1 nginx]# vim Dockerfile
# This Dockfile is used for nginx based on centos

# Base image
FROM centos

# Maintainer
MAINTAINER Jamin Zhang zhangjamin@163.com

# Commands
RUN rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
RUN yum install nginx -y && yum clean all
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD index1.html /usr/share/nginx/html/index1.html
EXPOSE 80
CMD ["nginx"]

# 以上还使用了 ADD 添加本地文件到镜像中，如果是压缩文件，ADD 还可以做解压缩操作。
# 准备一个 index1.html 测试文件
[root@linux-node1 nginx]# echo "nginx in Docker." >> index1.html

# 以上 Dockerfile 详细说明在之后 Ref 中的文章有详细介绍，我这里就不再解释了。
# 这里暂时使用几个简单指令，就将上面手动构建镜像过程改写成了 Dockerfile。

# 使用 docker build 从 Dockerfile 构建镜像
[root@linux-node1 nginx]# docker build -t jaminzhang/mynginx:v2 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM centos
 ---> 980e0e4c79ec
Step 2 : MAINTAINER Jamin Zhang zhangjamin@163.com
 ---> Running in 6087f6aeff98
 ---> 6a7aa317f098
Removing intermediate container 6087f6aeff98
Step 3 : RUN rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
 ---> Running in 31955f1e721d
warning: /var/tmp/rpm-tmp.7M1zBQ: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Retrieving http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
Preparing...                          ########################################
Updating / installing...
epel-release-7-8                      ########################################
 ---> f563b84895a3
Removing intermediate container 31955f1e721d
Step 4 : RUN yum install nginx -y && yum clean all
 ---> Running in f06a0bf09545
Loaded plugins: fastestmirror, ovl
... 省略 ...
Complete!
Loaded plugins: fastestmirror, ovl
Cleaning repos: base epel extras updates
Cleaning up everything
Cleaning up list of fastest mirrors
 ---> 23bfc72bd0c2
Removing intermediate container f06a0bf09545
Step 5 : RUN echo "daemon off;" >> /etc/nginx/nginx.conf
 ---> Running in 6cc9395e7c7d
 ---> dd32cc906587
Removing intermediate container 6cc9395e7c7d
Step 6 : ADD index1.html /usr/share/nginx/html/index1.html
 ---> c0b601df1ff1
Removing intermediate container 4545930b1402
Step 7 : EXPOSE 80
 ---> Running in bf5569b609b4
 ---> d180626f3b15
Removing intermediate container bf5569b609b4
Step 8 : CMD nginx
 ---> Running in 660a9016ec6f
 ---> 41ae8a732748
Removing intermediate container 660a9016ec6f
Successfully built 41ae8a732748

# 以上构建镜像完成，我们查看下
[root@linux-node1 nginx]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
jaminzhang/mynginx          v2                  41ae8a732748        2 minutes ago       278.9 MB
jaminzhang/mynginx          v1                  370e352e4ed5        20 hours ago        261.9 MB
docker.io/nginx             latest              4a88d06e26f4        4 days ago          183.5 MB
docker.io/centos            latest              980e0e4c79ec        13 days ago         196.7 MB

# 从刚才创建的镜像运行容器并访问测试
[root@linux-node1 nginx]# docker run --name mynginxv2 -d -p 81:80 mynginx:v2
93045710a0314528af9b01468c1dd9742bb20f0020d7fc1f82d10c3196e8292f
[root@linux-node1 nginx]# docker port mynginxv2
80/tcp -> 0.0.0.0:81
[root@linux-node1 nginx]# curl "http://192.168.56.11:81/index1.html"
nginx in Docker.

```    

# Ref
[一张图就能学会Dockerfile你知道吗？](http://mp.weixin.qq.com/s?__biz=MzIxMDAwOTcwMA==&mid=2247483818&idx=1&sn=4a49793b166be681ce62857132dfdfbf&chksm=976a6aa1a01de3b72c3fa45c5d4fa4abb35bab99b7fd9e7ad640c2da83aef46d12ffedda64e6&scene=23&srcid=09202NJJspBHWhx3Ri1HjMUB#rd)  
[Dockerfile 指令](https://yeasy.gitbooks.io/docker_practice/content/dockerfile/instructions.html)  
