---
layout: post
title: Docker 数据管理
description: "Docker 数据管理"
category: Docker
avatarimg:
tags: [Docker, Volumes]
duoshuo: true
---


Docker 数据管理

Docker 可以做持久化的数据保存，在容器中管理数据主要有两种方式：

* 数据卷（Data volumes）
* 数据卷容器（Data volume containers）

# 数据卷

数据卷是一个可供一个或多个容器使用的特殊目录，它绕过 UFS，可以提供很多有用的特性：

* 数据卷可以在容器之间共享和重用
* 对数据卷的修改会立马生效
* 对数据卷的更新，不会影响镜像
* 数据卷默认会一直存在，即使容器被删除

>
注意：数据卷的使用，类似于 Linux 下对目录或文件进行 mount，镜像中的被指定为挂载点的目录中的文件会隐藏掉，能显示看的是挂载的数据卷。

数据卷配置的命令参数有如下 2 种：

* -v dst		直接指定容器中目标目录
* -v src:dst	指定本地主机源目录和容器中的目标目录

## 直接指定容器中目标目录

```bash

# 运行一个数据卷的测试容器，直接指定容器中目标目录
[root@linux-node1 ~]# docker run -d --name nginx-volume-test1 -v /data/ nginx
9e061b675f1a896101799d3426ab4e7f06add98c81425929e5d190e2d8a57b14

# 进入容器查看 /data 目录
[root@linux-node1 ~]# ./docker_in.sh nginx-volume-test1
root@9e061b675f1a:/# ls /data/
root@9e061b675f1a:/# 

# 容器中 /data 目录为空，如何知道此目录对应的本地文件系统目录？
# 可以使用 docker inspect 命令获取，如下：
[root@linux-node1 ~]# docker inspect -f {{.Mounts}} nginx-volume-test1
[{71b93b8e6130801826910d3c2ee6db108d2d577bab55937846029d83b78b2e01 /var/lib/docker/volumes/71b93b8e6130801826910d3c2ee6db108d2d577bab55937846029d83b78b2e01/_data /data local  true }]

# 进入对应的本地文件系统目录并创建测试文件 
[root@linux-node1 ~]# cd /var/lib/docker/volumes/71b93b8e6130801826910d3c2ee6db108d2d577bab55937846029d83b78b2e01/_data
[root@linux-node1 _data]# ll
total 0
[root@linux-node1 _data]# touch test1

# 在容器可以看到上面刚创建的文件
root@9e061b675f1a:/# ls /data/
test1

```    

## 指定本地主机源目录和容器中的目标目录

注意：Dockerfile 中不支持这种用法，这是因为 Dockerfile 是为了移植和分享用的。  
然而，不同操作系统的路径格式不一样，所以目前还不能支持。

```bash

[root@linux-node1 ~]# mkdir -p /data/docker-volume-nginx
[root@linux-node1 ~]# docker run -d --name nginx-volume-test2 -v /data/docker-volume-nginx/:/data nginx
6d2046d642d7651aec99c5cc88c52966a7f017a51a53561297d0040eecb63071

# 进入容器后创建测试文件
[root@linux-node1 ~]# ./docker_in.sh nginx-volume-test2
root@6d2046d642d7:/# cd /data/
root@6d2046d642d7:/data# touch test2

# 在对应的本地文件系统目录查看到刚创建的文件
[root@linux-node1 ~]# ls /data/docker-volume-nginx/
test2

# 可以进行只读挂载，在目标目录后加上 ro 参数，如下：
[root@linux-node1 ~]# docker run -d --name nginx-volume-test3 -v /data/docker-volume-nginx/:/data:ro nginx
868a9e6b7aa0d72a9a48145cd82d122fe261dfcce645a27f71b334dac8b50a3b
[root@linux-node1 ~]# ./docker_in.sh nginx-volume-test3
root@868a9e6b7aa0:/# ls /data/
test2
root@868a9e6b7aa0:/# cd /data/
root@868a9e6b7aa0:/data# touch test3
touch: cannot touch 'test3': Read-only file system
```    

## 挂载文件

```bash

[root@linux-node1 ~]# docker run --rm -it -v /root/.bash_history:/.bash_history nginx /bin/bash
# --rm 当退出容器时会自动删除容器，常用于测试目的
root@b8aa1ce69bbc:/# cat /.bash_history 
...文件内容省略...

```    

# 数据卷容器

如果你有一些持续更新的数据需要在容器之间共享，最好创建数据卷容器。  
数据卷容器，其实就是一个正常的容器，专门用来提供数据卷供其它容器挂载的。

```bash

# 运行一个容器，引用之前创建的 nginx-volume-test2 容器中挂载的卷
[root@linux-node1 ~]# docker run -it --name volume-test --volumes-from nginx-volume-test2 centos /bin/bash
[root@fa89f37d06f0 /]# ls /data/
test2

# 使用 --volumes-from 参数所挂载数据卷的容器自己并不需要保持在运行状态，如下，容器停掉后还能正常使用卷
[root@linux-node1 ~]# docker stop nginx-volume-test2
nginx-volume-test2
[root@fa89f37d06f0 /]# touch /data/test2-1
[root@fa89f37d06f0 /]# ls /data/test2-1
/data/test2-1

# 下面再创建一个 nfs-test 的数据卷容器
[root@linux-node1 ~]# docker run -d --name nfs-test -v /data/nfs-data:/data nginx
ed81da17ee16df1ce1d8bdc712c0a3508e25e8fd57f5a50fb8bdaa59ff0caa2e

# 创建一个测试容器引用上面的数据卷容器
docker run --rm -it --volumes-from nfs-test centos /bin/bash
# 创建测试文件 
[root@538885f1397d /]# touch /data/test
# 在本地文件系统对应目录中可以看到刚才创建的测试文件
[root@linux-node1 ~]# ls /data/nfs-data/
test

```    

# Ref
[数据卷](https://yeasy.gitbooks.io/docker_practice/content/data_management/volume.html)  
[数据卷容器](https://yeasy.gitbooks.io/docker_practice/content/data_management/container.html)  
