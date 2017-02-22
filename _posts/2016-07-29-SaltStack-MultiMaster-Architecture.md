---
layout: post
title: SaltStack  多 Master 架构
description: "SaltStack  多 Master 架构"
category: SaltStack
avatarimg:
tags: [SaltStack, MultiMaster]
duoshuo: true
---


Salt 支持一些高可用和容错特性。
如下：

* Multimaster
* Multimaster with Failover
* Syndic
* Syndic with Multimaster

本文说说 Multimaster，即多 Master 架构。

# Multimaster 简介

<pre>

Salt minions can connect to multiple masters at one time by configuring the master configuration parameter as
a YAML list of all the available masters. By default, all masters are ``hot'', meaning that any master can direct
commands to the Salt infrastructure.

In a multimaster configuration, each master must have the same cryptographic keys, and minion keys must be
accepted on all masters separately. The contents of file_roots and pillar_roots need to be kept in sync 
with processes external to Salt as well.

</pre>

多 Master 架构可以实现高可用，解决单点故障。  
配置多 Master 最重要的是共享 key 和 file_roots/pillar_roots。


# Multimaster 配置教程

## 0 配置步骤总结

* 1. 创建一个新增的 master 服务器
* 2. 复制主 master key 到 新增的 master
* 3. 启动新增的 master
* 4. 配置 minions 连接到新增的 master
* 5. 重启 minions
* 6. 在新增的 master 上接受 minions 的 keys

## 1 准备一个新增的 master 服务器

将主 master 上 /etc/salt/pki/master/ 里面的 master 的公私钥（master.pem、master.pub） 
复制到新增的 master 同样的目录下，然后启动新增的 master。

## 2 配置 Minions

在 Minions 的配置文件中 master 参数配置新增的 master，如：

```bash
master:
  - saltmater1.example.com
  - saltmater2.example.com
```    

然后重启 Minions

## 3 在 Masters 间共享文件

有如下类型的文件需要共享：

* Minions Keys
* Files_Roots 推荐使用 gitfs 作为文件服务器来共享 files
* Pillar_Roots
* Master Configurations

# Ref 
[HIGH AVAILABILITY FEATURES IN SALT](https://docs.saltstack.com/en/latest/topics/highavailability/index.html)  
[MULTI MASTER TUTORIAL](https://docs.saltstack.com/en/latest/topics/tutorials/multimaster.html)  

