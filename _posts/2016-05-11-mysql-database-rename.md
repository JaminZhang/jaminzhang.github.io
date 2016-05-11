---
layout: post
title: mysql数据库重命名
description: "mysql数据库重命名"
category: MySQL
avatarimg:
tags: [Database,MySQL]
duoshuo: true
---

# 引言
某业务标识改名，导致各种配置需要修改（1、服务器域名 2、游戏程序及配置文件 3、各种运维脚本 4、相关数据库名）！  
这相当于新配置一个业务的工作量啊，实在是坑！  
我将上面的各种配置进行修改，现在到了修改数据库名（使用的mysql数据库）这一步。

# mysql数据库重命名方法

## 1.直接对数据库进行重命名
（经测试该方法在5.6.15版本中不可用）

> 
RENAME {DATABASE | SCHEMA} db_name TO new_db_name;  

> 
This statement was added in MySQL 5.1.7 but was found to be dangerous and was removed in MySQL 5.1.23. 
However, use of this statement could result in loss of database contents, which is why it was removed. 
Do not use RENAME DATABASE in earlier versions in which it is present.

这个语法在mysql 5.1.7中被添加进来，到了5.1.23又去掉了。有可能丢失数据。

## 2.通过mysqldump进行数据库的备份再导入
（当数据库较大的时候，这种方法耗时耗力）

## 3.重命名数据库里面的所有表

information_schema数据库table表记录了数据库中所有表的信息

> 
1、CREATE DATABASE new_db_name;  #创建新的数据库  
2、RENAME TABLE db_name.table1 TO new_db_name.table1;   #对所有的表进行重命名  
3、DROP DATABASE db_name;            #删除原来的数据库  

>
当数据库表包含表很多的情况下，这样操作是比较效率也比较低，可以通过以下脚本进行批量修改:  
mysql -uroot -p -e "select concat('rename table db.',table_name,' to new_db.',table_name,';') from information_schema.TABLES where TABLE_SCHEMA='db';" > rename_mysql_name.sql

> 
执行sql语句  
mysql -uroot -p < rename_mysql_name.sql   #批量进行修改


## 总结

>
以上几种的操作方法，其中第二种的方法是最保险的，这也是很多公司进行小数据库备份还原的一种方式。
第三种方法虽然速度较快但是风险也相对较大，会导致一些视图不能用，因为视图的名称虽然变了，但是视图里面引用的表还是原来数据库的表，  
所以用这种方式进行迁移的时候就需要检查数据库视图的情况


# Ref
[MySQL数据库重命名的方法](http://blog.itpub.net/12679300/viewspace-1699283/)  
[RENAME DATABASE Syntax](https://dev.mysql.com/doc/refman/5.1/en/rename-database.html)  
[How do I quickly rename a MySQL database (change schema name)?](http://stackoverflow.com/questions/67093/how-do-i-quickly-rename-a-mysql-database-change-schema-name)  
[How to rename a MySQL database?](http://serverfault.com/questions/195221/how-to-rename-a-mysql-database)  
[重命名mysql数据库的五个方法](http://www.weste.net/2013/3-26/89895.html)  
[mysql能给数据库改名吗](http://www.itpub.net/thread-1408727-1-1.html)  


