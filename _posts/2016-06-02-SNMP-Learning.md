---
layout: post
title: SNMP 学习
description: "SNMP 学习"
category: Network
avatarimg:
tags: [Network, Monitoring, SNMP]
duoshuo: true
---

## 引言
想对某些网络设备（路由器、交换机等）进行监控时，其不支持安装监控  Agent ，但一般都支持 SNMP 方式的监控。  
所以现在来重新学习下 SNMP 原理与安装配置。

## SNMP 简介
> 
Simple Network Management Protocol (SNMP) is an Internet-standard protocol for collecting and organizing information about managed devices 
on IP networks and for modifying that information to change device behavior. Devices that typically support SNMP 
include routers, switches, servers, workstations, printers, modem racks and more.  

## 1 安装配置 snmp
	1. 安装 snmp 相关包组：
	yum list | grep snmp
	yum install net-snmp net-snmp-utils -y

	2. 配置 snmpd.conf
	[root@linux-node1 ~]# cat /etc/snmp/snmpd.conf
	rocommunity	jaminzhang	127.0.0.1
	rocommunity	jaminzhang	192.168.56.11
	
	3. 启动 snmpd
	[root@linux-node1 ~]# systemctl start snmpd
	[root@linux-node1 ~]# netstat -lntup | grep snmp
	tcp        0      0 127.0.0.1:199           0.0.0.0:*               LISTEN      28604/snmpd         
	udp        0      0 0.0.0.0:161             0.0.0.0:*                           28604/snmpd  
	
	4. 测试 snmp 获取数据
	[root@linux-node1 ~]# snmpget -v2c -c jaminzhang 192.168.56.11 1.3.6.1.2.1.1.3.0
	DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (11110) 0:01:51.10
	[root@linux-node1 ~]# snmpget -v2c -c jaminzhang 192.168.56.11 1.3.6.1.4.1.2021.10.1.3.1
	UCD-SNMP-MIB::laLoad.1 = STRING: 0.00
	[root@linux-node1 ~]# snmpwalk -v2c -c jaminzhang 192.168.56.11 1.3.6.1.4.1.2021.10.1.3
	UCD-SNMP-MIB::laLoad.1 = STRING: 0.15
	UCD-SNMP-MIB::laLoad.2 = STRING: 0.07
	UCD-SNMP-MIB::laLoad.3 = STRING: 0.06


## 2  SNMP 协议概念及参考资料

Management information base (MIB)
Object identifier (OID)

SNMP protocol data unit (PDU) types:
* GetRequest
* SetRequest
* GetNextRequest
* GetBulkRequest
* Response
* Trap
* InformRequest


**SNMP 相关参考资料**  
[Simple Network Management Protocol - Wiki](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol)  
[Simple Network Management Protocol](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol)  
[SNMP PDU](http://net-snmp.sourceforge.net/wiki/index.php/TUT:SNMP)  
[《Zabbix企业级分布式监控系统》7.5 SNMP 监控方式](https://book.douban.com/subject/25957954/)  
[SNMP 常用 OID](http://linux.chinaunix.net/techdoc/net/2008/08/21/1026818.shtml)  
[浅谈 Linux 系统中的 SNMP Trap](http://www.ibm.com/developerworks/cn/linux/l-cn-snmp/index.html)  
[配置 snmp](http://www.jiankongbao.com/search/snmp)  

