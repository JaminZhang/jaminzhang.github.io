---
layout: post
title: Salt Returners MySQL 配置实例
description: "Salt Returners MySQL 配置实例"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 引言
之前 Salt 远程执行的学习谈到了 Returners，现在我们来实际配置下 Returners。  
以下 Returners 例子是将 minion 的结果数据发送到 master 的 MySQL 数据库上。

# 1 Minion 上安装 MySQL-python

> 
To enable this returner, the minion will need the python client for mysql installed.

返回数据是 minion 直接返回的，所有的 minion 要装 Python 的 MySQL 客户端

使用 Salt 批量安装 MySQL-python
> 
salt '*' state.single pkg.installed name=MySQL-python

# 2 创建并初始化存放 Returners 数据的数据库

```bash

# 使用以下 sql 在 Master 上创建 salt 数据库及相关表

CREATE DATABASE  `salt`
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

USE `salt`;

--
-- Table structure for table `jids`
--

DROP TABLE IF EXISTS `jids`;
CREATE TABLE `jids` (
  `jid` varchar(255) NOT NULL,
  `load` mediumtext NOT NULL,
  UNIQUE KEY `jid` (`jid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX jid ON jids(jid) USING BTREE;

--
-- Table structure for table `salt_returns`
--

DROP TABLE IF EXISTS `salt_returns`;
CREATE TABLE `salt_returns` (
  `fun` varchar(50) NOT NULL,
  `jid` varchar(255) NOT NULL,
  `return` mediumtext NOT NULL,
  `id` varchar(255) NOT NULL,
  `success` varchar(10) NOT NULL,
  `full_ret` mediumtext NOT NULL,
  `alter_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `jid` (`jid`),
  KEY `fun` (`fun`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `salt_events`
--

DROP TABLE IF EXISTS `salt_events`;
CREATE TABLE `salt_events` (
`id` BIGINT NOT NULL AUTO_INCREMENT,
`tag` varchar(255) NOT NULL,
`data` mediumtext NOT NULL,
`alter_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`master_id` varchar(255) NOT NULL,
PRIMARY KEY (`id`),
KEY `tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# 创建及配置用户权限
grant all on salt.* to salt@'%' identified by 'salt@pw';
flush privileges;

mysql -h 192.168.56.11 -usalt -psalt@pw

```    
# 3 修改 Minion 配置文件

```bash
# 增加如下内容，支持 Returners MySQL:
mysql.host: '192.168.56.11'
mysql.user: 'salt'
mysql.pass: 'salt@pw'
mysql.db: 'salt'
mysql.port: 3306

# 修改配置文件需要重启 Minion
systemctl restart salt-minion
```   
# 4 检查 Returners MySQL 结果

```bash
[root@linux-node1 ~]# salt '*' test.ping --return mysql
linux-node1.example.com:
    True
linux-node2.example.com:
    True

MariaDB [salt]> select * from salt.salt_returns\G
*************************** 1. row ***************************
       fun: test.ping
       jid: 20160629174902075344
    return: true
        id: linux-node1.example.com
   success: 1
  full_ret: {"fun_args": [], "jid": "20160629174902075344", "return": true, "retcode": 0, "success": true, "fun": "test.ping", "id": "linux-node1.example.com"}
alter_time: 2016-06-29 17:49:02
*************************** 2. row ***************************
       fun: test.ping
       jid: 20160629174902075344
    return: true
        id: linux-node2.example.com
   success: 1
  full_ret: {"fun_args": [], "jid": "20160629174902075344", "return": true, "retcode": 0, "success": true, "fun": "test.ping", "id": "linux-node2.example.com"}
alter_time: 2016-06-29 17:49:02
2 rows in set (0.00 sec)
```    

# Ref
[SALT.RETURNERS.MYSQL](https://docs.saltstack.com/en/latest/ref/returners/all/salt.returners.mysql.html)  


