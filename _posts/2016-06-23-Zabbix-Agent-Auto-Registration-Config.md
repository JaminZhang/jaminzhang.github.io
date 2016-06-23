---
layout: post
title: Zabbix Agent 自动注册配置
description: "Zabbix Agent 自动注册配置"
category: Monitoring
avatarimg: 
tags: [Zabbix, Zabbix Agent]
duoshuo: true
---

# Zabbix Agent 主动方式自动注册的配置

## 1 配置 Zabbix Agent

配置 ServerActive、Hostname 参数

## 1 Web 前端配置自动注册功能

在代理方式下实现自动注册功能

### 1 Web 前端创建 Action
Configuration -> Actions -> Event source -> Auto registration -> Create action

### 2 在 Action 选项中配置名称等信息

### 3 在 Conditions 选项，选择 New condition -> Proxy，选择一个代理，然后 Add

### 4 配置 Operations 选项
在 Operation details 中 选择 Add host, Add to host group, Link to template 等




# Zabbix Agent Host metadata 方式自动注册的配置

在之前 Host name 和 Proxy 的基础上增加了 Host metadata，为了应对生产环境更复杂的情况。  
（比如，云环境下主机名的无规律）

## 1 使用 HostMetadataItem 配置参数
HostMetadataItem 参数用于指定 Item 

比如，对 Linux 系统的自动注册，配置方法如下：  
在 Conditions 选项，选择 New condition -> Host metadata like Linux

## 2 使用 HostMetadata 配置参数

HostMetadata 参数值自己定义
配置方法同上 HostMetadataItem
