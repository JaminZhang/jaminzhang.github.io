---
layout: post
title: Logstash 使用 Grok 收集 Apache 日志
description: "Logstash 使用 Grok 收集 Apache 日志"
category: ELK
avatarimg:
tags: [ELK, Logstash, Grok, Apache]
duoshuo: true
---

Logstash 使用 Grok 收集 Apache 日志


# Logstash Filter 插件 Grok 简介

Grok 插件能够解析任意的文本和结构化它们。  
Grok 是当前在 logstash 中最好的方式解析糟糕的非结构化的日志数据成结构化的和可查询的。  
这个工具对于以下日志非常适用： syslog 日志，apache 和其他一些 webserver 日志，mysql 日志，还有其他通常是任何人类可读但不是电脑消费的日志格式。  
Logstash 默认自带了大约 120 种匹配模式。  
如果你需要构建模式匹配你自己的日志，你可以使用下面 2 个有用的工具应用。  
http://grokdebug.herokuapp.com
http://grokconstructor.appspot.com/ 
	

Nginx 的访问日志本身支持 JSON 格式，Logstash 也有 Input 的 JSON 插件。
但 Apache 默认的访问日志格式本身并不支持 JSON，可以使用本文谈到的 Filter Grok 插件来对其进行格式化后再写入 ES 中。

# 1. 前台测试 Logstash Grok 插件过滤 Apache 访问日志


```bash
# 192.168.56.11 上安装 httpd
yum install httpd -y

# 查看 /etc/httpd/conf/httpd.conf 配置文件 LogFormat 定义部分

    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

# 启动 httpd
systemclt start httpd

# 我们可以先看看 grok 自带的预定义的匹配模式
[root@linux-node2 patterns]# pwd
/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-patterns-core-2.0.5/patterns
[root@linux-node2 patterns]# ll
total 96
-rw-r--r-- 1 logstash logstash 1197 Jul  7 08:02 aws
-rw-r--r-- 1 logstash logstash 4831 Jul  7 08:02 bacula
-rw-r--r-- 1 logstash logstash 2154 Jul  7 08:02 bro
-rw-r--r-- 1 logstash logstash  879 Jul  7 08:02 exim
-rw-r--r-- 1 logstash logstash 9544 Jul  7 08:02 firewalls
-rw-r--r-- 1 logstash logstash 6008 Jul  7 08:02 grok-patterns
-rw-r--r-- 1 logstash logstash 3251 Jul  7 08:02 haproxy
-rw-r--r-- 1 logstash logstash 1339 Jul  7 08:02 java
-rw-r--r-- 1 logstash logstash 1087 Jul  7 08:02 junos
-rw-r--r-- 1 logstash logstash 1037 Jul  7 08:02 linux-syslog
-rw-r--r-- 1 logstash logstash   49 Jul  7 08:02 mcollective
-rw-r--r-- 1 logstash logstash  190 Jul  7 08:02 mcollective-patterns
-rw-r--r-- 1 logstash logstash  614 Jul  7 08:02 mongodb
-rw-r--r-- 1 logstash logstash 9597 Jul  7 08:02 nagios
-rw-r--r-- 1 logstash logstash  142 Jul  7 08:02 postgresql
-rw-r--r-- 1 logstash logstash  845 Jul  7 08:02 rails
-rw-r--r-- 1 logstash logstash  104 Jul  7 08:02 redis
-rw-r--r-- 1 logstash logstash  188 Jul  7 08:02 ruby

# 其中 Apache 访问日志的匹配模式在 grok-patterns 文件中有定义
[root@linux-node2 patterns]# grep APACHE grok-patterns 
COMMONAPACHELOG %{IPORHOST:clientip} %{HTTPDUSER:ident} %{USER:auth} \[%{HTTPDATE:timestamp}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{NUMBER:bytes}|-)
COMBINEDAPACHELOG %{COMMONAPACHELOG} %{QS:referrer} %{QS:agent}

# 下面编写 Grok 匹配过滤 Apache 日志的 Logstash 配置文件

[root@linux-node1 conf.d]# cat grok.conf 
input {
  stdin {}
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
}

output {
  stdout {
    codec => rubydebug
  }
}

# 先在前台运行 Logstash 然后在标准输入和输出测试

[root@linux-node1 conf.d]# /opt/logstash/bin/logstash -f grok.conf 
Settings: Default pipeline workers: 1
Pipeline main started
192.168.56.1 - - [09/Oct/2016:17:54:34 +0800] "GET /piwik/piwik.js HTTP/1.1" 404 212 "http://jaminzhang.github.io/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36"
{
        "message" => "192.168.56.1 - - [09/Oct/2016:17:54:34 +0800] \"GET /piwik/piwik.js HTTP/1.1\" 404 212 \"http://jaminzhang.github.io/\" \"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36\"",
       "@version" => "1",
     "@timestamp" => "2016-10-11T03:55:48.699Z",
           "host" => "linux-node1",
       "clientip" => "192.168.56.1",
          "ident" => "-",
           "auth" => "-",
      "timestamp" => "09/Oct/2016:17:54:34 +0800",
           "verb" => "GET",
        "request" => "/piwik/piwik.js",
    "httpversion" => "1.1",
       "response" => "404",
          "bytes" => "212",
       "referrer" => "\"http://jaminzhang.github.io/\"",
          "agent" => "\"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36\""
}

# 可以从上面的标准输出中看到 Grok 匹配过滤生效了。
```    

