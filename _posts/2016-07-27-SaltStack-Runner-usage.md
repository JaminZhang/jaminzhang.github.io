---
layout: post
title: SaltStack Runner 使用
description: "SaltStack Runner 使用"
category: SaltStack
avatarimg:
tags: [SaltStack, Runner]
duoshuo: true
---

# Salt runner 简介

Salt Runners 是使用 salt-run 命令执行的方便的应用。

Salt Runners 工作类似于 Salt 执行模块，但它们是在 Salt Master 上执行的，而不是在远程的 Salt Minions 上。

一个 Salt Runner 可以是一个简单的客户端调用或者一个复杂的应用。

## RUNNER MODULES 

[RUNNER MODULES](https://docs.saltstack.com/en/latest/ref/runners/all/index.html#all-salt-runners)  

### manage 模块 

用于 salt 的通用管理功能，比如查看主机在线或宕机

* salt-run manage.status
* salt-run manage.up
* salt-run manage.down
* salt-run manage.versions

举例如下：

```bash
[root@linux-node1 ~]# salt-run manage.status
down:
up:
    - linux-node1.example.com
    - linux-node2.example.com
[root@linux-node1 ~]# salt-run manage.up
- linux-node1.example.com
- linux-node2.example.com
[root@linux-node1 ~]# salt-run manage.down
[root@linux-node1 ~]# salt-run manage.versions
Master:
    2016.3.1
Up to date:
    ----------
    linux-node1.example.com:
        2016.3.1
    linux-node2.example.com:
        2016.3.1

```    

### job 模块

用于管理任务，活动的和已经运行过的任务

* salt-run jobs.active
* salt-run jobs.list_jobs
* salt-run jobs.lookup_jid jid
* salt-run jobs.print_job jid


# 编写 Salt Runners

# Ref
[RUNNERS](https://docs.saltstack.com/en/latest/ref/runners/)  

