---
layout: post
title: ELK-生产案例项目分析及实战
description: "ELK-生产案例项目分析及实战"
category: ELK
avatarimg:
tags: [ELK, Production, Best-Practice]
duoshuo: true
---


ELK-生产案例项目分析及实战


# 1. 需求分析

确认需要收集的日志类型及使用的相关插件

* 系统日志： /var/log/* （可以使用 input 的 syslog 插件）
* 访问日志： Apache/Nginx/Tomcat 等的访问日志（ 使用 input 的 file/json 等插件，filter 的 grok 插件）
* 错误日志： error log、Java 日志 （使用访问日志类似的插件，Java 的日志需要使用 codec 多行插件）
* 运行日志： 程序自己生成的 （使用 input 的 file/json 等插件）
* 网络日志： 防火墙、交换机、路由器等的日志 （可以使用 input 的 syslog 插件）

# 2. 日志标准化

## 2.1 日志放置目录及命名规范

规范日志放置目录和命名 ，以下是一个示例参考：  

```bash
[root@linux-node1 logs]# tree /data/logs
/data/logs
├── access-log	# 访问日志目录
├── error-log	# 错误日志目录
└── runtime-log	# 运行日志目录
```    

## 2.2 日志切割

对于不同程序，有的程序可以自定义日志切割，有的可能需要自己编写脚本来进行日志切割。  
日志文件切割时间可以按天、按小时等，这个需要根据实际业务的日志情况来确定。

## 2.3 日志接入格式标准

我们可以规定，如果要接入 ELK 日志系统，程序日志格式应该是 JSON 格式，方便日志的统一接收。  
这个和研发去协商，为了实现 DevOps，研发和运维应该相互配合，如果日志格式不是 JSON，我们可以不接收。

## 2.4 原始日志文件删除和归档策略

比如可以将本地原始日志文件 rsync 到一个共享存储文件系统后，然后删除本地最近 7 天前的日志文件。
这个也是根据和具体业务的日志情况来制定。  
如果业务一天能产生海量日志，那么可能就要删除最近一天前的日志。  


# 3. 工具化

如何使用 logstash 等 agent 工具进行日志收集。
需要规划好方案和画好架构图。

参考官网架构图  
![Multiple Connections for Logstash High Availability](https://www.elastic.co/guide/en/logstash/current/static/images/deploy_6.png)    


# 4. 实施

实施是基于我们在前面一系列文章的配置。

按照架构图安装 ELK 相关组件。

# 5. 监控

1. 对 ES 以及 Kibana 进行监控。如果服务 DOWN 了及时处理。
2. 可以使用 Redis 的 list 作为 ELK 的消息队列。
3. 对 Redis 的 List Key 长度进行监控(llen key_name)。例如: 超过"10 万"即报警(根据实际情况以及业务情况)   

# 6. 扩展

1. 开源日志分析平台:ELK、EFK、EHK、
2. 数据收集处理: Flume、Heka
3. 消息队列: Redis、RabbitMQ、Kafka、Hadoop、WebHDFS


# 遇到的问题

1. 192.168.56.11 上的 Apache 日志不能写入 redis ，原因是 logstash init 脚本运行用户和组是 logstash ，但 httpd 目录权限如下：

```bash
[root@linux-node1 conf.d]# ll /var/log/httpd/ -d
drwx------ 2 root root 4096 Oct  9 12:18 /var/log/httpd/
```   

logstash 用户进程没权限读取 access_log，当然就无法写入 redis。  
解决办法：可以修改 logstash init 脚本运行用户和组为 root。因为 logstash 并不监听端口，所以可以换成 root 用户。  
但推荐将修改 `/var/log/httpd/` 权限为 755。


2. Logstash 运行时报错

报错日志暂时不贴了  

初步判断 `/etc/logstash/conf.d/` 目录下只能有 Logstash 的 YAML 格式的配置文件，不能有其他格式的文件。  
我将一个日志文件放在这里了，移走后就可以正常运行。




