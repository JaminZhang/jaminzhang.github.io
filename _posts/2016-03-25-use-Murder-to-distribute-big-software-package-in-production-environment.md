---
layout: post
title: Murder在生产环境中分发大软件包的应用
description: "Murder在生产环境中分发大软件包的应用"
category: Linux
avatarimg:
tags: [Murder, P2P]
duoshuo: true
---

# 引言
Murder经过之前的调研测试后，已经在线上正式使用了。

# 为什么要使用P2P方式分发软件包
800台左右机器，要分发的软件包在80M左右，在之前的分发方式下（下载服务器只有一台，不适用于分发大文件到大量服务器），
分发这些大的更新包到这800台机器，需要多次分发才能成功（一次处理不了如此多的下载请求），耗费时间40分钟到1小时，非常影响更新效率。
所以考虑使用P2P方式来给大量机器分发大文件。使用的工具为Twitter的开源工具Murder（主要使用它封装好的BT下载工具）。

# 实测数据
分发80M文件到800台机器，P2P方式耗时2分钟29秒，大大提高了大文件的分发速度。  
(PS：Murder作者说他们Twitter当时提升是75倍！！我推测可能是它们使用内网的原因，我们这边使用的外网，因为机器在各个不同的机房。)

# 架构图
![Murder-Arch](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Murder-Arch-01.png)

# Murder在大软件包分发中的手动步骤

**0、准备工作**

确保游戏服上安装好murder软件包  
我已将https://github.com/lg/murder/tree/master/dist 再加上一些脚本打包成了rpm放在公司内部yum源上了 

yum install murder -y

**1、启动Tracker服务器**

```bash
python /usr/local/murder/dist/murder_tracker.py > /var/log/murder_tracker.log 2>&1 &
```    

确保Tracker服务器启动状态

**2、在Seeder服务器（和Tracker服务器是同一台）上准备好要分发的文件并创建种子**

准备好要分发的文件，放置在Seeder服务器上/data/upload目录下

生成种子文件手动命令：

```bash
deploy_file=/data/upload/deploy.test.tar.gz
python /usr/local/murder/dist/murder_make_torrent.py ${deploy_file} ${Seeder_IP}:8998 ${deploy_file}.torrent
```    

**3、启动Seeder服务器**  

启动Seeder服务器手动命令：

```bash
python /usr/local/murder/dist/murder_client.py seed ${deploy_file}.torrent ${deploy_file} 127.0.0.1
```    

要确保Seeder服务器在启动状态，否则Peer节点下载时连接不到。

**4、下载节点peer执行下载**  

4.1 将Seeder服务器上/data/upload/下刚才生成的种子文件上传到要分发文件去的目标服务器上  
4.2 种子文件上传完成后，在目标服务器上执行P2P下载命令  

```bash
python /usr/local/murder/dist/murder_client.py peer /data/download/deploy.tar.gz.torrent /data/download/deploy.tar.gz ${Peer_IP}
```    

**5、文件下载完成后，关闭Seeder服务器进程**  

kill Seeder进程PID
避免它一直做种和提升安全性。

以上就是分发软件包的整个流程。

可以将上面的操作结合进自己的自动化运维平台。

# 安全相关
主要重点保证Seeder服务器的安全，因为要分发的文件首先放置在上面。
Peer节点下载完成后默认上传1分钟后（可调整）就退出进程了。
基础安全要做好，防止服务器上的种子和文件泄露；每次文件发布完成后，关闭Seeder服务器的对应的上传进程。


# Ref
[Twitter的大规模文件P2P分发系统-Murder](http://jaminzhang.github.io/linux/Twitter-Murder-a-large-scale-file-distribute-system-via-p2p/)  
[Murder下载测试](http://jaminzhang.github.io/linux/Murder-download-test/)  
