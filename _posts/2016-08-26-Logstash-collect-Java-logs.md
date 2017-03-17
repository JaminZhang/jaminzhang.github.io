---
layout: post
title: Logstash 收集 Java 日志
description: "Logstash 收集 Java 日志"
category: ELK
avatarimg:
tags: [ELK, Logstash, Java, codec, multiline]
duoshuo: true
---

Logstash 收集 Java 日志

# 在同一个配置文件指定多个 input/output 

我们演示收集 ES 的 Java 日志文件 `/var/log/elasticsearch/myes.log`

```bash

[root@linux-node1 /etc/logstash/conf.d]# cat if.conf 
input {
    file {
        path => ["/var/log/messages","/var/log/secure"]
        type => "system-log"
        start_position => "beginning"
    }
    file {
        path => ["/var/log/elasticsearch/myes.log"]
        type => "es-log"
        start_position => "beginning"
    }
}

filter {
}

output {
    if [type] == "system-log" {
        elasticsearch {
            hosts => ["192.168.56.11:9200"]
            index => "system-log-%{+YYYY.MM}"
        }
    }
    if [type] == "es-log" {
        elasticsearch {
            hosts => ["192.168.56.11:9200"]
            index => "es-log-%{+YYYY.MM}"
        }
    }
}

```   

从上面的配置文件可以看到，如果在一个配置文件中要将不同的 input 输出到不同的 output，  
我们这里使用了 `if [type]` 的判断。  

# 使用 multiline codec 插件收集 Java 日志

但这里还有一个问题，Java 日志一般包含多行，这些多行应该是一个事件。  
这里我们要使用一个 multiline 的 codec 插件，来实现将这些多行合并到一个字段中去。  
增加  multiline 的 codec 后配置文件如下：

```bash

[root@linux-node1 /etc/logstash/conf.d]# cat java.conf 
input {
    file {
        path => ["/var/log/messages","/var/log/secure"]
        type => "system-log"
        start_position => "beginning"
    }
    file {
        path => ["/var/log/elasticsearch/myes.log"]
        type => "es-log"
        start_position => "beginning"
        codec => multiline {
            pattern => "^\["
            negate => true
            what => "previous"
        }
    }
}

filter {
}

output {
    if [type] == "system-log" {
        elasticsearch {
            hosts => ["192.168.56.11:9200"]
            index => "system-log-%{+YYYY.MM}"
        }
    }
    if [type] == "es-log" {
        elasticsearch {
            hosts => ["192.168.56.11:9200"]
            index => "es-log-%{+YYYY.MM}"
        }
    }
}

```    

测试时在前台指定 java.conf 调试运行 logstash，然后在 ES head 插件中确认索引及数据是否写入。


# 遇到的问题

1. 配置文件中 if 后面应该接一个 {}，漏写后提示出错
2. 不能写入 ES: `[ type ]` 改成 `[type]` 后还是不行，然后删除了对应的 .sincedb 后可以了


# Ref
[Codec plugins » multiline](https://www.elastic.co/guide/en/logstash/current/plugins-codecs-multiline.html)  


