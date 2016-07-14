---
layout: post
title: DNS 系统性学习 05 - DNS 监控
description: "DNS 系统性学习 05 - DNS 监控"
category: Network
avatarimg:
tags: [Network, DNS, BIND, Monitoring]
duoshuo: true
---

# 1 系统基础性能监控

可以使用 Zabbix 自带模板

# 2 loopback 地址绑定状态监控

在 LVS + Keepalived + DNS Servers 的 DNS 集群架构中，DNS Servers 作为 Real Server，在 LVS-DR 模式下，  
DNS Servers 需要绑定 loopback 地址。如果 loopback 地址没有绑定上，LVS 健康检查通过后，当请求到达 DNS Server 时，  
请求被拒绝，DNS 集群出现异常。

# 3 DNS SLAVE 数据与 MASTER 一致性监控

两部分：

1. 通过写 Zabbix 自定义 discovery，扫描出 DNS 配置中所有 zone，然后分别对比 slave 和 master 每个 zone 的 serial 值，当 slave 与 master 的值持续 5 分钟不一致时报警
2. 写脚本，每 15 分钟扫一遍 master 上所有域名解析结果，与每个 slave 的结果做对比，当出现结果不一致情况时报警

# 4 DNS 响应时间监控

远端一组主机跑在 default 下，通过 dig 命令检测 DNS Server 的响应时间

>
dig @192.168.56.13 view.viewexample.com

在这个命令里面有一个Query time，通过它来做监控

# 5 DNS 每秒请求数监控

rndc stats

# 6 DNS 可用性监控

远端一组主机跑在 FullNAT 下，通过 host 命令检测 DNS Server 的可用性，脚本与 LVS 健康检测脚本类似

当当网监控 Zabbix，10000 台机器以下 Zabbix 能撑住
