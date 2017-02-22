---
layout: post
title: SaltStack 管理任务缓存和结果
description: "SaltStack 管理任务缓存和结果"
category: SaltStack
avatarimg:
tags: [SaltStack, Job Cache]
duoshuo: true
---


# SaltStack 管理任务缓存

## 默认的任务缓存

### 减小默认任务缓存大小

## 额外的任务缓存选项


# SaltStack 存储任务结果到一个外部系统

## 外部任务缓存 - Minion 端 Returner

## Master 任务缓存 - Master 端

## 配置一个外部或 Master 任务缓存

### 步骤 1：理解 Salt Returner

### 步骤 2：配置 Returner

配置 Master Job Cache 存储到 MySQL 例子：  

在 /etc/salt/master 配置文件中增加如下 Returner 配置：

```yaml
mysql.host: '192.168.56.11'
mysql.user: 'salt'
mysql.pass: 'salt@pw'
mysql.db: 'salt'
mysql.port: 3306
```    

### 步骤 3：启用外部或 Master 任务缓存

配置 Master Job Cache 存储到 MySQL 例子：  

在 /etc/salt/master 配置文件中增加如下配置：

```yaml
master_job_cache: mysql
```   

修改 Master 配置文件后，需要重启 Master

>
systemctl restart salt-master


# Ref

[MANAGING THE JOB CACHE](https://docs.saltstack.com/en/latest/topics/jobs/job_cache.html)  
[STORING JOB RESULTS IN AN EXTERNAL SYSTEM](https://docs.saltstack.com/en/latest/topics/jobs/external_cache.html)  


