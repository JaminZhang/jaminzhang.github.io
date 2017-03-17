---
layout: post
title: ELK-生产测试遇到的问题及解决
description: "ELK-生产测试遇到的问题及解决"
category: ELK
avatarimg:
tags: [ELK, TroubleShooting, Production, Logstash]
duoshuo: true
---


ELK-生产测试遇到的问题及解决

# 引言

这几天在生产环境上部署 ELK 架构，遇到了一些问题。  
这里就将它们整理记录一下以备忘。  

# 1. Logstash 报错: A plugin had an unrecoverable error. Will restart this plugin

<pre>

{:timestamp=>"2016-10-21T03:32:02.438000+0800", :message=>"A plugin had an unrecoverable error. Will restart this plugin.\n  Plugin: <LogStash::Inputs::Beats port=>5044, codec=><LogStash::Codecs::JSON charset=>\"UTF-8\">, host=>\"0.0.0.0\", ssl=>false, ssl_verify_mode=>\"none\", include_codec_tag=>true, ssl_handshake_timeout=>10000, congestion_threshold=>5, target_field_for_codec=>\"message\", tls_min_version=>1, tls_max_version=>1.2, cipher_suites=>[\"TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA38\", \"TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384\", \"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256\", \"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256\", \"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384\", \"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384\", \"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256\"], client_inactivity_timeout=>15>\n  Error: event executor terminated", :level=>:error}

</pre>


以上是故障日志，但看 ES 写入日志数据是正常的。

排查过程：  

根据最小化原则，一步步精简 Logstash shipper.conf 配置文件，input 部分精简到如下，也检查了配置文件：

```bash

input {
  beats {
    port => 5044			
    codec => "json"
  }
}
[root@Elk-logstash-shipping logstash]# /etc/init.d/logstash configtest
Configuration OK

```    

还是报以上错误，排查了很久，实在没想到哪里的错误。  
这样到了第二天，重新开始了排查。  

首先查看 Logstash Input Beats 插件的端口监听。我停止了 Logstash，怎么还有 5044 端口监听？  

于是查看监听 5044 端口的相关连接，有很多：

```bash

[root@Elk-logstash-shipping ~]# lsof -i:5044
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
java    12180 root  132u  IPv4 152615      0t0  TCP htuidc.bgp.ip:lxi-evntsvc->htuidc.bgp.ip:57322 (ESTABLISHED)
java    12180 root  135u  IPv4  44200      0t0  TCP *:lxi-evntsvc (LISTEN)
java    12180 root  139u  IPv4 152626      0t0  TCP htuidc.bgp.ip:lxi-evntsvc->htuidc.bgp.ip:46323 (ESTABLISHED)
...省略...

```

再查看对应的进程，原来如此，这是个前台测试的 Logstash 进程还在运行，  
我记起当时前台测试时，终端异常断开了网络连接，导致这个前台测试的 LogStash 进程还在运行。    
然后这个 Logstash 进程测试读取的是 `/etc/logstash/conf.d/filebeat.conf` 和 shipper.conf 配置文件有冲突，
里面的 Input 部分是相同的。

**解决方法：**  
杀掉这个没有正常关闭的前台测试 Logstash 进程，然后 `/etc/init.d/logstash restart` 重启 Logstash。  

```bash

[root@Elk-logstash-shipping ~]# ps aux | grep 12180
root     12180  1.6  4.5 6912300 744896 ?      Sl   Oct18  69:39 /usr/bin/java -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+HeapDumpOnOutOfMemoryError -Xmx1g -Xss2048k -Djffi.boot.library.path=/opt/logstash/vendor/jruby/lib/jni -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/logstash/heapdump.hprof -Xbootclasspath/a:/opt/logstash/vendor/jruby/lib/jruby.jar -classpath : -Djruby.home=/opt/logstash/vendor/jruby -Djruby.lib=/opt/logstash/vendor/jruby/lib -Djruby.script=jruby -Djruby.shell=/bin/sh org.jruby.Main --1.9 /opt/logstash/lib/bootstrap/environment.rb logstash/runner.rb agent -f /etc/logstash/conf.d/filebeat.conf
root     16921  0.0  0.0 103244   864 pts/2    S+   15:28   0:00 grep 12180
[root@Elk-logstash-shipping ~]# kill 12180

```    

**获得的经验：**  
之前也碰过类似这个问题， `/etc/logstash/conf.d/` 目录下只能有 Logstash 的 YAML 格式的配置文件，不能有其他格式的文件。
这次是有 2 个 YAML 格式的 Logstash 配置文件，但它们的内容是冲突的，所以最好在 `/etc/logstash/conf.d/` 目录下只放一个配置文件。

