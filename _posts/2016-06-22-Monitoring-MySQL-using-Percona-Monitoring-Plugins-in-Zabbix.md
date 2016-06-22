---
layout: post
title: Zabbix 中使用 Percona Monitoring Plugins 监控 MySQL
description: "Zabbix 中使用 Percona Monitoring Plugins 监控 MySQL"
category: Monitoring
avatarimg: 
tags: [Zabbix, MySQL, Percona]
duoshuo: true
---

# Zabbix 中监控 MySQL 方式

## 1 使用自带模板监控 MySQL
Zabbix-Agent 本身并没有提供直接对 MySQL 监控的 Key，所以首先需要通过自定义 Key 来应用自带的 MySQL 模板。  

具体步骤暂不说明。本文主要说明使用 Percona Monitoring Plugins 监控 MySQL的方式

## 2 使用 Percona Monitoring Plugins 监控 MySQL

# 使用 Percona Monitoring Plugins 监控 MySQL

## 1 系统需求

被监控服务器上安装 zabbix-agent, php, php-mysql

```bash
[root@linux-node1 ~]# yum install zabbix-agent php php-mysql
[root@linux-node1 ~]# rpm -qa zabbix-agent php php-mysql
php-mysql-5.4.16-36.1.el7_2.1.x86_64
php-5.4.16-36.1.el7_2.1.x86_64
zabbix-agent-3.0.3-1.el7.x86_64
```    

## 2 安装配置 percona-zabbix-templates

```bash
# 安装 percona-zabbix-templates
yum install https://www.percona.com/downloads/percona-monitoring-plugins/1.1.6/percona-zabbix-templates-1.1.6-1.noarch.rpm
# 也可配置 Percona yum 仓库后安装 
# yum install https://www.percona.com/redir/downloads/percona-release/redhat/latest/percona-release-0.1-3.noarch.rpm
 
# 配置 Zabbix Agent
cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.d/

systemctl restart zabbix-agent
```    

## 3 配置 Agent 上的 MySQL 连接

```bash
# 创建 .cnf 文件指定 MySQL 用户名和密码

# 生产环境请一定要设置复杂密码
[root@linux-node1 ~]# cat /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php.cnf
<?php
$mysql_user = 'zabbix';
$mysql_pass = 'zabbix';

# 测试脚本
[root@linux-node1 ~]# /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh gg

# 配置 ~zabbix/.my.cnf，内容如下：
[root@linux-node1 ~]# cat ~zabbix/.my.cnf
[client]
user = zabbix
password = zabbix

# zabbix 用户 测试脚本
[root@linux-node1 ~]# sudo -u zabbix -H /var/lib/zabbix/percona/scripts/get_mysql_stats_wrapper.sh running-slave
0
```    

## 4 配置 Zabbix Server

1. 去 https://www.percona.com/downloads/percona-monitoring-plugins/ 下载 Percona Monitoring Plugins 最新 tar.gz 源码包（如果使用 Zabbix 3.0，自带模板有点旧了，并不能导入使用，后面给出解决办法）
2. 解压获取 zabbix/templates/ 目录
3. 通过 Zabbix Web 界面  (Configuration -> Templates -> Import) 导入 XML 模板，注意要另外选择上 Screens.
4. 配置主机关联上 Percona MySQL Server Template 模板。


# 遇到的问题
1 如果使用 Zabbix 3.0，自带模板比较旧，并不能导入使用  
提示如下：  
Invalid tag "/zabbix_export/date": "YYYY-MM-DDThh:mm:ssZ" is expected.  
Invalid tag "/zabbix_export/templates/template(1)/items/item(1)": the tag "snmp_community" is missing.  

解决方法：手动修改模板文件解决报错比较麻烦，有人提到可以将此模板导入 Zabbix 2.X 系列后，再导出到 Zabbix 3.0。  
这里我们直接使用现成可用的 Zabbix 3.X 的 percona-zabbix-templates   
[zbx_percona_mysql_template.xml 模板地址](http://jaminzhang.github.io/soft-conf/Zabbix/zbx_percona_mysql_template.xml)  

2 不出图

```bash
# zabbix_get 能获取数据，但是不出图。
[root@linux-node1 ~]# zabbix_get -s 192.168.56.11 -k "MySQL.max-connections"
151

# 查看状态文件权限，为之前测试脚本时的 root 权限，zabbix 用户并不能读写，所以获取不到数据
[root@linux-node1 ~]# ll /tmp/localhost-mysql_cacti_stats.txt 
-rw-r--r-- 1 root root 1374 Jun 22 11:33 /tmp/localhost-mysql_cacti_stats.txt

# 删除 root 用户测试时生成的 mysql 状态文件
[root@linux-node1 ~]# rm -f  /tmp/localhost-mysql_cacti_stats.txt 
# 会自动生成 zabbix用户权限的 mysql 状态文件
[root@linux-node1 ~]# ll  /tmp/localhost-mysql_cacti_stats.txt 
-rw-rw-r-- 1 zabbix zabbix 1374 Jun 22 11:41 /tmp/localhost-mysql_cacti_stats.txt
# 过一会儿就可以看到出图了
```

# Ref
[Percona Monitoring Plugins for Zabbix](https://www.percona.com/doc/percona-monitoring-plugins/1.1/zabbix/index.html)  
[the tag "snmp_community" is missing.](https://www.percona.com/forums/questions-discussions/percona-monitoring-plugins/43888-the-tag-snmp_community-is-missing)  
[ZABBIX AND PERCONA](http://sysblog.sund.org/zabbix-and-percona/)  



