---
layout: post
title: SaltStack 系统性学习 05 - Grains 与 Pillar
description: "SaltStack 系统性学习 05 - Grains 与 Pillar"
category: SaltStack
avatarimg:
tags: [SaltStack, Grains, Pillar]
duoshuo: true
---

# 引言
Salt 有 2 个基本方面的系统数据：获取关于你的系统数据，配置数据给你的系统。  
Salt 提供 2 个不同的子系统来实现以下 2 种任务。它们就是 Grains 和 Pillar。  
还有一个第三方的组件，叫做 Mine，它是用于从一个 minion 推送数据
到一个共享存储，这个共享存储是在 master 上，可以被所有的 minions 访问。

# Grains

<pre>
Grains are used to get data about your systems. Grains are static information about the underlying operating system, memory, disks, and many other system properties.

Grains are gathered automatically when the minion starts and are refreshed periodically or by using a remote execution command.

So what can you do with grains? You can gather inventory using the grains execution module, which lets you list all grains, find systems with a specific grain value, and so on.

Grains are also an integral part of the targeting system. Grains are used to target salt states and Salt pillar data
</pre>

Grains 是静态数据，它是在 Minion 启动的时候收集的 Minion 本地的相关信息，如：操作系统版本，内核版本，CPU，内存，硬盘，设备型号，机器序列号。它可以做资产管理，只要不重启它，它就会只收集一次，当重启的时候才会再次收集，启动完后就不会变了,它是一个 key/value 的东西。

作用：  

* 资产管理、信息查询
* 用于目标选择（不同于 ID 的另外目标定义方法，操作系统等）
* 配置管理中使用


## 信息查询

```bash
salt 'linux-node1.example.com' grains.ls
salt 'linux-node1.example.com' grains.items
salt '*' grains.item os
salt '*' grains.item fqdn_ip4
```
## 目标选择

salt -G 选项

```bash
[root@linux-node1 ~]# salt -G 'os:CentOS' test.ping
linux-node2.example.com:
    True
linux-node1.example.com:
    True
[root@linux-node1 ~]# salt -G 'os:CentOS' cmd.run 'w'
linux-node1.example.com:
     14:28:23 up 3 days, 21:09,  1 user,  load average: 0.33, 0.28, 0.22
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    root     pts/0    192.168.56.1     Thu19    7.00s  0.38s  0.07s -bash
linux-node2.example.com:
     14:28:23 up 12:16,  1 user,  load average: 0.00, 0.01, 0.05
    USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
    root     pts/0    192.168.56.1     Thu19   19:02m  0.01s  0.01s -bash

```    

## 自定义 Grains

可以给某一个 minion 自定义一个 grains，然后再来找它，自定义方法：写到配置文件，有两种办法来存放它

### 1. /etc/salt/minion 配置 grains

```bash
vim /etc/salt/minion
grains:
  roles: apache 

systemctl restart salt-minion

[root@linux-node1 ~]# salt '*' grains.item roles
linux-node1.example.com:
    ----------
    roles:
        - apache
linux-node2.example.com:
    ----------
    roles:
        - apache

# 使用 grains 匹配重启所有 Apache
[root@linux-node1 ~]# salt -G 'roles:apache' cmd.run 'systemctl restart httpd'
linux-node2.example.com:
linux-node1.example.com:


# 生产环境不建议放在 minion 配置文件里面，写在 /etc/salt/grains 里面，minion 会自动来这找；并且上面这条命令中的 roles: 后面是没有空格的

```    

### 2. /etc/salt/grains 配置 grains

```bash
# 创建 /etc/salt/grains，在其中配置 grains
[root@linux-node1 ~]# cat /etc/salt/grains
roles: webserver

# 加完之后必须重启，因为它是静态的。但不重启也有一个刷新的命令 salt '*' saltutil.sync_grains
# 下面我们再加一个 grains item ，用 saltutil.sync_grains 命令刷新 grains

[root@linux-node1 ~]# cat /etc/salt/grains 
cloud: openstack
[root@linux-node1 ~]# salt '*' saltutil.sync_grains
linux-node1.example.com:
linux-node2.example.com:
[root@linux-node1 ~]# salt '*' grains.item cloud
linux-node2.example.com:
    ----------
    cloud:
        openstack
linux-node1.example.com:
    ----------
    cloud:
        openstack

# 注意：如果在 /etc/salt/minion 和 /etc/salt/grains 中定义同名但值不同的 grains item，在 /etc/salt/minion 配置的生效
# 后面会讲到 grains 的优先级

```    

