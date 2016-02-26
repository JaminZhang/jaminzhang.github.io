---
layout: post
title:  CentOS 7下yum安装MariaDB
description: " CentOS 7下yum安装MariaDB"
category: MySQL
avatarimg:
tags: [Database,MySQL,MariaDB]
duoshuo: true
---

# 引言
之前测试mysqldump的导入，需要另外一台数据库，自己有一台CentOS 7系统的服务器。  
于是需要在CentOS 7安装mysql，之前并没有怎么使用CentOS 7。而且CentOS 7下mysql下替换成MariaDB了（MariaDB是从MySQL fork过来的，和MySQL有很好的兼容性 ）。所以这里记录下。

# CentOS 7下yum安装MariaDB
由于作为测试服务器使用，所以使用yum快速安装。如下：
<pre>
yum install mariadb mariadb-server
systemctl start mariadb   #启动mariadb
systemctl enable mariadb  #设置开机自启动
mysql_secure_installation #设置root密码等相关
mysql -uroot -p           #测试登录
</pre>

# Ref
[MariaDB Wikipedia](https://en.wikipedia.org/wiki/MariaDB)  
[About MariaDB](https://mariadb.org/about/)  
[centos7下yum快速安装 mariadb（mysql）](http://www.centoscn.com/CentosServer/sql/Mariadb/2015/0520/5483.html)  

