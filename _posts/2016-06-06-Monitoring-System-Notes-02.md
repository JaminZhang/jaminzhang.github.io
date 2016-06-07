---
layout: post
title: 运维监控体系学习笔记-02
description: "运维监控体系学习笔记-02"
category: Automated Ops
avatarimg:
tags: [Monitoring, Zabbix]
duoshuo: true
---

# 5 开源运维监控软件选型

一个运维监控系统可以分成如下模块：

  * 采集 
  * 存储 
  * 展示 
  * 告警

相关的开源监控软件有：      
Nagios Cacti Zabbix Ganglia Zenoss Open-falcon
关于以上各软件的介绍及优缺点，可以看下这篇文章 [开源还是商用？十大云运维监控工具横评](https://linux.cn/article-6491-1.html)  

我们构建运维监控体系以 Zabbix 为基础。

因为：  
<pre>
Zabbix是一个基于WEB界面的提供分布式系统监控以及网络监控功能的企业级开源运维平台，也是目前国内互联网用户中使用最广的监控软件，
云智慧遇到的85%以上用户在使用Zabbix做监控解决方案。

入门容易、上手简单、功能强大并且开源免费是云智慧对Zabbix的最直观评价。
Zabbix易于管理和配置，能生成比较漂亮的数据图，其自动发现功能大大减轻日常管理的工作量，丰富的数据采集方式和API接口可以让用户灵活进行数据采集，
而分布式系统架构可以支持监控更多的设备。理论上，通过Zabbix提供的插件式架构，可以满足企业的任何需求。

用户群：85%以上的泛互联网企业。

优点：

支持多平台的企业级分布式开源监控软件
安装部署简单，多种数据采集插件灵活集成
功能强大，可实现复杂多条件告警，
自带画图功能，得到的数据可以绘成图形
提供多种API接口，支持调用脚本
出现问题时可自动远程执行命令(需对agent设置执行权限)
</pre>


Zabbix 支持多种监控方式：IPMI SNMP JVM Agent 等等


# 6 Zabbix 安装部署配置

## 6.1 Zabbix Server 安装

参考官方文档，写得比较详细了。  
[Installation from packages](https://www.zabbix.com/documentation/3.0/manual/installation/install_from_packages)  

### 6.1.1 配置 Zabbix yum 源
有人说大陆网络连接 Zabbix 官方源可能比较慢（这个我在安装时，确实遇到了）  
网络不好可以使用阿里的 yum 源

```bash
# Zabbix 官方源  
rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm

# 阿里 yum 源
rpm -ivh http://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
```    

### 6.1.2 安装 Zabbix 相关软件

```bash
# 安装数据库
yum install mariadb mariadb-server -y


# 安装 Zabbix 相关软件 
yum install zabbix-server-mysql zabbix-web-mysql -y 


# 安装 Zabbix Agent, Zabbix Server 本身也应该需要被监控
yum install zabbix-agent -y


# zabbix-agent可以在 Cobbler 系统安装初始化时加上。
```    

### 6.1.3 创建及初始化数据库

```bash
# 启动数据库
systemctl start mariadb

# 配置数据库
mysql_secure_installation

# 创建配置 Zabbix 数据库及用户
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
flush privileges;

# 导入 sql
cd /usr/share/doc/zabbix-server-mysql-3.0.3
zcat create.sql.gz | mysql -uroot zabbix
```    

### 6.1.4  修改 zabbix_server.conf 配置文件

```bash
vim  /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
```    

### 6.1.5 修改 Zabbix 前端 PHP 配置

```bash
vim /etc/httpd/conf.d/zabbix.conf
# 一些 PHP 设置默认已经配置

# 修改时区
php_value date.timezone Asia/Shanghai
```    

### 6.1.6 启动 Zabbix Server 和 httpd

```bash
systemctl start zabbix-server
systemctl start httpd
```    

### 6.1.7 安装 Zabbix Web
打开 http://zabbix-frontend-hostname/zabbix   
默认用户名/密码是： Admin/zabbix  
具体步骤还是可以参考官方文档 [Installing frontend](https://www.zabbix.com/documentation/3.0/manual/installation/install#installing_zabbix_web_interface)  

## 6.2 Zabbix Agent 安装配置

### 6.2.1 配置 Zabbix yum 源
同6.1.1

### 6.2.2 zabbix agent 安装配置

```bash
yum install zabbix-agent -y

vim /etc/zabbix/zabbix_agentd.conf     
Server=192.168.56.11               # 用于被动模式，数据获取
ServerActive=192.168.56.11         # 用于主动模式，数据提交

systemctl start zabbix-agent       # 启动 zabbix agent
```    

## 6.3 Zabbix 配置及使用

这就涉及到比较多的内容了。  
参考官方文档和相关书籍，中文有一本[Zabbix 企业级分布式监控系统](https://book.douban.com/subject/25957954/)，可以看看。


