---
layout: post
title: mysql Duplicate entry for key错误提示
description: "mysql Duplicate entry for key错误提示"
category: MySQL
avatarimg:
tags: [Database,MySQL]
duoshuo: true
---

# 引言
今天上午，游戏服务器某业务进程挂掉了，原因是这台服务器上开的游戏区服较多，内存不够导致的，为什么会多开较多呢？  
因为到了游戏运营后期，为了充分利用服务器资源，就会在一台服务器上多开游戏区服。回到今天的正题上来，既然是内存不足的原因，  
我们的解决办法就是将其中一个区服迁移到其他内存充足的服务器上去。
但在迁移过程中遇到了下面的问题。

# 远程恢复mysql数据库的错误提示
上面说的迁移是在我们的云游戏平台上进行操作，迁移其中一个区服过程中出现了问题，查看日志如下：
<pre>
2016-02-06 11:14:06: start recovery database from 42.51.xx.xx database xx0182
Warning: Using a password on the command line interface can be insecure.
ERROR 1062 (23000) at line 1260: Duplicate entry 's182.涓╓innie涓' for key 'actor_name'
</pre>

从上面日志可以看出对于字段actor_name有重复条目，我们查看下其所属的actor_fixed表的结构和重复的actor_name字段内容，如下：

<pre>
gameop_ops@127.0.0.1:xx018203:26:15>select actor_name from actor_fixed where actor_name like "%Winnie%";
+-----------------+
| actor_name      |
+-----------------+
| s182.丨winnie   |
| s182.丨Winnie丨 |
| s182.丨Winnie丶 |
+-----------------+
gameop_ops@127.0.0.1:xx018203:28:51>desc actor_fixed;
+-------------------+---------------------+------+-----+-------------------+-------+
| Field             | Type                | Null | Key | Default           | Extra |
+-------------------+---------------------+------+-----+-------------------+-------+
| actor_id          | bigint(20) unsigned | NO   | PRI | NULL              |       |
| platform          | varchar(20)         | NO   | MUL | NULL              |       |
| account_name      | varchar(40)         | NO   |     |                   |       |
| actor_name        | varchar(23)         | NO   | UNI | NULL              |       |
| actor_sex         | tinyint(3) unsigned | NO   |     | 1                 |       |
| actor_profession  | tinyint(3) unsigned | NO   |     | 0                 |       |
| actor_via         | varchar(32)         | NO   |     |                   |       |
| actor_create_ip   | int(10) unsigned    | NO   |     | NULL              |       |
| actor_create_time | timestamp           | NO   |     | CURRENT_TIMESTAMP |       |
| server_id         | int(10) unsigned    | NO   |     | 0                 |       |
+-------------------+---------------------+------+-----+-------------------+-------+
10 rows in set (0.00 sec)
</pre>

从上面输出可以看到，actor_name字段是唯一键，创建时的三个actor_name其实是不同的，但mysql远程恢复过程中，并没有识别出来这三个actor_name的不同，认为它们是重复的。（PS:初步判断是mysqldump导出和mysql导入时使用的默认字符集不一致引起的？暂时没验证。）  

临时的简单快速解决方案是直接迁移另外一个区服的数据库，不迁移有这个错误提示的区服，之前这种情况好像比较少见。


# Ref
[mysql提示 Duplicate entry..for key错误解决办法](http://www.111cn.net/database/mysql/50742.htm)  

