---
layout: post
title: SaltStack 系统性学习 01 - 简介及安装
description: "SaltStack 系统性学习 01 - 简介及安装"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 简介

> 
Salt is a new approach to infrastructure management built on a dynamic communication bus.   
Salt can be used for data-driven orchestration, remote execution for any infrastructure,   
configuration management for any app stack, and much more.  

> 
SaltStack 是用 Python 语言编写的，提供了 API、支持多种操作系统（所有类 Unix 系统都默认安装 Python），Windows 只能安装 Minion 端程序。

SaltStack 三大功能：

* 远程执行
* 配置管理（状态很难回滚，可以管理静态文件）
* 云管理

SaltStack 四种运行方式：

* Local
* Master/Minion（传统 C/S 架构）
* Syndic（对应于 Zabbix 的 Proxy)
* Salt SSH （AGENTLESS SALT）

# 安装配置

## 安装
使用 yum 方式，比较简单

```bash
yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el7.noarch.rpm -y

yum install salt-master -y

yum install salt-minion -y
```    
## 配置及启动

```bash
systemctl start salt-master

sed -i 's/# master: salt/master: 192.168.56.11/' /etc/salt/minion
systemctl start salt-minion
```    

另外一个重要的参数就是 minion_id，每个 minion 都有一个单独的 ID，它放在 /etc/salt 目录下，如果不配置的话，默认就是主机名。

*minion_id 命名规则*   
根据业务（生产环境的参考例子）：

* 游戏业务： 使用 IP
* 电商业务： 使用 域名

# Minion 与 Master 的认证

Minion 启动后和 Master 连接，相互交换公钥后就完成了认证过程。   
注意 minion id 更改的影响，需要重新认证。

salt-key 是 Master 上来执行管理用于认证的 Minion 公钥的命令。  
具体用法请 man salt-key。

关于 SaltStack 相关概念、架构及组件参考 Ref 中的官网文档，里面有不少图例说明不错。

# Ref
[SaltStack Get Started](https://docs.saltstack.com/en/getstarted/)  
[Install SaltStack](https://repo.saltstack.com/#rhel)  

