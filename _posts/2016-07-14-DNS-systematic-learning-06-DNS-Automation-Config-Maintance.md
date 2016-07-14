---
layout: post
title: DNS 系统性学习 06 - DNS 自动化安装配置及维护
description: "DNS 系统性学习 06 - DNS 自动化安装配置及维护"
category: Network
avatarimg:
tags: [Network, DNS, BIND, bind-dlz]
duoshuo: true
---



# 1 使用 SaltStack 批量安装、部署

通过定制 SaltStack 配置，实现自动、批量安装、部署 DNS

# 2 配置管理自动化

业界使用最多的是 bind-dlz，dlz 是指将所有的配置都存放在 mysql 表中，对 bind 做特殊配置，  
使得每次 bind 接受的请求都去 mysql 中查询数据之后返回给用户。

# 3 bind-dlz 的优缺点

* 优点：将数据全部存放在数据中，符合运维开发理念
* 缺点：每次解析都要 select 数据库，性能低下；增加了系统耦合性，还需要保证 mysql 的高可用

# 4 另一种方案

* 采用 dlz 的数据库部分表结构
* 用 thinkphp 实现对 mysql 的增删查改，一些权限控制的页面，在该页面，用户可以完成对域名的增删查改操作，数据源在 mysql 中
* 通过 SaltStack + Python 实现从 mysql 中调取数据，生成 bind 的配置文件，并检测文件格式，之后 reload

以上方案的优点：将 DNS 做成了可交付和维护的系统，交付给应用运维使用，可以只负责 DNS 架构的 Server 端

[以下方案地址](https://github.com/shanks1127/dns)  

# 5 DNS 安全

* 时刻关注 DNS 的相关漏洞、补丁
* 选用大的域名服务商
* 对服务器的登录及操作日志做监控分析

# 6 日常运维规范

**DNS 作为基础服务，在做好高可用、高性能、好扩容的基础上，任何时刻都不能掉以轻心！**

* 确保所有监控均处于生效状态
* 所有新机器，都在 SaltStack 上完成初始化和安装、部署操作，不能单独操作
* 所有针对 DNS 架构调整的操作，均需在流量低谷时操作
* 对集群扩容操作时，务必对新加入节点做压测，同时重启服务器并检测重启后各项指标是否正常
* 关注 DNS 相关新闻，时刻跟进



