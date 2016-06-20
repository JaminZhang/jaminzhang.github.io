---
layout: post
title: Zabbix 配置 JMX 监控
description: "Zabbix 配置 JMX 监控"
category: Monitoring
avatarimg: 
tags: [Zabbix, JMX]
duoshuo: true
---


# 1 安装 Zabbix-Java-Gateway

```bash
# 阿里 zabbix yum 源
rpm -ivh http://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm

# 安装 java 环境
yum install java
yum install zabbix-java-gateway
```    

# 2 配置 zabbix_java_gateway.conf

修改配置如下：

```bash
[root@linux-node2 ~]# egrep -v '^#|^$' /etc/zabbix/zabbix_java_gateway.conf 
LISTEN_IP="0.0.0.0"
LISTEN_PORT=10052
PID_FILE="/var/run/zabbix/zabbix_java.pid"
START_POLLERS=5
TIMEOUT=3
```   

# 3 配置 zabbix_server.conf

修改配置如下(关注 Java 相关参数)：

```bash
[root@linux-node1 ~]# egrep -v '^#|^$' /etc/zabbix/zabbix_server.conf
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_server.pid
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
JavaGateway=192.168.56.12
JavaGatewayPort=10052
StartJavaPollers=5
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
AlertScriptsPath=/usr/lib/zabbix/alertscripts
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
```

# 4 Java 应用开启 JMX 协议

## 4.1 Tomcat 开启 JMX 支持

```bash
# 1 安装 java 环境
yum install java

# 2 安装 Tomcat

cd /usr/local/src/
wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.zip

unzip apache-tomcat-8.0.36.zip 
mv apache-tomcat-8.0.36 /usr/local/
ln -s /usr/local/apache-tomcat-8.0.36 /usr/local/apache-tomcat

# 3 Tomcat 配置 JMX 支持

# 修改 apache-tomcat/bin/catalina.sh
# 在 Execute The Requested Command 前加入如下代码（未采用认证加密方式）：

CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote
  -Dcom.sun.management.jmxremote.port=10053
  -Dcom.sun.management.jmxremote.ssl=false
  -Dcom.sun.management.jmxremote.authenticate=false
  -Djava.rmi.server.hostname=192.168.56.12"

# 4 启动或重启 Tomcat

chmod +x /usr/local/apache-tomcat/bin/*.sh

sh /usr/local/apache-tomcat/bin/shutdown.sh
sh /usr/local/apache-tomcat/bin/startup.sh

```    

## 4.2 验证 JMX 连接

### 4.2.1 在 Windows 上通过 jconsole 验证
在 Windows 系统下安装 jdk 后，使用 jconsole 连接 192.168.56.12:10053，开启 JMX 成功后的结果截图如下：
![JMX-jconsole-summary](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/JMX-jconsole-summary.png)  
![JMX-jconsole-VM-summary](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/JMX-jconsole-VM-summary.png)  

### 4.2.2 在 Zabbix Server上通过 cmdline-jmxclient 验证

```bash
[root@linux-node1 ~]# java -jar cmdline-jmxclient-0.10.3.jar - 192.168.56.12:10053 java.lang:type=Memory NonHeapMemoryUsage
06/20/2016 12:05:20 +0800 org.archive.jmx.Client NonHeapMemoryUsage: 
committed: 30015488
init: 2555904
max: -1
used: 28761904

```    

# 5 Zabbix Web 配置 JMX 监控 Java 应用

这里我直接关联 Zabbix 自带的 JMX 通用模板（默认会有些 Key 显示 “Not supported”），  
这需要根据实际情况进行修改配置，获取数据后生成的 Graph 如下所示
![JMX-Zabbix-Template-Items](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/JMX-Zabbix-Template-Items.png)  




当然也可以自己添加相应的 JMX key 和 item  


# 配置过程中遇到的问题

## 1 yum 安装的 tomcat 找不到 catalina.sh
在 /usr/sbin/tomcat 文件开头添加 CATALINA_OPTS JMX 相关参数时并不生效，解决方法：换成从官网下载 Apache Tomcat 8.0.36 软件包使用。

## 2 Windows 10 jdk 1.8.0_91 没有 jconsole
在验证 JMX 连接时，需要使用 jconsole，但我在 Windows 10系统下安装 jdk 1.8.0_91 后，竟然没有 jconsole？ 
Windows 7 系统下安装是有 jconsole。Windows 10 下安装 jdk 1.7 后有 jconsole。


# Ref
[zabbix之通过jmx监控tomcat](http://wangzan18.blog.51cto.com/8021085/1692444)  
[Zabbix监控之JMX协议](http://caisangzi.blog.51cto.com/6387416/1301682)  
[Enabling JMX Remote](http://tomcat.apache.org/tomcat-8.0-doc/monitoring.html#Enabling_JMX_Remote)  
[linux tomcat8 配置 jmx监控](http://it.nfsq.com.cn/index.php/2016/04/17/linux-tomcat8-jmx-monitor/)  