### 3. 在 top.sls 中使用 grains

```bash
base:
  'linux-node1.example.com':
    - web.apache
  'linux-node2.example.com':
    - web.apache
  'roles:apache':
    - match: grain
    - web.apache
```    

### 4. 可以自己用 Python 脚本来写一个 grains，实现动态
上面说的动态意思是通过逻辑后产生的

Grains Python 脚本放置目录：/srv/salt/_grains (不存在时创建一下)

脚本例子如下：

```bash
[root@linux-node1 _grains]# cat  my_grains.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

def my_grains():
    # 初始化一个 grains 字典
    grains = {}
    # 设置字典中的 key/value
    grains['iaas'] = 'openstack'
    grains['edu'] = 'example'
    # 返回这个字典
    return grains

# 把 grains 推送给 minion
[root@linux-node1 _grains]# salt '*' saltutil.sync_grains
linux-node1.example.com:
    - grains.my_grains
linux-node2.example.com:
    - grains.my_grains

# my_grains.py 会放在/var/cache/salt/minion/extmods/grains/

# 查看 grains item
[root@linux-node1 _grains]# salt '*' grains.item iaas
linux-node2.example.com:
    ----------
    iaas:
        openstack
linux-node1.example.com:
    ----------
    iaas:
        openstack
[root@linux-node1 _grains]# salt '*' grains.item edu
linux-node1.example.com:
    ----------
    edu:
        example
linux-node2.example.com:
    ----------
    edu:
        example	

```    

### 5. Grains优先级

1. 系统自带
2. /etc/salt/grains 文件中配置
3. /etc/salt/minion 文件中配置
4. 自定义的 grains 模块中定义

# Pillar

<pre>
Salt pillar is used to deliver data to your systems. Think about the different custom data needed when configuring even a simple system: user names, service URLs, preferred installation paths, ports, non-default application settings, and many others. Often these values are different for each system or system role (web, database, and so on).

Salt pillar lets you define these data values and then assign them to one or more minions using targets. The values can then be inserted into Salt states using variables.

Salt pillar data is encrypted using the targeted minion’s public key and sent over a secure channel, so Salt pillar is also well-suited to distribute secure data such as passwords and ssh keys since it can be decrypted only by the targeted minion. Salt pillar data is never written to disk on the minion.

The default Salt pillar module defines pillar using a YAML file, though over 30 Salt pillar modules (aka plug-ins) are available to support a wide-variety of backends. Popular options include Mongo and Redis, which are both designed to store structured data. Many users stick with YAML files, but use a private git repo to manage and distribute the pillar data.
</pre>


pillar 也是 key/value，但是 pillar 数据是动态的，和 minion 启不启动没关系，它给特定的 minion 指定特定的数据，跟 top file 很像。只有指定的 minion 自己能看到自己的数据。

使用：  
>
# 查看pillar条目  
salt '*' pillar.items

## 1 在 Salt Master 上开启 pillar 及配置 pillar_roots

```bash
在 /etc/salt/master 中配置 pillar_roots
pillar_roots:
  base:
    - /srv/pillar
 pillar_opts: True
# 修改配置文件 /etc/salt/master 后要重启 master 
[root@linux-node1 pillar]# systemctl restart salt-master

```   

## 2 创建一个 pillar 的 sls apache.sls


## 3 配置 pillar 的 top file

编辑 top file(pillar 必须要写 top file，不像配置管理不用也可以)

```bash
vim /srv/pillar/top.sls
base:
  'linux-node2*':
    - web.apache
```    
## 4 刷新 pillar 并测试获取 pillar item

```bash
[root@linux-node1 pillar]# salt '*' saltutil.refresh_pillar
linux-node2.example.com:
    True
linux-node1.example.com:
    True
[root@linux-node1 pillar]# salt '*' pillar.items apache
linux-node2.example.com:
    ----------
    apache:
        httpd
linux-node1.example.com:
    ----------
    apache:
```    


# Grains VS Pillar

|      | 类型 | 数据采集方式   | 应用场景 | 定义位置 |
|------|------|----------------|----------|--------- |
|Grains| 静态 | minion 启动时收集 | 数据查询、目标选择、配置管理 | minion 端 |
|Pillar| 动态 | master 自定义 | 目标选择、配置管理、敏感数据存储 | master 端 |


# Ref
[Salt DATA](https://docs.saltstack.com/en/getstarted/system/data.html)
