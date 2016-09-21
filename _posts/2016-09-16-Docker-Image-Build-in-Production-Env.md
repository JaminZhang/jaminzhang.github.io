---
layout: post
title: 生产上的 Docker 镜像构建
description: "生产上的 Docker 镜像构建"
category: Docker
avatarimg:
tags: [Docker, Image, Build, Dockerfile, Production, Supervisor]
duoshuo: true
---

# 生产上的 Docker 镜像构建

在生产环境中实际进行镜像构建时，我们需要仔细结合业务考虑，下面从一个通用的角度来看看生产环境上的镜像可以怎样构建。  

## 规划

根据架构来进行镜像分层设计：

* 应用服务层
* 运行环境层
* 操作系统层

创建如下目录结构

```bash
[root@linux-node1 docker]# tree
.
├── app
│   ├── xxx-admin
│   └── xxx-api
├── runtime
│   ├── java
│   ├── php
│   └── python
└── system
    ├── centos
    ├── centos-ssh
    └── ubuntu
```    

## 实施构建

### 构建 centos 基础系统镜像

```bash
# 下载阿里的 EPEL repo 文件
[root@linux-node1 centos]# wget  http://mirrors.aliyun.com/repo/epel-7.repo

# 编写 centos 基础系统镜像构建 Dockerfile
[root@linux-node1 centos]# vim Dockerfile 
# Dockerfile for CentOS

# Base image
FROM centos

# Maintainer
MAINTAINER Jamin Zhang zhangjamin@163.com

# Config EPEL
ADD epel.repo /etc/yum.repos.d/

# Base pkgs
RUN yum install -y wget mysql-devel supervisor git redis tree net-tools sudo psmisc && yum clean all

# 执行构建
[root@linux-node1 centos]# docker build -t jaminzhang/centos:base .
Sending build context to Docker daemon 4.096 kB
Step 1 : FROM centos
 ---> 980e0e4c79ec
Step 2 : MAINTAINER Jamin Zhang zhangjamin@163.com
 ---> Using cache
 ---> 6a7aa317f098
Step 3 : ADD epel.repo /etc/yum.repos.d/
 ---> 31739d51fe47
Removing intermediate container 499f0617a99d
Step 4 : RUN yum install -y wget mysql-devel supervisor git redis tree net-tools sudo psmisc && yum clean all
 ---> Running in 2d126394fcc2
Loaded plugins: fastestmirror, ovl
...此处内容省略...
Complete!
Loaded plugins: fastestmirror, ovl
Cleaning repos: base epel extras updates
Cleaning up everything
Cleaning up list of fastest mirrors
 ---> b0cfe8ee533b
Removing intermediate container 87d1affab0ed
Successfully built b0cfe8ee533b

# 查看镜像
[root@linux-node1 centos]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
jaminzhang/centos           base                b0cfe8ee533b        47 seconds ago      283.3 MB
...此处内容省略...

```    

### 构建带 SSH 服务的 centos 基础系统镜像

基于上面的 Dockerfile，只需要 yum 安装上 openssh 相关软件包，还有加上 SSH 服务的配置

```bash
[root@linux-node1 centos-ssh]# cat Dockerfile 
# Dockerfile for CentOS

# Base image
FROM centos

# Maintainer
MAINTAINER Jamin Zhang zhangjamin@163.com

# Config EPEL
ADD epel.repo /etc/yum.repos.d/

# Base pkgs
RUN yum install -y openssh-clients openssl-devel openssh-server wget mysql-devel supervisor git redis tree net-tools sudo psmisc && yum clean all

# Config SSH
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
RUN echo "root:jaminzhang" | chpasswd

```    

### 构建 Python 运行环境镜像

