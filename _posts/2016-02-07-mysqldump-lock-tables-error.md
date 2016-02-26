---
layout: post
title: mysqldump锁表出错及解决方法
description: "mysqldump锁表出错及解决方法"
category: MySQL
avatarimg:
tags: [Database,MySQL,mysqldump]
duoshuo: true
---


# 引言
研发需要某个MySQL的表，需要运维这边导出来提供给他们。  

# 问题
一般使用mysqldump命令即可，但从生产环境直接导出表有报错，如下：
> 
mysqldump: Got error: 1044: Access denied for user 'xxx'@'xxx' to database 'xxx' when using LOCK TABLES

# 分析
从以下报错可以判断mysqldump使用的用户没锁表权限。  
登录到mysql下可以确认。
<pre>
*************************** 8. row ***************************
                  Host: 127.0.0.1
                  User: xxx
              Password: *xxx
           Select_priv: Y
           Insert_priv: Y
           Update_priv: Y
           Delete_priv: Y
           Create_priv: Y
             Drop_priv: Y
           Reload_priv: Y
         Shutdown_priv: N
          Process_priv: N
             File_priv: N
            Grant_priv: Y
       References_priv: N
            Index_priv: Y
            Alter_priv: Y
          Show_db_priv: N
            Super_priv: Y
 Create_tmp_table_priv: N
      Lock_tables_priv: N
          Execute_priv: Y
       Repl_slave_priv: N
      Repl_client_priv: N
      Create_view_priv: Y
        Show_view_priv: Y
   Create_routine_priv: Y
    Alter_routine_priv: Y
      Create_user_priv: Y
            Event_priv: N
          Trigger_priv: Y
Create_tablespace_priv: N
              ssl_type: 
14 rows in set (0.00 sec)
</pre>

# 解决方法
授予用户锁表权限即可。

网上有人说使用--skip-lock-tables，这个会影响数据的一致性(可能比丢数据还要遭糕)，故不推荐使用这个方法。
--single-transaction用于Innodb引擎的数据库dump时，可以不锁表。

mysql锁表原理深入下去还有很多细节可以学习，可以参考Ref相关资料。

# Ref 
[mysqldump备份数据库时出现when using LOCK TABLES的提示](http://mysqldba.blog.51cto.com/6728219/1329206)  
[对mysqldump在备份数据库时锁表的认识](http://www.freeoa.net/osuport/db/mysqldump-lock-on-backup_1453.html)  
[mysql - Run MySQLDump without Locking Tables - Stack Overflow](http://stackoverflow.com/questions/104612/run-mysqldump-without-locking-tables)  
[mysqldump — A Database Backup Program](http://dev.mysql.com/doc/refman/5.7/en/mysqldump.html#option_mysqldump_single-transaction)  
[Best kept MySQLDump Secret - MySQL Performance Blog](https://www.percona.com/blog/2012/03/23/best-kept-mysqldump-secret/)  
[mysqldump的流程 | P.Linux Laboratory](http://www.penglixun.com/tech/database/the_process_of_mysqldump.html)  
[mysql中lock tables与unlock tables(锁表/解锁)使用总结](http://www.111cn.net/database/mysql/55482.htm)  



