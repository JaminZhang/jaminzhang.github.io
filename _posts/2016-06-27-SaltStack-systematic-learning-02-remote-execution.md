---
layout: post
title: SaltStack 系统性学习 02 - 远程执行
description: "SaltStack 系统性学习 02 - 远程执行"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# Salt 远程执行

Salt 命令执行使用一个通用的结构，如下图：

![salt-cmd-syntax](https://docs.saltstack.com/en/getstarted/images/cmd-syntax.png)


使用 sys.doc 查询模块相关信息  

```bash
[root@linux-node1 ~]# salt '*' sys.doc sys.doc
sys.doc:

    Return the docstrings for all modules. Optionally, specify a module or a
    function to narrow the selection.

    The strings are aggregated into a single document on the master for easy
    reading.

    Multiple modules/functions can be specified.

    CLI Example:

        salt '*' sys.doc
        salt '*' sys.doc sys
        salt '*' sys.doc sys.doc
        salt '*' sys.doc network.traceroute user.info

    Modules can be specified as globs.

    New in version 2015.5.0

        salt '*' sys.doc 'sys.*'
        salt '*' sys.doc 'sys.list_*'
    
```    


## 运行 Shell 命令

使用 cmd.run

cmd.run 直接好用，但 Salt 远程执行更强大的是执行函数，这样不用写复杂的脚本来实现功能，而且返回的结果是格式化的，便于进一步处理。下面列举一些 执行函数。


## 检测 Minion 运行状态

使用 test.ping 
> 
Used to make sure the minion is up and responding. Not an ICMP ping.

## 显示磁盘用量

使用 disk.usage

## 安装一个软件包

使用 pkg.install

## 列出网络接口

使用 network.interfaces

更多执行模块请看 [EXECUTION MODULES](https://docs.saltstack.com/en/latest/ref/modules/all/index.html)  


# 深入学习远程执行

## Targeting 目标

用于指定哪些 Minion 来执行后面命令或模块函数

指定匹配 Minion 的方法可以分为两类：

* 和 minion id 有关的

	1. minion id (linux-node1.example.com)
	2. 通配符 (linux-node* | linux-node[1|2].example.com | linux-node?.example.com)
	3. 列表 (salt -L 'linux-node1.example.com,linux-node2.example.com' test.ping)
	4. 正则表达式 (salt -E 'linux-(node1|node2)*' test.ping)
	
* 和 minion id 无关的
	1. 子网/IP 地址 (salt -S 192.168.56.11 test.ping | salt -S 192.168.56.0/24 test.ping)
	2. Grains 匹配
	3. Compound matchers 混合匹配
	4. Node Group 分组匹配
	
	
主机名设置方案：

1. IP地址
2. 根据业务来进行设置
	redis-node1-redis03-idc03-soa.example.com
	* redis-node1 redis第一个节点
	* redis03 集群
	* idc03 机房
	* soa 业务线

## Execution Modules 执行模块

Salt 内置了丰富的执行模块，每一个模块都是一个 Python 文件，前面已举例。下面再列举一些。

```bash
salt '*' network.active_tcp
salt '*' network.arp

salt '*' service.available sshd
salt '*' service.get_all

salt-cp '*' /etc/hosts /tmp/

salt '*' state.single pkg.installed name=lsof

```    

## Returners 结果返回程序

将 Salt minion 返回的结果数据发送到其他的系统，比如数据库。  Returners 可以运行在 Minion 或 Master 上。


## 编写执行模块

可以自己可以需要编写自己的执行模块

# Ref
[EXECUTE COMMANDS](https://docs.saltstack.com/en/getstarted/fundamentals/remotex.html)  

