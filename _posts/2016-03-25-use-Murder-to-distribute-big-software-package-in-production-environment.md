---
layout: post
title: Murder 在生产环境中分发大软件包的应用
description: "Murder 在生产环境中分发大软件包的应用"
category: P2P
avatarimg:
tags: [Murder, P2P, Production]
duoshuo: true
---

# 引言

Murder 经过之前的调研测试后，已经在线上正式使用了。

# 为什么要使用 P2P 方式分发软件包

800 台左右机器，要分发的软件包在 80M 左右，在之前的分发方式下（下载服务器只有一台，出口带宽为共享 100M，不适用于分发大文件到大量服务器），
分发这些大的更新包到这 800 台机器，需要多次分发才能成功（带宽不足，下载拥塞），耗费时间 40 分钟到 1 小时，非常影响更新效率。
所以考虑使用 P2P 方式来给大量机器分发大文件。使用的工具为 Twitter 的开源工具 Murder（主要使用它封装好的 BT 下载工具）。

# 实测数据

分发 80M 文件到 800 台机器，P2P 方式耗时 2 分钟 29 秒，大大提高了大文件的分发速度。  
(PS：Murder 作者说他们 Twitter 当时提升是 75 倍！！我推测可能是它们使用内网的原因，我们这边使用的外网，因为机器在各个不同的机房。)

# 架构图
![Murder-Arch](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Murder-Arch-01.png)

# Murder 在大软件包分发中的手动步骤

## 0、准备工作

确保游戏服上安装好 murder 软件包  
我已将 https://github.com/lg/murder/tree/master/dist 再加上一些脚本打包成了 rpm 放在公司内部 yum 源上了 

>
yum install murder -y

## 1、启动 Tracker 服务器

```bash
python /usr/local/murder/dist/murder_tracker.py > /var/log/murder_tracker.log 2>&1 &
```    

确保 Tracker 服务器启动状态

## 2、在 Seeder 服务器（和 Tracker 服务器是同一台）上准备好要分发的文件并创建种子

准备好要分发的文件，放置在 Seeder 服务器上 `/data/upload` 目录下

生成种子文件手动命令：

```bash
deploy_file=/data/upload/deploy.test.tar.gz
python /usr/local/murder/dist/murder_make_torrent.py ${deploy_file} ${Seeder_IP}:8998 ${deploy_file}.torrent
```    

## 3、启动 Seeder 服务器  

启动 Seeder 服务器手动命令：

```bash
python /usr/local/murder/dist/murder_client.py seed ${deploy_file}.torrent ${deploy_file} 127.0.0.1
```    

要确保 Seeder 服务器在启动状态，否则 Peer 节点下载时连接不到。

## 4、下载节点 Peer 执行下载

4.1 将 Seeder 服务器上 `/data/upload/` 下刚才生成的种子文件上传到要分发文件去的目标服务器上  
4.2 种子文件上传完成后，在目标服务器上执行 P2P 下载命令  

```bash
python /usr/local/murder/dist/murder_client.py peer /data/download/deploy.tar.gz.torrent /data/download/deploy.tar.gz ${Peer_IP}
```    

## 5、文件下载完成后，关闭 Seeder 服务器进程

`kill Seeder进程PID`
避免它一直做种和提升安全性。

以上就是分发软件包的整个流程。

可以将上面的操作结合进自己的自动化运维平台。

# 安全相关

主要重点保证 Seeder 服务器的安全，因为要分发的文件首先放置在上面。
Peer 节点下载完成后默认上传 1 分钟后（可调整）就退出进程了。
基础安全要做好，防止服务器上的种子和文件泄露；每次文件发布完成后，关闭 Seeder 服务器的对应的上传进程。


# Ref
[Twitter 的大规模文件 P2P 分发系统-Murder](http://jaminzhang.github.io/linux/Twitter-Murder-a-large-scale-file-distribute-system-via-p2p/)  
[Murder 下载测试](http://jaminzhang.github.io/linux/Murder-download-test/)  
