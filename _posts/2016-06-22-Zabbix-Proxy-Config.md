---
layout: post
title: Zabbix 配置 Proxy 代理监控
description: "Zabbix 配置 Proxy 代理监控"
category: Monitoring
avatarimg: 
tags: [Zabbix, Zabbix-Proxy]
duoshuo: true
---


# Zabbix Proxy 介绍

<pre>

Zabbix Proxy 可以代替 Zabbix Server 检索客户端的数据，然后把数据汇报给 Zabbix Server，
并且在一定程度上分担了 Zabbix Server 的压力。Zabbix Proxy 可以非常简便的实现了集中式、分布式监控。
Zabbix Proxy 使用场景:
	监控远程区域设备
	监控本地网络不稳定区域
	当 Zabbix 监控上千设备时，使用它来减轻 Server 的压力
	简化 Zabbix 的维护
	
Zabbix Proxy 仅仅需要一条 TCP 连接到 Zabbix Server，所以防火墙上仅仅需要加上一条规则即可。
Zabbix Proxy 数据库必须和 Zabbix Server 分开，否则数据会被破坏，毕竟这两个数据库的表大部分都相同。
总之记住，数据库分开即可。
Zabbix Proxy 收集到数据之后，首先将数据缓存在本地，然后在一定的时间之后传递给 Zabbix Server。
这个时间由 Zabbix Proxy 配置文件中参数 ProxyLocalBuffer and ProxyOfflineBuffer 决定。	

Zabbix Proxy 是一个数据收集器，它不计算触发器、不处理事件、不发送报警。

</pre>

# 1. 安装 Zabbix Proxy

`yum install mariadb-server zabbix-proxy-mysql`

# 2. 创建及初始化数据库

```bash

# 启动数据库
systemctl start mariadb

# 创建配置 Zabbix Proxy 数据库及用户
create database zabbix_proxy character set utf8 collate utf8_bin;
grant all privileges on zabbix_proxy.* to zabbix_proxy@localhost identified by 'zabbix_proxy';
flush privileges;

# 导入 sql
cd /usr/share/doc/zabbix-proxy-mysql-3.0.3
zcat schema.sql.gz | mysql -uroot zabbix_proxy

```    

# 3. 配置 zabbix_proxy.conf

配置如下：

```bash

[root@linux-node2 ~]# grep "^[a-Z]" /etc/zabbix/zabbix_proxy.conf 
Server=192.168.56.11
Hostname=Zabbix proxy
LogFile=/var/log/zabbix/zabbix_proxy.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_proxy.pid
DBHost=localhost
DBName=zabbix_proxy
DBUser=zabbix_proxy
DBPassword=zabbix_proxy
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000

```    

# 4. 启动 Zabbix Proxy 服务

`systemctl start zabbix-proxy`

# 5. 在 Zabbix Web 界面中配置 Zabbix Proxy

定位到 `Administration -> Proxies -> Create proxy`
主要配置如下选项：

* Proxy name: 即 Zabbix Proxy 的 hostname
* Proxy mode: 即 Zabbix Proxy 的工作模式，默认为主动模式
* Hosts Proxy hosts: 选择哪些机器处于 Proxy 模式

# 6. 添加 Proxy 架构的主机监控

添加主机的方式和正常模式一样，唯一不同的是 `Monitored by proxy` 选择对应的 Proxy 节点。

*注意*  
如果是已经存在的没有被 Proxy 监控的节点，修改成被 Proxy 代理监控时，  
需要修改 Zabbix Agent 配置文件，将 `Server/ServerActive` 配置成 Proxy 的 IP

# Ref
[Zabbix Proxy 分布式监控配置（45）](http://www.ttlsa.com/zabbix/zabbix-proxy-proxies/)  
