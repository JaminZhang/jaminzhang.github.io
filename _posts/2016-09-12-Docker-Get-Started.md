---
layout: post
title: Docker 快速入门
description: "Docker 快速入门"
category: Docker
avatarimg:
tags: [Docker, Image, Container]
duoshuo: true
---


Docker 快速入门

# 安装启动 Docker

>
yum install docker  
systemctl start docker

这里我们使用 yum 安装 CentOS 自带源中的 Docker，这个版本没有 Docker 自己的 yum 源中 Docker  
版本高，如果要安装最新的 Docker 版本，需要使用 Docker 自己的 yum 源安装。

```bash
# Docker 启动后，我们可以看到 Docker 启动了一个 docker0 网卡
[root@linux-node1 ~]# ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 0.0.0.0
        ether 02:42:93:3f:73:33  txqueuelen 0  (Ethernet)
        RX packets 2141  bytes 101161 (98.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2318  bytes 13797412 (13.1 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```    

# Docker 镜像管理

* 搜索镜像：docker search
* 获取镜像：docker pull
* 查看镜像：docker images
* 删除镜像：docker rmi

```bash

# 搜索 DockerHub 上的 centos/nginx 镜像，加星数至少为 10
[root@linux-node1 ~]# docker search -s 10 centos 
INDEX       NAME                                      DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
docker.io   docker.io/centos                          The official build of CentOS.                   2645      [OK]       
docker.io   docker.io/ansible/centos7-ansible         Ansible on Centos7                              85                   [OK]
docker.io   docker.io/jdeathe/centos-ssh              CentOS-6 6.8 x86_64 / CentOS-7 7.2.1511 x8...   33                   [OK]
docker.io   docker.io/jdeathe/centos-ssh-apache-php   CentOS-6 6.8 x86_64 / Apache / PHP / PHP M...   19                   [OK]
docker.io   docker.io/nimmis/java-centos              This is docker images of CentOS 7 with dif...   15                   [OK]
docker.io   docker.io/million12/centos-supervisor     Base CentOS-7 with supervisord launcher, h...   12                   [OK]
[root@linux-node1 ~]# docker search -s 10 nginx
INDEX       NAME                                DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
docker.io   docker.io/nginx                     Official build of Nginx.                        4117      [OK]       
docker.io   docker.io/jwilder/nginx-proxy       Automated Nginx reverse proxy for docker c...   794                  [OK]
docker.io   docker.io/richarvey/nginx-php-fpm   Container running Nginx + PHP-FPM capable ...   270                  [OK]
docker.io   docker.io/million12/nginx-php       Nginx + PHP-FPM 5.5, 5.6, 7.0 (NG), CentOS...   76                   [OK]
docker.io   docker.io/maxexcloo/nginx-php       Framework container with nginx and PHP-FPM...   58                   [OK]
docker.io   docker.io/webdevops/php-nginx       Nginx with PHP-FPM                              49                   [OK]
docker.io   docker.io/h3nrik/nginx-ldap         NGINX web server with LDAP/AD, SSL and pro...   29                   [OK]
docker.io   docker.io/bitnami/nginx             Bitnami nginx Docker Image                      18                   [OK]

# 查看本地镜像
[root@linux-node1 ~]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE

# 机器上没有 Docker 镜像，下面使用 docker pull 获取 nginx/centos 镜像
[root@linux-node1 ~]# docker pull nginx
Using default tag: latest
Trying to pull repository docker.io/library/nginx ... 
latest: Pulling from docker.io/library/nginx
8ad8b3f87b37: Pull complete 
c6b290308f88: Pull complete 
f8f1e94eb9a9: Pull complete 
Digest: sha256:aa5ac743d65e434c06fff5ceaab6f35cc8519d80a5b6767ed3bdb330f47e4c31
Status: Downloaded newer image for docker.io/nginx:latest
[root@linux-node1 ~]# docker pull centos
Using default tag: latest
Trying to pull repository docker.io/library/centos ... 
latest: Pulling from docker.io/library/centos
Digest: sha256:2ae0d2c881c7123870114fb9cc7afabd1e31f9888dac8286884f6cf59373ed9b
Status: Image is up to date for docker.io/centos:latest
# 查看刚才下载的镜像
[root@linux-node1 ~]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED                  SIZE
docker.io/nginx             latest              4a88d06e26f4        Less than a second ago   183.5 MB
docker.io/centos            latest              980e0e4c79ec        5 days ago               196.7 MB


# 使用 docker save 将 centos 镜像保存成一个 tar 文件
[root@linux-node1 ~]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
docker.io/centos            latest              980e0e4c79ec        5 days ago          196.7 MB
[root@linux-node1 ~]# docker save -o centos.tar centos
[root@linux-node1 ~]# ll centos.tar 
-rw-r--r-- 1 root root 204316160 Sep 12 19:43 centos.tar


# 使用 docker rmi 删除 centos 镜像
[root@linux-node1 ~]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
docker.io/centos            latest              980e0e4c79ec        5 days ago          196.7 MB
[root@linux-node1 ~]# docker rmi 980e0e4c79ec
Untagged: docker.io/centos:latest
Deleted: sha256:980e0e4c79ec933406e467a296ce3b86685e6b42eed2f873745e6a91d718e37a
Deleted: sha256:0aeb287b1ba9fd4c951bb9f4bd8e50908f51c630e07b655b3b2f9581dc0fef0d

# 使用 docker load 将之前导出的镜像文件 centos.tar 再导入
[root@linux-node1 ~]# docker load --input centos.tar 
[root@linux-node1 ~]# docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED                  SIZE
docker.io/nginx             latest              4a88d06e26f4        Less than a second ago   183.5 MB
docker.io/centos            latest              980e0e4c79ec        5 days ago               196.7 MB

```    

