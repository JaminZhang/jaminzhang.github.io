---
layout: post
title: Logstash 收集系统日志
description: "Logstash 收集系统日志"
category: ELK
avatarimg:
tags: [ELK, Logstash]
duoshuo: true
---

Logstash 收集系统日志

# Logstash 事件及 Pipeline 简介

1. Logstash 收集数据是按照事件，事件不只是一行，可以包含多行
2. input output 是 Logstash Pipeline 必须存在的
3. Pipeline 流程： event -> input -> codec -> filter -> codec -> output

# Logstash 收集系统日志

系统日志一般存放在对应的文件中，如 /var/log/messages 等，  
我们可以使用 Logstash input 插件中的 file 插件来收集文件中的数据

```bash
[root@linux-node1 /etc/logstash/conf.d]# cat file.conf 
input {
    file {
        path => ["/var/log/messages","/var/log/secure"]
        type => "system-log"
        start_position => "beginning"
    }
}

filter {
}

output {
    elasticsearch {
        hosts => ["192.168.56.11:9200"]
        index => "system-log-%{+YYYY.MM}"
    }
}
```    

上面的配置文件实现了收集系统日志文件中的数据，然后写入到 ES 中。

> 
系统日志一般比较小，可以每月一个索引。
测试时在前台指定 file.conf 调试运行 logstash，然后在 ES head 插件中确认索引及数据是否写入。

# Ref
[ Input plugins » file](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-file.html)  

