---
layout: post
title: SaltStack Syndic 架构
description: "SaltStack Syndic 架构"
category: SaltStack
avatarimg:
tags: [SaltStack, Syndic]
duoshuo: true
---

# SaltStack Syndic 介绍

我们使用多 Mater 的功能解决了 Master 单点故障的问题，那么保证高可用之后，我们接下来要考虑的就是性能了，  
是的，如果你管理的 Minion 数以万计，一个 Master 可能就有一些吃力了，我们需要更加灵活的架构，那么该 Salt Syndic 出场了。  

一个基本的 Salt 配置方式是一个 Master 管理一群 Minion，这就是单一的拓扑结构。那么为了增加多种拓扑架构的支持，Salt 在 0.9.0 版本中加入了 Salt Syndic。Syndic 建立在中心 Master 和 Minions 之间，并允许多层分级 Syndic。  

Syndic 运行在一个 Master 上，并且连接到另外一个 Master（比它更高级别，我们后面称之为“高级 Master”），这里需要强调的是 Syndic 必须运行在一个 Master 上。  

然后 Syndic Minion 所连接的高级 Master 就可以控制连接到运行 Syndic 的 Master 上 的 Minion。这句话稍有点绕，如果一下子没明白，先加深点记忆“Syndic 必须运行在一个 Master 上”，然后再回过头看就好理解了。  

# 1 Syndic 配置

Syndic 对于它管理的 Minion 来说，就是一个 Master 节点，所以 Syndic 没有自己的配置文件，它是 Salt Master 的一个组件：  

```bash
[root@linux-node1 ~]# yum install salt-syndic -y
[root@linux-node1 ~]# vim /etc/salt/master
syndic_master: 192.168.56.12	# 设置为高级 Master 的 IP
[root@linux-node1 ~]# systemctl restart salt-master
[root@linux-node1 ~]# systemctl start salt-syndic
```    

# 2 高级 Master 配置

高级 Master 需要使用 order_masters 参数来进行开启：

```bash
[root@linux-node2 ~]# yum install salt-master -y
[root@linux-node2 ~]# grep "order_masters" /etc/salt/master
order_masters: True
[root@linux-node1 ~]# systemctl start salt-master
```    

启动之后，在高级 Master 上通过 salt-key 可以看到，Salt Syndic 已经连接上来了，在前面我们提到过 Syndic 节点对于它管理的 Minion 来说就是一个 Master，但是 Syndic 对于高级 Master 来说，它却是一个特殊的 Minion：

```bash
[root@linux-node2 ~]# salt-key -L
Accepted Keys:
Denied Keys:
Unaccepted Keys:
linux-node1.example.com
Rejected Keys:
```    

# 3 Syndic 测试

高级 Master 可以控制一群同时运行着“syndic 和 master”的节点，通过 Syndic 将操作命令传输给受控 Master，受控 Master 来完成对自己旗下 Minion 的管理，并将结果传回高级 Master，从而实现高级 Master 对所有 Minion 的间接管理。  

高级 Master 同意 Syndic 节点的连接后，使用 test.ping 就可以看到，高级 Master 可以管理所有连接到 Syndic 上面的 Minion：

```bash
[root@linux-node2 ~]# salt-key -A
[root@linux-node2 ~]# salt '*' test.ping
linux-node1.example.com:
    True
linux-node2.example.com:
    True
```    

# 4 Syndic 是如何工作的

Syndic 本质上是一个特殊的 Minion，其代码就位于 minion.py 中。
Syndic 需要在本地运行 Master，并将需要管理的 Minions 的 Master 指向 Syndic 所在的主机。Syndic 是这么来工作的：

* 冒充 Minion，建立与高级别的 Master 的连接，订阅所有来自高级 Master 下发的任务。
* 接收高级 Master 下发的数据后，首先进行解密，解密完成后，将其扔到本地的 Master 接口上进行二次下发。
* Syndic 在进行二次下发之后，监听本地 Event 接口，获取所管理的 Minions 的返回。
* 将返回发送给高级 Master。

# 5 Syndic 的优缺点

没有真正完美的架构，使用 Syndic 虽然可以建立多层的 Salt 拓扑，但也是有利有弊，需要使用者根据实际的需求进行权衡。

## 优点

* 通过 Syndic，可以建立多层级的 Salt 拓扑，Syndic 下的 Minions 即可通过 Syndic 所在的 Master 进行管理，也可以通过高级 Master 进行管理，架构变得异常灵活。
* 由于 Syndic 只订阅高级 Master 下发下来的任务，对于文件服务等，Syndic 本地进行配置，可以有效地降低高级 Master 的负载。

## 缺点