# Docker 容器管理

* 运行容器：docker run 
* 停止容器：docker stop
* 查看容器：docker ps
* 进入容器：docker attach | nsenter | docker exec
* 删除容器：docker rm


## 运行、停止、查看容器

```bash

# 运行一个 centos 窗口输出 “Hello world”
[root@linux-node1 ~]# docker run centos /bin/echo "Hello world"
Hello world

# 使用 docker ps -l 查看最新创建的一个容器
[root@linux-node1 ~]# docker ps -l
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS               NAMES
9356550c0514        centos              "/bin/echo 'Hello wor"   5 minutes ago       Exited (0) 5 minutes ago                       stupefied_carson
# 从上面可以看到，容器状态为退出状态，说明上面的容器运行完成后就退出了

# 下面运行容器时指定名称，并使用 -t -i 开启伪终端和交互式 Shell，这样可以进入容器
[root@linux-node1 ~]# docker run --name mydocker -t -i centos /bin/bash
[root@68c901ac8f8a /]# ls /
anaconda-post.log  bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@68c901ac8f8a /]# uname -a
Linux 68c901ac8f8a 3.10.0-327.18.2.el7.x86_64 #1 SMP Thu May 12 11:03:55 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
[root@68c901ac8f8a /]# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.3  0.0  11752  1872 ?        Ss   08:55   0:00 /bin/bash
root        16  0.0  0.0  47424  1660 ?        R+   08:55   0:00 ps aux
[root@68c901ac8f8a /]# exit
exit

# 上面执行exit 就退出了容器，同时这个容器也退出了
[root@linux-node1 ~]# docker ps -l
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
68c901ac8f8a        centos              "/bin/bash"         2 minutes ago       Exited (0) 8 seconds ago                       mydocker

# 执行 start 启动上面退出的容器
[root@linux-node1 ~]# docker start mydocker
mydocker
# 使用 docker ps 查看运行中的容器
[root@linux-node1 ~]# docker ps 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
68c901ac8f8a        centos              "/bin/bash"         7 minutes ago       Up 13 seconds                           mydocker

```    

## 进入容器

进入容器有三种方式：

* 使用 docker attatch
* 使用 nsenter
* 使用 docker exec

### 1. 使用 docker attach 进入容器

```bash
[root@linux-node1 ~]# docker attach mydocker
[root@68c901ac8f8a /]# ps aux 
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  11776  1864 ?        Ss   09:02   0:00 /bin/bash
root        14  0.0  0.0  47424  1660 ?        R+   09:07   0:00 ps aux
# 此种方式有个不足：当多个终端都进入容器后，执行的操作会同步显示，当某个窗口因命令阻塞时,其他窗口也无法执行操作了。
# docker attach 进入容器后，执行 exit 容器也 会 exit

```   
### 2. 使用 nsenter 进入容器

nsenter 工具在 util-linux 包2.23版本后包含。  
nsenter 可以访问另一个进程的命名空间。nsenter 要正常工作需要有 root 权限。  

