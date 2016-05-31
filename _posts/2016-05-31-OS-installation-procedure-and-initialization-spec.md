---
layout: post
title: 操作系统安装流程及初始化规范
description: "操作系统安装流程及初始化规范"
category: Automated Ops
avatarimg:
tags: [OS, Standard]
duoshuo: true
---

# 操作系统安装流程及初始化规范

>    V1.0    


## 操作系统安装流程


1. 服务器采购
2. 服务器验收并设置 RAID
3. 服务商提供验收单，运维验收负责人签字。
4. 服务器上架
5. 资产录入。
6. 开始自动化安装。  
	1. 将新服务器划入装机 VLAN
	2. 根据资产清单上的 MAC 地址，自定义安装。
		1.机房 2. 机房区域 3. 机柜  4. 服务器位置  5. 服务器网线接入端口  6. 该端口 MAC 地址    	
		7.profile ks.cfg 中指定操作系统 分区等、预分配的 IP 地址、主机名、子网、网关、DNS、角色等。
		
	3. 自动化装机平台，安装。
	例子：  
	MAC: 00:50:56:35:46:6E  
	IP: 192.168.56.118  
	掩码：255.255.255.0   
	网关：192.168.56.2   
	主机名：jaminzhang.github.io   
	DNS：223.5.5.5 223.6.6.6  
	
	
	根据 6.3 中的定制化安装配置如下 system:  
	
```bash
	cobbler system add --name=jaminzhang.github.io --mac=00:50:56:35:46:6E --profile=CentOS-7-x86_64 --ip-address=192.168.56.118 --subnet=255.255.255.0 --gateway=192.168.56.2 \  
--interface=eth0 --static=1 --hostname=jaminzhang.github.io --name-servers="223.5.5.5 223.6.6.6" --kickstart=/var/lib/cobbler/kickstarts/CentOS-7-x86_64.cfg
```    

## 操作系统安装规范

1. 当前我公司使用操作系统为 CentOS 6 和 CentOS 7,均使用 x86_64 系统，需使用公司 Cobbler 进行自动化安装，禁止自定义设置。
2. 版本选择，数据库统一使用 Cobbler 上 CentOS-7-DB 这个专用的 profile，其他 Web 应用统一使 用Cobbler 上CentOS-7-Web。

## 系统初始化规范

### 初始化操作

* 设置DNS  192.168.56.111 192.168.56.112
* 安装Zabbix Agent：  Zabbix Server:192.168.56.11
* 安装SaltStack Minion： Saltstack Master:192.168.56.11
* histroy 记录时间
```bash
export HISTTIMEFORMAT="%F %T `whoami`"
```    
* 日志记录操作
```bash
export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });logger "[euid=$(whoami)]":$(who am i):[`pwd`]"$msg"; }'
```    
* 内核参数优化
* YUM 仓库
* 主机名解析


### 目录规范

* 脚本放置目录： /opt/shell
* 脚本日志目录： /opt/shell/log
* 脚本锁文件目录： /opt/shell/lock

### 服务安装规范

1. 源码安装路径 /usr/local/appname.version
2. 创建软连接 ln -s /usr/local/appname.version /usr/local/appname 

### 主机名命名规范

  **机房名称-项目-角色-服务-集群-节点.域名**

例子：

  idc01-xxshop-api-nginx-bj-node1.shop.com

### 服务启动用户规范

所有服务，统一使用 www 用户，uid 为 666，除负载均衡需要监听 80 端口使用 root 启动外，所有服务必须使用 www 用户启动，使用大于 1024 的端口。
