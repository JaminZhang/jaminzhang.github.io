---
layout: post
title: Logstash 收集 Nginx 访问日志
description: "Logstash 收集 Nginx 访问日志"
category: ELK
avatarimg:
tags: [ELK, Logstash, Nginx, codec, JSON]
duoshuo: true
---

Logstash 收集 Nginx 访问日志

# 安装配置 Nginx 访问日志为 json 格式

我们先在 192.168.56.12 安装 Nginx。  
Nginx 的访问日志，如果 Logstash 直接收集，不做分字段处理的话，意义不大。

>
生产环境下的日志标准化包括：目录及文件的命名、日志数据为 json 格式


nginx.conf 配置如下 log_format 和 access-log ：

```bash

access_log_json 
log_format  access_log_json  '{"user_ip":"$http_x_real_ip","lan_ip":"$remote_addr","log_time":"$time_iso8601","user_req":"$request","http_code":"$status","body_bytes_sent":"$body_bytes_sent","req_time":"$request_time","user_ua":"$http_user_agent"}';

access_log /var/log/nginx/access_log_json.log access_log_json

```    

>
如果要将加密日志或 URL 后面的参数转换成 json 格式的数据，  
codec 插件不好实现，可以自己写 Python 脚本实现，生产上有人这样做，  
将日志写到 Redis，再用 Python 处理成 json 格式  


# 配置 input file 插件中使用 codec json 插件

如下：

```bash

[root@linux-node1 /etc/logstash/conf.d]# cat nginx.conf 
input {
    file {
        path => ["/var/log/nginx/access_log_json.log"]
        codec => "json"
        type => "nginx-access-log"
    }
}

filter {
}

output {
    elasticsearch {
        hosts => ["192.168.56.11:9200"]
        index => "nginx-access-log-%{+YYYY.MM.dd}"
        }
}

```    

测试时在前台指定 nginx.conf 调试运行 logstash，  
执行以下测试命令产生访问日志 `ab -n 1000 -c 1 http://192.168.56.12/`  
然后在 ES head 插件中确认索引及数据是否写入。

还有另外几种方法可以收集 Nginx 访问日志，可以参考 Ref 中的资料。

# Ref
[Codec plugins » json](https://www.elastic.co/guide/en/logstash/current/plugins-codecs-json.html)  
[Nginx 访问日志](http://kibana.logstash.es/content/logstash/examples/nginx-access.html)  
