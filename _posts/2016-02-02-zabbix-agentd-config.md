---
layout: post
title: Zabbix Agent配置文件说明
description: "Zabbix Agent配置文件说明"
category: Zabbix
avatarimg: 
tags: [Zabbix]
duoshuo: true
---

# 引言
我们使用的服务器监控软件是Zabbix，这是现在普遍使用的监控软件。  
刚才我登录服务器上去看了下zabbix agentd的配置文件。由于我并没有经常使用zabbix, 所以有些参数需要重新了解加深下。  

# Zabbix agent配置文件zabbix_agentd.conf说明
以下是我们的一个zabbix_agentd.conf配置文件，比较简单：
<pre>
Server=X.X.X.X
StartAgents=2
Include=/etc/zabbix/zabbix_agentd/
LogFile=/tmp/zabbix_agentd.log
EnableRemoteCommands=0
Timeout=30
</pre>

各个参数的含义是什么呢？直接去看官网的说明吧，[点这](https://www.zabbix.com/documentation/2.4/manual/appendix/config/zabbix_agentd)  

<pre>
Server	no			List of comma delimited IP addresses (or hostnames) of Zabbix servers. Spaces are allowed since the Zabbix 2.2 version.
Incoming connections will be accepted only from the hosts listed here.
Note that hostnames must resolve hostname→IP address and IP address→hostname.
If IPv6 support is enabled then '127.0.0.1', '::127.0.0.1', '::ffff:127.0.0.1' are treated equally.

StartAgents	no	0-100	3	Number of pre-forked instances of zabbix_agentd that process passive checks.
If set to 0, disables passive checks and the agent will not listen on any TCP port.
The upper limit used to be 16 before version 1.8.5.

Include	no			You may include individual files or all files in a directory in the configuration file.
To only include relevant files in the specified directory, the asterisk wildcard character is supported for pattern matching. For example: /absolute/path/to/config/files/*.conf. Pattern matching is supported since Zabbix 2.4.0.
See special notes about limitations.

LogFile	no			Name of log file.
If not set, syslog is used.

EnableRemoteCommands	no		0	Whether remote commands from Zabbix server are allowed.
0 - not allowed
1 - allowed

Timeout	no	1-30	3	Spend no more than Timeout seconds on processing

</pre>

上面的英文说得比较清楚了，我就不说中文了。  
当然上面的配置文件中参数比较少，更多参数与中文说明参见文后Ref相关资料。

# Ref
[The parameters supported in a Zabbix agent configuration file (zabbix_agentd.conf)](https://www.zabbix.com/documentation/2.4/manual/appendix/config/zabbix_agentd)  
[zabbix_agentd.conf配置文件详解](http://www.ttlsa.com/zabbix/zabbix_agentd-conf-description/)  
[Zabbix Agent端配置文件说明](http://blog.chinaunix.net/uid-29155617-id-4668602.html)  


