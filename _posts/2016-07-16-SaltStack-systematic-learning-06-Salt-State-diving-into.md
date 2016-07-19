---
layout: post
title: SaltStack 系统性学习 06 - SaltStack 状态深入学习
description: "SaltStack 系统性学习 06 - SaltStack 状态深入学习"
category: SaltStack
avatarimg: 
tags: [SaltStack, SLS]
duoshuo: true
---

# SaltStack States 状态特点

* 状态不能回滚
* 状态可以多次执行 

# SaltStack 状态文件

* SaltStack 的状态使用状态文件 SLS(SaLt State)来描述
* SLS 默认文件格式 YAML
* SLS 文件解析模式是从上往下
* Salt 最终执行的时候，将 SLS 解析成一个字典的格式

## SLS 文件说明

SLS 文件包含名称 ID 声明、状态 State 声明、选项（或属性）声明。   
其中名称 ID 声明默认作为 State 的 name 声明（没有指定 name 声明时）。  

例子：  

```yaml
apache-install:     # ID 声明
  service.running:  # State 声明
    - name: httpd   # 选项（或属性）声明
    - enable: True
```    

一个 ID 声明下面，状态模块不能重复，比如不能出现 2 个 file.managed 状态模块。  

salt:// 指当前环境根目录。配置文件中指定如下：

```bash
file_roots:
  base:
    - /srv/salt
```   


# LAMP 架构 SLS 文件编写实例

分析 LAMP 架构部署配置所需状态模块：  

1. 安装软件包    pkg
2. 修改配置文件  file
3. 启动服务      service


## pkg 状态模块常用方法

* pkg.installed 安装软件包 (pkgs 同时安装多个包)
* pkg.group_installed 安装软件包组
* pkg.latest 确认软件包为最新版本
* pkg.removed 卸载软件包
* pkg.purge 卸载并删除配置文件（会把软件包和配置文件都删除掉）


## file 状态模块常用方法

* file.managed

## service 状态模块常用方法

* service.running

# LAMP 架构部署配置状态 SLS 文件编写

LAMP 架构部署配置 pkg file service 状态 SLS 编写过程如下：  

```bash

cd /srv/salt/
mkdir lamp
cd lamp
cat > lamp.sls <<EOF
lamp-pkg:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - mariadb
      - mariadb-server
      - php-cli
      - php-mbstring

apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://lamp/files/php.ini
    - user: root
    - group: root
    - mode: 644

mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://lamp/files/my.cnf
    - user: root
    - group: root
    - mode: 644

apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True

mysql-service:
  service.running:
    - name: mariadb
    - enable: True
    - reload: True

cd /srv/salt/lamp
mkdir files
cd files
cp /etc/httpd/conf/httpd.conf .
cp /etc/php.ini .
cp /etc/my.cnf .
salt 'linux-node2*' test.ping
salt 'linux-node2*' state.sls lamp.lamp

```    

# SLS 文件中状态之间的关系
状态之间有如下关系：  

1. 我依赖谁   require
2. 我被谁依赖 require_in
3. 我监控谁 watch(watch 包含 require)
4. 我被监控谁 watch_in
5. 我引用谁 include
6. 我扩展谁

举例：

```bash
# require 例子
apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - pkg: lamp-pkg
      - file: apache-config

# require_in 例子
mysql-config:
  file-managed:
    - name: /etc/my.cnf
    - source: salt://lamp/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - service: mysql-service

# watch 例子 （只要状态发生变化就做相应的操作）  
apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - pkg: lamp-pkg
    - watch:
      - file: apache-config
# 如果 apche-config 这个 ID 的状态发生变化就 reload，如果不加 reload=True 的话就 restart


# 使用了状态关系配置后，lamp.sls 文件内容如下：

```yaml
lamp-pkg:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - mariadb
      - mariadb-server
      - php-cli
      - php-mbstring

apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://lamp/files/php.ini
    - user: root
    - group: root
    - mode: 644

mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://lamp/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - service: mysql-service

apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - pkg: lamp-pkg
    - watch:
      - file: apache-config

mysql-service:
  service.running:
    - name: mariadb
    - enable: True
    - reload: True

```    

# 编写 SLS 技巧

1. 按状态分类，如果单独使用，很清晰
2. 服务分类，可以被其他的 SLS include。例如 LNMP include mysql的服务。

## 使用 include 改写 lamp.sls

```bash
cd /srv/salt/lamp/
# 分别将 pkg/config/service相关状态写到独立的文件中
[root@linux-node1 lamp]# cat pkg.sls 
lamp-pkg:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - mariadb
      - mariadb-server
      - php-cli
      - php-mbstring
You have new mail in /var/spool/mail/root
[root@linux-node1 lamp]# cat pkg.sls
lamp-pkg:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - mariadb
      - mariadb-server
      - php-cli
      - php-mbstring
[root@linux-node1 lamp]# cat config.sls 
apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://lamp/files/php.ini
    - user: root
    - group: root
    - mode: 644

mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://lamp/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - service: mysql-service
[root@linux-node1 lamp]# cat service.sls 
apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - pkg: lamp-pkg
    - watch:
      - file: apache-config

mysql-service:
  service.running:
    - name: mariadb
    - enable: True
    - reload: True
    
# 使用 include 包含以上 sls
cat > init.sls << EOF
include:
  - lamp.pkg
  - lamp.config
  - lamp.service
EOF

salt 'linux-node2*' state.sls lamp.init
```     

# Ref
[SALT.STATES.PKG](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pkg.html)  
[SALT.STATES.SERVICE](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.service.html)  
[SALT.STATES.FILE](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html) 


 
