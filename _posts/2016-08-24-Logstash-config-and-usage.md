---
layout: post
title: Logstash 配置使用
description: "Logstash 配置使用"
category: ELK
avatarimg:
tags: [ELK, Logstash, Pipeline]
duoshuo: true
---

# Logstash 简介

<pre>
Logstash is an open source data collection engine with real-time pipelining capabilities. 
Logstash can dynamically unify data from disparate sources and normalize the data into destinations of your choice.
Cleanse and democratize all your data for diverse advanced downstream analytics and visualization use cases.

While Logstash originally drove innovation in log collection, its capabilities extend well beyond that use case. 
Any type of event can be enriched and transformed with a broad array of 
input, filter, and output plugins, with many native codecs further simplifying the ingestion process. 
Logstash accelerates your insights by harnessing a greater volume and variety of data.

</pre>

![Logstash](https://www.elastic.co/guide/en/logstash/current/static/images/logstash.png)

# 安装

在之前的 ELK 快速安装中已经说明了。

# 快速入门

## 配置一个基本的 Logstash 例子

以下最基本的示例可以测试 Logstash 是否正常安装

```bash
[root@linux-node2 ~]# rpm -ql logstash		# 查询 yum 安装的 logstash 目录及文件
[root@linux-node2 ~]# cd /opt/logstash/
[root@linux-node2 logstash]# bin/logstash -e 'input { stdin { } } output { stdout { } }'
# -e 选项启用从命令行指定配置，以上管道从标准输入获取 input，然后传输到标准输出（以一个结构化的格式）
Settings: Default pipeline workers: 1
Pipeline main started
hello world					# 从键盘输入
2016-08-26T10:47:13.306Z linux-node2 hello world	# Logstash 增加了时间戳和主机名字段
Pipeline main has been shutdown		# 输入 CTRL-D 退出 Logstash
stopping pipeline {:id=>"main"}

```    

# 配置一个高级 Logstash 管道

在大多数用例中，一个 Logstash 管道有一个或多个 input, filter 和 output 插件。  
Logstash 配置文件定义了你的 Logstash 管道。当你启动一个 Logstash 实例时，使用 -f 选项指定一个配置文件，它定义了这个实例的管道。  
一个 Logstash 管道有 2 个必需的元素，input 和 output，还有一个可选的 filter 元素。  
input 插件消费来自一个源的数据，filter 插件按你的指定修改数据，output 插件写入数据到一个目的地。

![basic_logstash_pipeline](https://www.elastic.co/guide/en/logstash/current/static/images/basic_logstash_pipeline.png)

以下文本代表了一个管道配置的框架：

```bash
# The # character at the beginning of a line indicates a comment. Use
# comments to describe your configuration.
input {
}
# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
output {
}
```    

上面的框架是无功能的，因为 input 和 output 区块并没有任何有效的定义选项。


# Ref
[Logstash Introduction](https://www.elastic.co/guide/en/logstash/current/introduction.html)  
[Setting Up an Advanced Logstash Pipeline](https://www.elastic.co/guide/en/logstash/current/advanced-pipeline.html)  

