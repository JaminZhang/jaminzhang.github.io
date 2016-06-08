---
layout: post
title: Zabbix 自定义监控项目配置
description: "Zabbix 自定义监控项目配置"
category: Zabbix
avatarimg: 
tags: [Zabbix, Nginx]
duoshuo: true
---

# 引言
前面说到以 Zabbix 做为运维监控系统，在实际的运维工作中，我们肯定有自己需要自己要监控的项目，  
但默认提供的模板并没有提供相关监控项，这时我们就要自己添加自定义的监控项目了。  
这里我们以添加自定义监控 Nginx Status 的项目来说明 Zabbix 添加自定义监控项目的步骤。


## 1 配置 Nginx 开启 nginx status

Nginx 配置文件中增加如下配置：

```bash
location /nginx-status {
	stub_status on;
	access_log   off;
	allow 127.0.0.1;
	allow 192.168.56.0/24;
	deny all;
}	
```     

Nginx 状态的详细解释说明，参见之前一篇文章：[理解 nginx http_stub_status 相关参数](http://jaminzhang.github.io/nginx/understand-nginx-http-stub-status-parameters/)  


## 2 配置 nginx status 监控脚本

参考脚本地址：  
[nginx_status](https://github.com/itnihao/zabbix-book/blob/master/11-chapter/nginx_monitor/scripts/nginx_status)  

下载后根据自己的情况修改 nginx status 的 URL(Port/PATH)

测试脚本能正常获取数据。


## 3 增加 Zabbix 自定义监控项目的配置文件
配置文件一般放在/etc/zabbix/zabbix_agentd.d/下，  
参考配置文件地址：  
[userparameter_nginx.conf ](https://github.com/itnihao/zabbix-book/blob/master/11-chapter/nginx_monitor/zabbix_agentd.d/userparameter_nginx.conf)  

内容如下：

```bash
UserParameter=nginx.accepts,/etc/zabbix/scripts/nginx_status accepts
UserParameter=nginx.handled,/etc/zabbix/scripts/nginx_status handled
UserParameter=nginx.requests,/etc/zabbix/scripts/nginx_status requests
UserParameter=nginx.connections.active,/etc/zabbix/scripts/nginx_status active 
UserParameter=nginx.connections.reading,/etc/zabbix/scripts/nginx_status reading
UserParameter=nginx.connections.writing,/etc/zabbix/scripts/nginx_status writing
UserParameter=nginx.connections.waiting,/etc/zabbix/scripts/nginx_status waiting
```    

添加配置文件后，重启 Zabbix Agent，然后使用 zabbix_get 测试是否能获取数据，比如：

```bash
[root@linux-node1 ~]# zabbix_get -s 192.168.56.11 -p 10050 -k "nginx.active"
1
[root@linux-node1 ~]# zabbix_get -s 192.168.56.11 -p 10050 -k "nginx.accepts"
2246493
```    

## 4 在 Zabbix Web 上添加自定义监控的 item/graph 等等
这步就不截图说明了。