```bash
[root@linux-node1 docker]# cd runtime/python/

# 编写 Dockerfile
[root@linux-node1 python]# vim Dockerfile
# Dockerfile for Python Runtime

# Base image
FROM jaminzhang/centos:base

# Maintainer
MAINTAINER Jamin Zhang zhangjamin@163.com

# Python Env
RUN yum install -y python-devel python-pip supervisor

# Upgrade pip
RUN pip install --upgrade pip

# 执行构建
root@linux-node1 python]# docker build -t jaminzhang/centos-python .
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM jaminzhang/centos:base
 ---> b0cfe8ee533b
Step 2 : MAINTAINER Jamin Zhang zhangjamin@163.com
 ---> Running in c475c9ea8590
 ---> 959ca1b56c2b
Removing intermediate container c475c9ea8590
Step 3 : RUN yum install -y python-devel python-pip supervisor
 ---> Running in 5489d50d3f75
Loaded plugins: fastestmirror, ovl
...此处内容省略...
Complete!
 ---> 81221403ea32
Removing intermediate container 5489d50d3f75
Step 4 : RUN pip install --upgrade pip
 ---> Running in 4e5fdf04b2c8
You are using pip version 7.1.0, however version 8.1.2 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
...此处内容省略...
Successfully installed pip-8.1.2
 ---> f2c8f1bade0f
Removing intermediate container 4e5fdf04b2c8
Successfully built f2c8f1bade0f

# 查看镜像
[root@linux-node1 python]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
jaminzhang/centos-python    latest              f2c8f1bade0f        32 seconds ago      453.8 MB
jaminzhang/centos-ssh       base                40af0c56e966        11 minutes ago      284.3 MB
jaminzhang/centos           base                b0cfe8ee533b        20 minutes ago      283.3 MB
...此处内容省略...
```    
### 构建带 SSH 服务 的 Python 运行环境镜像

```bash
# 基于 centos-ssh 镜像构建
[root@linux-node1 runtime]# cd python-ssh
[root@linux-node1 python-ssh]# vim Dockerfile
# Dockerfile for Python Runtime include SSHD

# Base image
FROM jaminzhang/centos-ssh:base

# Maintainer
MAINTAINER Jamin Zhang zhangjamin@163.com

# Python Env
RUN yum install -y python-devel python-pip supervisor

# Upgrade pip
RUN pip install --upgrade pip
# 构建
[root@linux-node1 python-ssh]# docker build -t jaminzhang/python-ssh .
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM jaminzhang/centos-ssh:base
 ---> 40af0c56e966
Step 2 : MAINTAINER Jamin Zhang zhangjamin@163.com
 ---> Running in 2abc1d904a53
 ---> 6dfc443c173f
Removing intermediate container 2abc1d904a53
Step 3 : RUN yum install -y python-devel python-pip supervisor
 ---> Running in b7b70a18db21
Loaded plugins: fastestmirror, ovl
...此处内容省略...
Complete!
 ---> f2a9f09ee6c3
Removing intermediate container b7b70a18db21
Step 4 : RUN pip install --upgrade pip
 ---> Running in 262206e28bd5
...此处内容省略...
    Uninstalling pip-7.1.0:
      Successfully uninstalled pip-7.1.0
Successfully installed pip-8.1.2
 ---> 6982a0433dea
Removing intermediate container 262206e28bd5
Successfully built 6982a0433dea

# 查看镜像
[root@linux-node1 ~]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
jaminzhang/python-ssh       latest              6982a0433dea        52 seconds ago      454.8 MB
jaminzhang/centos-python    latest              f2c8f1bade0f        About an hour ago   453.8 MB
jaminzhang/centos-ssh       base                40af0c56e966        About an hour ago   284.3 MB
jaminzhang/centos           base                b0cfe8ee533b        2 hours ago         283.3 MB
...此处内容省略...

```    

### 构建基于 python-ssh 镜像的业务镜像

