---
layout: post
title: MySQL权限管理
description: "MySQL权限管理"
category: MySQL
avatarimg:
tags: [Database,MySQL]
duoshuo: true
---

# 引言
最近某业务接触MySQL的用户权限比较多，主要是配置业务程序使用的数据库用户权限，  
很多权限具体指什么，突然一时有些忘记了（比如execute），现在我来重新复习学习一下。

# MySQL权限管理学习资料
一查，有很多写得比较好的资料，这里我就站在其他人的肩膀上，就不自己另外总结了。    

[MYSQL数据库管理之权限管理](http://blog.chinaunix.net/uid-20639775-id-3249105.html)  
[MySQL权限体系介绍](http://wolfchen.blog.51cto.com/2211749/1243990)  
[7.2.1 Privileges Provided by MySQL](http://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html)  


学习了上面的资料后，就可以知道execute权限是关于什么了。

> 
The EXECUTE privilege is required to execute stored routines (procedures and functions).

执行存储过程和函数需要EXECUTE权限。



