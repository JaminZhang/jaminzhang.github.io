---
layout: post
title: ELK 快速安装
description: "ELK 快速安装"
category: ELK
avatarimg:
tags: [ELK, Elasticsearch, Logstash, Kibana, YUM]
duoshuo: true
---


ELK 快速安装

# ELK 简介

<pre>
对于日志来说，最常见的需求就是收集、存储、查询、展示，
开源社区正好有相对应的开源项目：logstash（收集）、elasticsearch（存储+搜索）、kibana（展示），
我们将这三个组合起来的技术称之为 ELKStack，
所以说 ELKStack 指的是 Elasticsearch、Logstash、Kibana 技术栈的结合。
</pre>

# 安装 Elasticsearch

<pre>
Elasticsearch 首先需要 Java 环境，所以需要提前安装好 JDK，可以直接使用 yum 安装。
也可以从 Oracle 官网下载JDK进行安装。开始之前要确保 JDK 正常安装并且环境变量也配置正确。
</pre>
  
```bash
# 0. 安装 JDK
[root@linux-node1 ~]# yum install java
[root@linux-node1 ~]# java -version
openjdk version "1.8.0_101"
OpenJDK Runtime Environment (build 1.8.0_101-b13)
OpenJDK 64-Bit Server VM (build 25.101-b13, mixed mode)

# 1. 下载安装 GPG Key
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# 2. 配置 yum 仓库
vim /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1

# 3. 安装
yum install elasticsearch -y

```

# 安装 Logstash

和 Elasticsearch 一样，在开始部署 Logstash 之前也需要你的环境中正确的安装的 JDK。

```bash
# 0. 安装 JDK
[root@linux-node1 ~]# yum install java
[root@linux-node1 ~]# java -version
openjdk version "1.8.0_101"
OpenJDK Runtime Environment (build 1.8.0_101-b13)
OpenJDK 64-Bit Server VM (build 25.101-b13, mixed mode)

# 1. 下载安装 GPG Key
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# 2. 配置 yum 仓库
vim /etc/yum.repos.d/logstash.repo
[logstash-2.3]
name=Logstash repository for 2.3.x packages
baseurl=https://packages.elastic.co/logstash/2.3/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1

# 3. 安装
yum install logstash -y
```    

# 安装 Kibana

Kibana 是为 Elasticsearch 设计的开源分析和可视化平台。你可以使用 Kibana 来搜索，查看存储在 Elasticsearch 索引中的数据并与之交互。你可以很容易实现高级的数据分析和可视化，以图表的形式展现出来。

```bash
# 1. 下载安装 GPG Key
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# 2. 配置 yum 仓库
vim /etc/yum.repos.d/kibana.repo
[kibana-4.5]
name=Kibana repository for 4.5.x packages
baseurl=http://packages.elastic.co/kibana/4.5/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1

# 3. 安装
yum install kibana -y

```

>
yum install *.rpm 会验证依赖。当 yum 下载安装软件包比较慢时，可以用其他快速下载工具下载对应的软件包，然后再安装。

# 使用 Cobbler 创建 ELKStack 仓库

生产环境一般不能使用外网的 YUM 仓库，可以使用 Cobbler 来创建自己的 yum 仓库。

```bash
[root@linux-node1 ~]# cobbler repo add --name=elasticsearch-2.x --mirror=https://packages.elastic.co/elasticsearch/2.x/centos --arch=x86_64 --breed=yum
[root@linux-node1 ~]# cobbler repo add --name=logstash-2.3 --mirror=https://packages.elastic.co/logstash/2.3/centos --arch=x86_64 --breed=yum
[root@linux-node1 ~]# cobbler repo add --name=kibana-4.5 --mirror=http://packages.elastic.co/kibana/4.5/centos --arch=x86_64 --breed=yum
[root@linux-node1 ~]# cobbler reposync
```    

# Ref
[Elasticsearch Repositories](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-repositories.html)  
[Installing Logstash](https://www.elastic.co/guide/en/logstash/current/installing-logstash.html)  
[Kibana Repositories](https://www.elastic.co/guide/en/kibana/current/_upgrading_kibana.html)  
[ELKStack快速安装](https://www.unixhot.com/article/59)  

