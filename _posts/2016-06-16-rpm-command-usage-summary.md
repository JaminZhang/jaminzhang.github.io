---
layout: post
title: rpm 命令用法总结
description: "rpm 命令用法总结"
category: Linux
avatarimg: 
tags: [rpm]
duoshuo: true
---

# 引言
继之前一篇写到要总结在工作学习中常用的 yum 命令的文章，这次来写写 rpm 命令的常见用法总结（不定期更新到此篇中）。  

# 1 对已安装软件包信息的查询

```bash
# 查询所有已安装的软件包      
       -a, --all
              Query all installed packages.
# 查询所属文件的软件包，文件名带绝对路径              
       -f, --file FILE
              Query package owning FILE.
# 列出软件包中的所有文件安装到何处              
       -l, --list
              List files in package.
# 显示软件包信息              
       -i, --info
              Display package information, including name, version, and description.  This uses the --queryformat if one was specified.
# 只列出配置文件（和-l起使用）
       -c, --configfiles
              List only configuration files (implies -l).
# 只列出文档文件（和-l起使用）
       -d, --docfiles
              List only documentation files (implies -l).     
# 列出该软件包依赖的包和文件
       -R, --requires
              List capabilities on which this package depends.

```    

实例说明：

```bash
[root@linux-node1 ~]# rpm -qf /etc/zabbix/zabbix_java_gateway.conf
zabbix-java-gateway-3.0.3-1.el7.x86_64
[root@linux-node1 ~]# rpm -ql zabbix-java-gateway 
/etc/zabbix/zabbix_java_gateway.conf
/etc/zabbix/zabbix_java_gateway_logback.xml
/usr/lib/systemd/system/zabbix-java-gateway.service
/usr/lib/tmpfiles.d/zabbix-java-gateway.conf
/usr/sbin/zabbix_java_gateway
/usr/share/doc/zabbix-java-gateway-3.0.3
/usr/share/doc/zabbix-java-gateway-3.0.3/AUTHORS
/usr/share/doc/zabbix-java-gateway-3.0.3/COPYING
/usr/share/doc/zabbix-java-gateway-3.0.3/ChangeLog
/usr/share/doc/zabbix-java-gateway-3.0.3/NEWS
/usr/share/doc/zabbix-java-gateway-3.0.3/README
/usr/share/zabbix-java-gateway
/usr/share/zabbix-java-gateway/bin
/usr/share/zabbix-java-gateway/bin/zabbix-java-gateway-3.0.3.jar
/usr/share/zabbix-java-gateway/lib
/usr/share/zabbix-java-gateway/lib/android-json-4.3_r3.1.jar
/usr/share/zabbix-java-gateway/lib/logback-classic-0.9.27.jar
/usr/share/zabbix-java-gateway/lib/logback-core-0.9.27.jar
/usr/share/zabbix-java-gateway/lib/slf4j-api-1.6.1.jar
/var/log/zabbix
/var/run/zabbix
[root@linux-node1 ~]# rpm -qi zabbix-java-gateway 
Name        : zabbix-java-gateway
Version     : 3.0.3
Release     : 1.el7
Architecture: x86_64
Install Date: Sat 18 Jun 2016 11:48:39 AM CST
Group       : Applications/Internet
Size        : 1326257
License     : GPLv2+
Signature   : DSA/SHA1, Mon 23 May 2016 08:02:14 PM CST, Key ID d13d58e479ea5ed4
Source RPM  : zabbix-3.0.3-1.el7.src.rpm
Build Date  : Mon 23 May 2016 05:04:48 PM CST
Build Host  : build.zabbix.com
Relocations : (not relocatable)
URL         : http://www.zabbix.com/
Summary     : Zabbix java gateway
Description :
Zabbix java gateway
[root@linux-node1 ~]# rpm -qlc zabbix-java-gateway 
/etc/zabbix/zabbix_java_gateway.conf
/etc/zabbix/zabbix_java_gateway_logback.xml
[root@linux-node1 ~]# rpm -qld zabbix-java-gateway 
/usr/share/doc/zabbix-java-gateway-3.0.3/AUTHORS
/usr/share/doc/zabbix-java-gateway-3.0.3/COPYING
/usr/share/doc/zabbix-java-gateway-3.0.3/ChangeLog
/usr/share/doc/zabbix-java-gateway-3.0.3/NEWS
/usr/share/doc/zabbix-java-gateway-3.0.3/README
[root@linux-node1 ~]# rpm -qR zabbix-java-gateway 
/bin/bash
/bin/sh
/bin/sh
/bin/sh
/bin/sh
config(zabbix-java-gateway) = 3.0.3-1.el7
java-headless >= 1.6.0
rpmlib(CompressedFileNames) <= 3.0.4-1
rpmlib(FileDigests) <= 4.6.0-1
rpmlib(PayloadFilesHavePrefix) <= 4.0-1
systemd
systemd
systemd
rpmlib(PayloadIsXz) <= 5.2-1

```    


# Ref
man yum  
[CentOS7中rpm,yum软件安装命令](http://www.centoscn.com/CentOS/help/2015/0827/6073.html)  
