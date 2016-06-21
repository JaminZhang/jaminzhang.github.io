---
layout: post
title: Zabbix 自定义 Linux 监控项目配置
description: "Zabbix 自定义 Linux 监控项目配置"
category: Monitoring
avatarimg: 
tags: [Zabbix, Nginx, TCP]
duoshuo: true
---

# 引言
之前一篇博文曾经写过 Zabbix 自定义监控项目配置，当时以 nginx status 监控举例说明的。  
现在重新用一个综合性自定义监控脚本来监控 TCP、nginx status、memcached、redis 等的状态。  

# 1 配置 Nginx 开启 nginx status

Nginx 配置文件中增加如下配置：

```bash
location /nginx_status {
	stub_status on;
	access_log   off;
	allow 127.0.0.1;
	allow 192.168.56.0/24;
	deny all;
}	
```     

注意 nginx status 的 URL 要和脚本中的 /nginx_status 匹配

# 2 配置 TCP、nginx status、memcached、redis 等等监控脚本
本文只演示配置 TCP、nginx status 状态

[zabbix_linux_plugin 脚本地址](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/soft-conf/Zabbix/zabbix_linux_plugin.sh)  


测试脚本能正常获取数据。

```bash
[root@linux-node1 zabbix_agentd.d]# /etc/zabbix/scripts/zabbix_linux_plugin.sh nginx_status 8080 active
1
[root@linux-node1 zabbix_agentd.d]# /etc/zabbix/scripts/zabbix_linux_plugin.sh tcp_status ESTAB
4
```   

# 3 增加 Zabbix 自定义监控项目的配置文件
配置文件一般放在/etc/zabbix/zabbix_agentd.d/下，  
内容如下：

```bash
[root@linux-node1 zabbix_agentd.d]# cat userparameter_linux.conf 
UserParameter=linux_status[*],/etc/zabbix/scripts/zabbix_linux_plugin.sh $1 $2 $3 
```    

添加配置文件后，重启 Zabbix Agent，然后使用 zabbix_get 测试是否能获取数据，比如：

```bash
[root@linux-node1 zabbix_agentd.d]# zabbix_get -s 192.168.56.11 -p 10050 -k "linux_status[nginx_status,8080,active]"
1
[root@linux-node1 zabbix_agentd.d]# zabbix_get -s 192.168.56.11 -p 10050 -k "linux_status[tcp_status,ESTAB]"
6

```    

## 4 在 Zabbix Web 上添加自定义监控的 item/graph 等等
这步手动比较繁琐，第一次添加时，我们可以做成模板，以后之后再添加时，直接导入相应模板。  
这里我们使用导入模板的方式。参考模板如下：  
[zbx_nginx_template.xml](https://github.com/JaminZhang/jaminzhang.github.io/blob/master/soft-conf/Zabbix/zbx_nginx_template.xml)  
[zbx_tcp_template.xml](https://github.com/JaminZhang/jaminzhang.github.io/blob/master/soft-conf/Zabbix/zbx_tcp_template.xml)  