>
生产上使用 Grok 插件时需考虑过滤时的性能影响，有一种用法是用 Python 等程序来实现日志过滤，  
运行多个 Python 程序来提高性能。


# 2. 前台方式测试 Logstash 能正常收集 Apache 日志

```bash
# 下面继续编写 Logstash 配置文件，将实际的 Apache 访问日志文件作为 Input 

[root@linux-node1 conf.d]# cat apache_grok.conf
input {
  file {
    path => "/var/log/httpd/access_log"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
}

output {
  stdout {
    codec => rubydebug
  }
}

[root@linux-node1 conf.d]# /opt/logstash/bin/logstash -f apache_grok.conf

# 如果配置正确，前台启动后，会读取 Apache 访问日志文件并过滤解析输出到标准输出
```    

# 3. 测试运行 Logstash 能正常收集 Apache 日志并写入到 ES

```bash    
# 继续修改 apache_grok.conf，配置 output 输出到 ES 中，如下
[root@linux-node1 conf.d]# cat apache_grok.conf 
input {
  file {
    path => "/var/log/httpd/access_log"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
}

output {
  elasticsearch {
    hosts => ["192.168.56.11:9200"]
    index => "apache-access-log-%{+YYYY.MM.dd}"
  }
}

[root@linux-node1 conf.d]# /opt/logstash/bin/logstash -f apache_grok.conf

# 启动 Logstash 后，使用 ab 产生一些 Apache 200 和 404 的访问日志
[root@linux-node1 conf.d]# ab -n 1000 -c 10 http://192.168.56.11:80/
[root@linux-node1 conf.d]# ab -n 500 -c 10 http://192.168.56.11:80/404

# 然后在 ES head 插件中确认索引及数据是否写入。确认好后，在 Kibana 中配置。
```    

# 4. Kibana 中添加索引并配置一个饼图

![Kibana-Configure-apache-index-pattern](http://jaminzhang.github.io/images/ELK/Kibana-Configure-apache-index-pattern.png)  
![Kibana-Pie-chart-01](http://jaminzhang.github.io/images/ELK/Kibana-Pie-chart-01.png)  
![Kibana-Pie-chart-02](http://jaminzhang.github.io/images/ELK/Kibana-Pie-chart-02.png)  


# Ref
[Logstash Reference [2.4] » Filter plugins » grok](https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html)  