```bash
# 为了连接到容器，你还需要找到容器的第一个进程的 PID，可以通过下面的命令获取
[root@linux-node1 ~]# docker inspect -f "{{ .State.Pid }}" mydocker
42667
# 通过这个 PID，就可以连接到这个容器
[root@linux-node1 ~]# nsenter -t 42667 -m -u -i -n -p
[root@68c901ac8f8a /]# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  11776  1668 ?        Ss+  09:16   0:00 /bin/bash
root        14  0.2  0.1  13376  1984 ?        S    09:18   0:00 -bash
root        27  0.0  0.0  49024  1808 ?        R+   09:18   0:00 ps aux

# 我们可以看到有 2 个 bash，第二个 bash 是 nsenter 进入时执行的，当 exit 后，容器并不会退出
[root@68c901ac8f8a /]# exit
logout
[root@linux-node1 ~]# docker ps 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
68c901ac8f8a        centos              "/bin/bash"         24 minutes ago      Up 4 minutes                            mydocker
```    

我们可以将上面命令写成一个简单的进入 Docker 容器的脚本，如下：

```bash
root@linux-node1 ~]# vim docker_in.sh
[root@linux-node1 ~]# cat docker_in.sh
#!/bin/bash
# Use nsenter to enter docker

docker_in(){
   NAME_ID=$1
   PID=$(docker inspect -f "{{ .State.Pid }}" $NAME_ID) 
   nsenter -t $PID -m -u -i -n -p
}

docker_in $1

[root@linux-node1 ~]# chmod +x docker_in.sh 
[root@linux-node1 ~]# ./docker_in.sh mydocker
[root@68c901ac8f8a /]# w
 09:23:03 up 10:22,  0 users,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
[root@68c901ac8f8a /]# exit
logout

```    
### 3. 使用 docker exec 进入容器

```bash
# docker exec 是在一个运行中的容器中运行一个命令，但是不进到容器里面，直接在容器外执行容器内的命令，如下：
[root@linux-node1 ~]# docker exec mydocker w
 09:35:08 up 10:34,  0 users,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT

# 但我们可以使用以下技巧，执行 /bin/bash 达到进入容器的目的
[root@linux-node1 ~]# docker exec -it mydocker /bin/bash
[root@68c901ac8f8a /]# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  11776  1668 ?        Ss+  09:16   0:00 /bin/bash
root        50  1.2  0.1  11776  1880 ?        Ss   09:36   0:00 /bin/bash
root        62  0.0  0.0  47424  1660 ?        R+   09:36   0:00 ps aux

# 注意：docker exec 方式可能会出现一些未知问题

```    

对比上面 3 种进入容器的方式，建议使用 nsenter 的方式进入容器。

## 删除容器

```bash
# 使用 docker rm 删除容器
[root@linux-node1 ~]# docker rm mydocker
Failed to remove container (mydocker): Error response from daemon: Conflict, You cannot remove a running container. Stop the container before attempting removal or use -f
# 提示正在运行中的容器不能删除，可以使用 -f 参数强制删除，也可以 docker stop 停止容器后再删除

# 使用--rm，当容器运行完后就被删除，常用于测试目的
[root@linux-node1 ~]# docker run --rm centos /bin/echo "test"
test

```    

## 守护态运行容器

更多的时候，需要让 Docker 在后台运行而不是直接把执行命令的结果输出在当前宿主机下。此时，可以通过添加 -d 参数来实现。

```bash
# 如果不使用 -d 参数运行容器
[root@linux-node1 ~]# docker run centos /bin/bash -c "while true; do echo hello world; sleep 1; done"
hello world
hello world
hello world
hello world
hello world
# 容器会把输出的结果(STDOUT)打印到宿主机上面

# 如果使用了 -d 参数运行容器
[root@linux-node1 ~]# docker run -d centos /bin/bash -c "while true; do echo hello world; sleep 1; done"
c303ceb3639b21564b82f09f006fff5eed1f842a7baa273b2314b9543c7e7c30

# 此时容器会在后台运行并不会把输出的结果(STDOUT)打印到宿主机上面(输出结果可以用docker logs 查看)。
[root@linux-node1 ~]# docker logs c303ceb3639b
hello world
hello world
hello world
hello world
hello world
hello world
hello world
...

注： 容器是否会长久运行，是和docker run指定的命令有关，和 -d 参数无关。

```    

# Ref
[ Installation on CentOS ](https://docs.docker.com/engine/installation/linux/centos/)  
[进入容器](https://yeasy.gitbooks.io/docker_practice/content/container/enter.html)  
[后台(background)运行](https://yeasy.gitbooks.io/docker_practice/content/container/daemon.html)  
