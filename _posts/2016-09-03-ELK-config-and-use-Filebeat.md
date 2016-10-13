---
layout: post
title: ELK-配置使用 Filebeat
description: "ELK-配置使用 Filebeat"
category: ELK
avatarimg:
tags: [ELK, Logstash, Filebeat]
duoshuo: true
---

# 为什么使用 Filebeat

Logstash 是一个 Java 程序，当作为收集日志的 Agent 时，显得太臃肿了。  
之前听过一个公司使用 Logstash 作为日志收集 Agent 时，资源占用比业务进程占用还多！  
这时我们需要一个轻量级的日志收集 Agent，上面说的那家公司的处理方法是自己写了一个 Agent。  
其实我们可以先看看官方是否提供相关的 Agent，现在我的需求是收集特定的日志文件，
官方提供了这样的工具-Filebeat，官方给 Filebeat 的定义就是轻量级的日志收集工具。

<pre>
filebeat 是基于原先 logstash-forwarder 的源码改造出来的。换句话说：filebeat 就是新版的 logstash-forwarder，
也会是 ELK Stack 在 shipper 端的第一选择。
</pre>

# 1. 安装 Filebeat

## 1.1 准备条件

ELK 环境应该部署好，这在之前的文章已经配置过了。

## 1.2 安装 Filebeat

```bash
# 下载并安装 Filebeat 软件包
curl -L -O https://download.elastic.co/beats/filebeat/filebeat-1.3.1-x86_64.rpm
rpm -ivh filebeat-1.3.1-x86_64.rpm
```    

# 2. 配置 Filebeat

```bash
# 本例主要修改 2 部分参数
[root@linux-node2 conf.d]# egrep -v "#|^$" /etc/filebeat/filebeat.yml
filebeat:
  prospectors:
    -
      paths:
        - /var/log/nginx/access_log_json.log		# 定义日志文件的路径，可以使用 Shell GLOB 匹配
      input_type: log
  registry_file: /var/lib/filebeat/registry
output:
  logstash:					# output 处配置输出到 logstash，其实也可以直接输出到 ES，但不能对日志进行额外处理
    hosts: ["192.168.56.11:5044"]
shipper:
logging:
  files:
```

>
可以在这样在 “./filebeat -configtest -e” 前台运行 Filebeat 测试配置文件

# 3. 启动 Filebeat

`/etc/init.d/filebeat start`  

正常启动后，Filebeat 就可以发送日志文件数据到你指定的输出。

# 4. Logstash 配置  input beats 插件

```bash
[root@linux-node1 ~]# cat /etc/logstash/conf.d/filebeat.conf 
input {
  beats {
    port => 5044			# Logstash 开启 5044 端口用于接收上面 Filebeat 发送过来的数据
    type => "logs"
    codec => "json"
  }
}

output {
  redis {
    host => "192.168.56.12"
    port => 6379
    db => 6
    data_type => "list"
    key => "filebeat"
  }
}
```    

这样就完成了 Filebeat 收集日志文件数据并发送到 Logstash 的配置。  


# Ref
[Filebeat - Lightweight Shipper for Log Data](https://www.elastic.co/products/beats/filebeat)  
[Filebeat Reference](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)  
[filebeat](http://kibana.logstash.es/content/beats/file.html)  