```bash
# 创建一个 shop-api 演示项目
[root@linux-node1 app]# mkdir shop-api
[root@linux-node1 app]# cd shop-api/

# 编写一个 Python Flask 演示项目
[root@linux-node1 shop-api]# vim app.py
[root@linux-node1 shop-api]# cat app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World!' 

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)

# 准备 Python requirements 文件
[root@linux-node1 shop-api]# vim requirements.txt
flask

# 准备 supervisor 配置文件，我们使用 supervisor 来管理容器中的服务进程，可以做到自动重启
[root@linux-node1 shop-api]# cp /etc/supervisord.conf .
nodaemon=true	# 容器中开启前台运行
[root@linux-node1 shop-api]# vim app-supervisor.ini 
[program:shop-api]
command=/usr/bin/python2.7 /opt/app.py
process_name=%(program_name)s
autostart=true
user=www
stdout_logfile=/tmp/app.log
stderr_logfile=/tmp/app.error

[program:sshd]
command=/usr/sbin/sshd -D
process_name=%(program_name)s
autostart=true

# 编写 Dockerfile
[root@linux-node1 shop-api]# cat Dockerfile
# Dockerfile for shop-api demo project

# Base image
FROM jaminzhang/python-ssh

# Maintainer
MAINTAINER Jamin Zhang zhangjamin@163.com

# Python Env
RUN useradd -s /sbin/nologin -M www

# Add file
ADD app.py /opt/app.py
ADD requirements.txt /opt/
ADD supervisord.conf /etc/supervisord.conf
ADD app-supervisor.ini /etc/supervisord.d/

# Upgrade pip
RUN /usr/bin/pip2.7 install -r /opt/requirements.txt

# Port
EXPOSE 22 5000

# CMD
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

# 项目目录结构
[root@linux-node1 app]# tree shop-api/
shop-api/
├── app.py
├── app-supervisor.ini
├── Dockerfile
├── requirements.txt
└── supervisord.conf

# 构建
[root@linux-node1 shop-api]# docker build -t jaminzhang/shop-api:v1 .
Sending build context to Docker daemon 13.82 kB
Step 1 : FROM jaminzhang/python-ssh
 ---> 6982a0433dea
Step 2 : MAINTAINER Jamin Zhang zhangjamin@163.com
 ---> Running in 11df9ec88355
 ---> e70557634737
Removing intermediate container 11df9ec88355
Step 3 : RUN useradd -s /sbin/nologin -M www
 ---> Running in eddbe1a098ad
 ---> 98a91fcd3fa5
Removing intermediate container eddbe1a098ad
Step 4 : ADD app.py /opt/app.py
 ---> 549f2b6817af
Removing intermediate container bfda4b8598f0
Step 5 : ADD requirements.txt /opt/
 ---> 53737be5a098
Removing intermediate container 819b4bb80d44
Step 6 : ADD supervisord.conf /etc/supervisord.conf
 ---> 6a0b33ab4a16
Removing intermediate container 48b2b1b72a0c
Step 7 : ADD app-supervisor.ini /etc/supervisord.d/
 ---> bc1049994316
Removing intermediate container b416a84e06f5
Step 8 : RUN /usr/bin/pip2.7 install -r /opt/requirements.txt
 ---> Running in 343d55f2e03c
Collecting flask (from -r /opt/requirements.txt (line 1))
...此处内容省略...
Successfully installed Jinja2-2.8 MarkupSafe-0.23 Werkzeug-0.11.11 click-6.6 flask-0.11.1 itsdangerous-0.24
 ---> 2f5ffb73ad7b
Removing intermediate container 343d55f2e03c
Step 9 : EXPOSE 22 5000
 ---> Running in e7bea8407b95
 ---> 3dff08d8b635
Removing intermediate container e7bea8407b95
Step 10 : CMD /usr/bin/supervisord -c /etc/supervisord.conf
 ---> Running in b453d2525db1
 ---> 6bd380c9ba47
Removing intermediate container b453d2525db1
Successfully built 6bd380c9ba47

# 查看镜像
[root@linux-node1 shop-api]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED              SIZE
jaminzhang/shop-api         v1                  6bd380c9ba47        About a minute ago   460 MB
jaminzhang/python-ssh       latest              6982a0433dea        53 minutes ago       454.8 MB
jaminzhang/centos-python    latest              f2c8f1bade0f        2 hours ago          453.8 MB
jaminzhang/centos-ssh       base                40af0c56e966        2 hours ago          284.3 MB
...此处内容省略...

# 运行容器
[root@linux-node1 shop-api]# docker run --name shop-api-v1 -d -p 88:5000 -p 8022:22 jaminzhang/shop-api:v1
110276d8417759781e7a26f99bb15411bdfddbd59db83d5136be594422e16b2c
[root@linux-node1 shop-api]# docker port shop-api-v1
22/tcp -> 0.0.0.0:8022
5000/tcp -> 0.0.0.0:88

# 访问测试
[root@linux-node1 shop-api]# curl "http://192.168.56.11:88/"
Hello World!

Connecting to 192.168.56.11:8022...
Connection established.
To escape to local shell, press 'Ctrl+Alt+]'.

[root@110276d84177 ~]# w
 12:59:23 up 21:33,  1 user,  load average: 0.06, 0.14, 0.12
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    192.168.56.1     12:59    1.00s  0.00s  0.00s w

```    

>
推荐生产环境上使用 supervisor 来管理容器中的多个服务进程。  
PHP/JAVA 环境的项目镜像构建和上面 Python 项目是相同的思路，先在真实主机上安装测试好后再写 Dockerfile。

# Ref

[Docker Compose](https://docs.docker.com/compose/gettingstarted/)  
