---
layout: post
title: Elasticsearch 配置使用
description: "Elasticsearch 配置使用"
category: ELK
avatarimg:
tags: [ELK, Elasticsearch, Cluster, head, kopf]
duoshuo: true
---

Elasticsearch 配置使用

# Elasticsearch 简介

<pre>
Elasticsearch是一个基于Apache Lucene(TM)的开源搜索引擎。无论在开源还是专有领域，Lucene可以被认为是迄今为止最先进、性能最好的、功能最全的搜索引擎库。

Elasticsearch也使用Java开发并使用Lucene作为其核心来实现所有索引和搜索的功能，但是它的目的是通过简单的RESTful API来隐藏Lucene的复杂性，从而让全文搜索变得简单。

不过，Elasticsearch不仅仅是Lucene和全文搜索，我们还能这样去描述它：
分布式的实时文件存储，每个字段都被索引并可被搜索
分布式的实时分析搜索引擎
可以扩展到上百台服务器，处理PB级结构化或非结构化数据

</pre>

# Elasticsearch 配置

ES 在之前的 ELK 快速安装中已经安装好了。

下面我们来进行配置。  
ES 配置文件 `/etc/elasticsearch/elasticsearch.yml`，如下配置

```bash
grep "^[a-Z]" /etc/elasticsearch/elasticsearch.yml  
cluster.name: myes		# 集群名称，名称相同即属于同一个集群
node.name: linux-node1	# 本机在集群的内的名称
path.data: /data/es-data	# 保存数据的目录，此目录空间要大，IO 要高，
path.logs: /var/log/elasticsearch	# 保存日志的目录
bootstrap.mlockall: true	# 服务启动的时候锁定内存，防止写入 swap
network.host: 192.168.56.11	# 监听地址
http.port: 9200			# 监听端口
#discovery.zen.ping.unicast.hosts: ["192.168.56.11", "192.168.56.12"] # 创建集群的时候组播地址，用于广播无效的情况下，可以只用在一台 ES 上配置所有 ES 节点
```    

`path.data: /data/es-data` 此目录先要创建好，并设置好属主

>
mkdir -p /data/es-data  
chown -R elasticsearch.elasticsearch /data/es-data

```bash
# 启动 ES  
systemctl start elasticsearch

# 测试
[root@linux-node1 ~]# curl -i -XGET 'http://192.168.56.11:9200/'
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8
Content-Length: 311

{
  "name" : "linux-node1",
  "cluster_name" : "myes",
  "version" : {
    "number" : "2.3.5",
    "build_hash" : "90f439ff60a3c0f497f91663701e64ccd01edbb4",
    "build_timestamp" : "2016-07-27T10:36:52Z",
    "build_snapshot" : false,
    "lucene_version" : "5.5.0"
  },
  "tagline" : "You Know, for Search"
}
```    

# ES 集群

按照上面步骤完成 linux-node2 上的 ES 安装启动。  
Elasticsearch为分布式而生，而且它的设计隐藏了分布式本身的复杂性。  
当完成 linux-node2 的配置，它就自动加入了 myes 集群。  
默认情况下 ES 是使用组包的方式通信的，也就是看其他节点是不是同一个在 cluster name 下，并选举一个主节点。

## 集群健康

使用如下 API 访问：

> 
curl -XGET 'http://192.168.56.11:9200/_cluster/health?pretty=true'

> 
其他监控系统可以通过此 API 来监控 ES 集群健康状态。  

# ES 安装插件

插件是为了完成不同的功能，官方提供了一些插件但是是收费的，  
另外也有一些开发爱好者提供的插件，可以实现对 ES 集群的状态监控与管理配置等功能。

## 安装 head 插件

<pre>
elasticsearch-head
A web front end for an elastic search cluster
</pre>

> 
/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head

安装完成后通过浏览器访问 `http://192.168.56.11:9200/_plugin/head/`

下面我们创建 index 数据，如下图示：

![head-put-index-data](http://jaminzhang.github.io/images/ELK/head-put-index-data.png)

以下图示 head 插件的使用：

![head-cluster-nodes-info](http://jaminzhang.github.io/images/ELK/head-cluster-nodes-info.png)  

| 颜色  | 意义 |
|-------|------|
| green | 所有主要分片和复制分片都可用 |
| yellow| 所有主要分片可用，但不是所有复制分片都可用 |
| red   | 不是所有的主要分片都可用 |


![head-cluster-nodes-info-02](http://jaminzhang.github.io/images/ELK/head-cluster-nodes-info-02.png)  

## 安装 kopf 插件

<pre>
kopf is a simple web administration tool for elasticsearch written in JavaScript + AngularJS + jQuery + Twitter bootstrap.

It offers an easy way of performing common tasks on an elasticsearch cluster. 
Not every single API is covered by this plugin, but it does offer a REST client which allows you to explore the 
full potential of the ElasticSearch API.
</pre>

> 
/usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf

安装完成后通过浏览器访问 `http://192.168.56.11:9200/_plugin/kopf/`

## 其他插件

* Marvel 插件

<pre>
Marvel是Elasticsearch的管理和监控工具，在开发环境下免费使用。
它包含了一个叫做Sense的交互式控制台，使用户方便的通过浏览器直接与Elasticsearch进行交互。

Elasticsearch线上文档中的很多示例代码都附带一个View in Sense的链接。点击进去，就会在Sense控制台打开相应的实例。
</pre>

* bigdesk 插件
(elasticsearch-2.3.5-1 上不能安装)

# Ref
[Elasticsearch权威指南（中文版）](http://es.xiaoleilu.com/010_Intro/05_What_is_it.html)  
[elasticsearch-head](https://github.com/mobz/elasticsearch-head)  
[elasticsearch-kopf](https://github.com/lmenezes/elasticsearch-kopf)  
