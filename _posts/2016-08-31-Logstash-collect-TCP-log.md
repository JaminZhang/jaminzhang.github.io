---
layout: post
title: Logstash 收集 TCP 日志
description: "Logstash 收集 TCP 日志"
category: ELK
avatarimg:
tags: [ELK, Logstash, TCP]
duoshuo: true
---

# 编写收集 TCP 日志的 Logstash 配置文件

```bash

[root@linux-node2 ~]# cat /etc/logstash/conf.d/tcp.conf 
input {
  tcp {
    type => "tcp"
    port => 6666
    mode => "server"
  }
}

output {
  stdout {
    codec => rubydebug
  }
}

```    

# 前台方式测试 Logstash 是否正常收集 TCP 日志

```bash

# 前台方式启动，输出到标准输出，先确保能收集

[root@linux-node2 conf.d]# /opt/logstash/bin/logstash -f tcp.conf 
Settings: Default pipeline workers: 1
Pipeline main started

# 启动 logstash 后，可以看到在监听上面配置的 6666 端口
[root@linux-node2 ~]# netstat -lntup | grep 6666
tcp        0      0 0.0.0.0:6666            0.0.0.0:*               LISTEN      41206/java 

# 在 192.168.56.11 上使用 nc 等方式发送测试信息到 logstash

[root@linux-node1 ~]# yum install nc -y
[root@linux-node1 ~]# echo "Test Logstash TCP Input Plugin" | nc 192.168.56.12 6666
[root@linux-node1 ~]# nc 192.168.56.12 6666 < /etc/resolv.conf
[root@linux-node1 ~]# echo "Test Logstash TCP Input Plugin 02" > /dev/tcp/192.168.56.12/6666

# 确认 logstash 前台运行时标准输出可以接收到 TCP 日志后，
# 我们再将 logstash 配置文件 syslog.conf 中的 output 部分修改如下（这样将收集到的 TCP 日志写入到 ES）:

[root@linux-node2 ~]# cat /etc/logstash/conf.d/tcp.conf 
input {
  tcp {
    type => "tcp"
    port => 6666
    mode => "server"
  }
}

output {
  elasticsearch {
    hosts => ["192.168.56.12:9200"]
    index => "tcp-log-%{+YYYY.MM}"    
  }
}

```    

# 后台运行 Logstash，确认索引数据写入到 ES

重启运行 Logstash，然后在 ES head 插件中确认索引及数据是否写入。  

# Kibana 中配置索引

确认数据写入 ES 后，在 Kibana 中添加配置索引。

>
通过 TCP 方式发送日志的一个用途是不用启动一个 Agent 然后进行 Logstash 配置，就可以简单地回补丢失的重要的日志数据。
ES 中日志没有顺序的概念。写入 ES 的日志一般是乱序的。

# Ref
[TCP](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-tcp.html)  