* 需要保证 Syndic 上的 file_roots 及 pillar_roots 与高级 Master 是一致的。
* 由于 Syndic 管理了旗下 Minions 的认证，这样高级 Master 并不知道有多少 Syndic 主机，Syndic 下边有多少 Minions。
在高级 Master 上使用 Salt 命令行下发远程执行命令时，**如果 Syndic 此时与高级 Master 网络之间有抖动，导致没有收到消息或延迟收到消息，
高级 Master 并不知情。Syndic 并没有返回结果或延迟返回结果，高级 Master 并不能感知到，会导致结果不完整。**
如果没有其他验证机制，结果将变得不可控。官方提供的解决方案是增大 syndic_wait 选项，但是只能缓解，并不能根治问题。

## 建议
没有系统或工具是 100% 可靠的。基于这一观点，无论是否使用 Salt 的架构扩展，对于运维使用 SaltStack 来说，
如果能从流程上对每次 SaltStack 的执行结果进行检查和验证，是比较稳妥的方案，可能也算是比较保守吧。




# 遇到的问题

1.使用之前配置的环境，linux-node1 是无 Master 架构，还有其他报错。

处理方法：最简化 Salt Master 和 Minion 的配置，排除其他原因。

```bash
[root@linux-node1 ~]# cat /etc/salt/master
syndic_master: 192.168.56.12
[root@linux-node1 ~]# cat /etc/salt/minion
master: 192.168.56.11

[root@linux-node2 ~]# cat /etc/salt/master
order_masters: True
[root@linux-node2 ~]# cat /etc/salt/minion
master: 192.168.56.11
```   

2.经过第 1 步处理，还有如下报错：

```bash
[root@linux-node1 ~]# systemctl status salt-syndic
● salt-syndic.service - The Salt Master Server
   Loaded: loaded (/usr/lib/systemd/system/salt-syndic.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Mon 2016-08-01 18:45:20 CST; 11s ago
  Process: 22082 ExecStart=/usr/bin/salt-syndic (code=exited, status=1/FAILURE)
 Main PID: 22082 (code=exited, status=1/FAILURE)

Aug 01 18:45:20 linux-node1.example.com salt-syndic[22082]: [ERROR   ] The master key has changed, the salt master could have been subverted, verify salt master's public key
Aug 01 18:45:20 linux-node1.example.com salt-syndic[22082]: [CRITICAL] The Salt Master server's public key did not authenticate!
Aug 01 18:45:20 linux-node1.example.com salt-syndic[22082]: The master may need to be updated if it is a version of Salt lower than 2016.3.1, or
Aug 01 18:45:20 linux-node1.example.com salt-syndic[22082]: If you are confident that you are connecting to a valid Salt Master, then remove the master public key and restart the Salt Minion.
Aug 01 18:45:20 linux-node1.example.com salt-syndic[22082]: The master public key can be found at:
Aug 01 18:45:20 linux-node1.example.com salt-syndic[22082]: /etc/salt/pki/minion/syndic_master.pub
Aug 01 18:45:20 linux-node1.example.com salt-syndic[22082]: Invalid master key
Aug 01 18:45:20 linux-node1.example.com systemd[1]: salt-syndic.service: main process exited, code=exited, status=1/FAILURE
Aug 01 18:45:20 linux-node1.example.com systemd[1]: Unit salt-syndic.service entered failed state.
Aug 01 18:45:20 linux-node1.example.com systemd[1]: salt-syndic.service failed.


# 以上错误提示 master key 改变了，可以尝试移除 master 公钥，然后重启 minion

[root@linux-node1 ~]# ll /etc/salt/pki/minion/
total 16
-rw-r--r-- 1 root root  450 Jun 29 15:48 minion_master.pub
-r-------- 1 root root 1674 Jun 29 15:48 minion.pem
-rw-r--r-- 1 root root  450 Jun 29 15:48 minion.pub
-rw-r--r-- 1 root root  450 Aug  1 15:59 syndic_master.pub		# 这个 master 公钥是之前配置生成的，需要删除
[root@linux-node1 ~]# rm -f /etc/salt/pki/minion/syndic_master.pub 
[root@linux-node1 ~]# systemctl restart salt-syndic

[root@linux-node1 ~]# ll /etc/salt/pki/minion/
total 16
-rw-r--r-- 1 root root  450 Jun 29 15:48 minion_master.pub
-r-------- 1 root root 1674 Jun 29 15:48 minion.pem
-rw-r--r-- 1 root root  450 Jun 29 15:48 minion.pub
-rw-r--r-- 1 root root  450 Aug  1 18:59 syndic_master.pub		# 重启 salt-syndic 后，master 公钥重新生成了

```    

# Ref
[SALT SYNDIC](https://docs.saltstack.com/en/latest/topics/topology/syndic.html)  
