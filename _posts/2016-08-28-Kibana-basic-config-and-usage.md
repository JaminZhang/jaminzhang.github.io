---
layout: post
title: Kibana 基本配置使用
description: "Kibana 基本配置使用"
category: ELK
avatarimg:
tags: [ELK, Kibana]
duoshuo: true
---


# Kibana 基本配置使用

## 安装

前面 ELK 快速安装文章中已经说明。

## 配置

```bash

# kibana 配置文件如下配置

[root@linux-node2 ~]# grep "^[a-Z]" /opt/kibana/config/kibana.yml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.url: "http://192.168.58.12:9200"

```    

## 启动 Kibana

>
systemctl start kibana

## 访问 Web 页面

地址：http://Kibana 服务器地址:5601/

第一次访问，提示没有默认索引模式，我们稍后进行配置。  
 

## 添加索引并搜索使用

前几篇文章我们演示了收集系统日志、Java 日志、Nginx 访问日志，如下图：
![ES-Index](http://jaminzhang.github.io/images/ELK/ES-Index.png)  

现在我们在 Kibana 上添加如上索引，按照下图示例添加：
![Kibana-Configure-index-pattern](http://jaminzhang.github.io/images/ELK/Kibana-Configure-index-pattern.png)  


添加完成后如下图，我们就可以搜索日志了，之后可以保存搜索、配置统计图和 Dashboard，这里就不详述了。
![Kibana-index](http://jaminzhang.github.io/images/ELK/Kibana-index.png)  


上面我们访问使用 Kibana 时，并没有进行登录验证，为了安全考虑，我们需要进行 Kibana 的登录验证配置。  
这个我们之后再写一篇文章。 

# Ref
[Kibana production](http://kibana.logstash.es/content/kibana/v4/production.html)  
