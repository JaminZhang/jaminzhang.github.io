---
layout: post
title: Sonar 安装
description: "Sonar 安装"
category: CI/CD
avatarimg:
tags: [CI/CD, Sonar]
duoshuo: true
---

# 环境准备

新版本 Sonar 需要 JDK 的版本为 1.8 及以上。

```bash
[root@linux-node1 ~]# yum install java-1.8.0 -y

# 官网下载 SonarQube 5.6 (LTS *)
[root@linux-node1 ~]# cd /usr/local/src/
[root@linux-node1 src]# wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-5.6.zip
[root@linux-node1 src]# unzip sonarqube-5.6.zip
[root@linux-node1 src]# mv sonarqube-5.6 /usr/local/
[root@linux-node1 src]# ln -s /usr/local/sonarqube-5.6/ /usr/local/sonarqube

```    

# 安装配置数据库

本文使用 Mariadb。  
创建 Sonar 使用的数据库和用户，如下：

```bash
MariaDB [(none)]> create database sonar character set utf8 collate utf8_general_ci;
Query OK, 1 row affected (0.02 sec)

MariaDB [(none)]> grant all on sonar.* to 'sonar'@'localhost' identified by 'sonar@pw';
Query OK, 0 rows affected (0.05 sec)

MariaDB [(none)]> grant all on sonar.* to 'sonar'@'%' identified by 'sonar@pw';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> flush privileges;
Query OK, 0 rows affected (0.00 sec)

```    

# 配置 Sonar

配置 Sonar 数据库连接

```bash
[root@linux-node1 ~]# cd /usr/local/sonarqube/conf/
[root@linux-node1 conf]# ls
sonar.properties  wrapper.conf
[root@linx-node1 conf]# vim sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=sonae@pw
sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance
```    

配置 Java 访问数据库驱动(可选)  

默认情况 Sonar 有自带的嵌入的数据库，那么你如果使用 Oracle 数据库，必须手动复制驱动类到${SONAR_HOME}/extensions/jdbc-driver/oracle/目录下，其它支持的数据库默认提供了驱动。其它数据库的配置可以参考官方文档：
http://docs.sonarqube.org/display/HOME/SonarQube+Platform


# 启动 Sonar

可以在 Sonar 的配置文件来配置 Sonar Web Server 监听的 IP 地址和端口，默认是 9000 端口。如下：

```bash
[root@linx-node1 conf]# vim sonar.properties
sonar.web.host=0.0.0.0
sonar.web.port=9000

[root@linux-node1 ]# /usr/local/sonarqube/bin/linux-x86-64/sonar.sh start
Starting SonarQube...
Started SonarQube.

```    


# 遇到的问题

```bash
2016.08.12 15:55:13 INFO  web[o.s.s.p.ServerImpl] SonarQube Server / 5.6.1 / 07c82b2477ac69126115671fe56d53c2ff47d5f5
2016.08.12 15:55:13 INFO  web[o.sonar.db.Database] Create JDBC data source for jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance
2016.08.12 15:55:13 ERROR web[o.a.c.c.C.[.[.[/]] Exception sending context initialized event to listener instance of class org.sonar.server.platform.PlatformServletContextListener
org.sonar.api.utils.MessageException: Unsupported mysql version: 5.5. Minimal supported version is 5.6.
2016.08.12 15:55:13 ERROR web[o.a.c.c.StandardContext] One or more listeners failed to start. Full details will be found in the appropriate container log file
2016.08.12 15:55:44 INFO  web[o.a.c.u.SessionIdGeneratorBase] Creation of SecureRandom instance for session ID generation using [SHA1PRNG] took [31,150] milliseconds.
2016.08.12 15:55:44 ERROR web[o.a.c.c.StandardContext] Context [] startup failed due to previous errors
```    

使用 SonarQube 5.6.1 报错提示不支持 mysql 5.5，最低版本为 mysql 5.6。官方回答不支持 mysql 5.5 原因如下：

[MySQL 5.6 required](https://groups.google.com/forum/#!topic/sonarqube/GmbtZ_qf1ME)    
<pre>
Hi guys,

The upgrade guide does not mention this point. It was forgotten and it's going to be fixed. Thanks for the feedback.

There are multiple reasons why we don't support versions lower than MySQL 5.6:
Mysql  stopped the "premier support" for v5.5, extended support is still active but this version begins to reach its end of live.

we experimented bad performances with v5.5

v5.6 resolves a lot of 5.5 bugs

we support only the databases and versions that are covered by our automated tests. It allows to deliver to our community of users 
the most stable product as possible. Please believe me, it requires a lot of effort and during dark days I dream to fully drop support 
of mysql :-) Moreover as the matrix of compatibility in our tests becomes huge, support of new versions, for example Oracle 12c 
or mysql 5.7, usually comes with the removal of old versions.

@Petr, well, I'm quite surprised that mysql 5.1 was supported for such a long time !! :-) I would not recommend it in production.
Regards

Simon BRANDHOF | SonarSource
</pre>

由于本文演示 SonarQube 部署，使用 SonarQube 5.6 是可以支持 mysql 5.5 的。所以本次就使用 SonarQube 5.6。  
如果要使用 SonarQube 5.6.1 及以后的版本，则要使用 mysql 的最小版本为 5.6。

# Ref
[Installing the Server](http://docs.sonarqube.org/display/SONAR/Installing+the+Server)  
[持续代码质量管理-Sonar部署](https://www.unixhot.com/article/56)  
[MySQL 5.6 required](https://groups.google.com/forum/#!topic/sonarqube/GmbtZ_qf1ME)    

