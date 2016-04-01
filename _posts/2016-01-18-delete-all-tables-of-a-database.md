---
layout: post
title: 删除一个数据库中的所有表
description: "删除一个数据库中的所有表"
category: MySQL
avatarimg:
tags: [Database,MySQL]
duoshuo: true
---

# 引言
研发有个清档的需求，就删除数据库中所有的表，这个我之前没碰到过。  
第一想法就是直接删除数据库，然后再创建数据库，这个比较简单直接，然后实施起来也是这么做的。
如果我就是想删除所有的数据表，应该有方法。

# 不删除数据库删除所有表
## 使用information_schema库的方案
> 
select concat('drop table ', table_name, ';') from information_schema.tables where table_schema='数据库名';

通过这条命令来得到drop table 表名;这样的语句，然后批量执行。 
去掉第一行，后面就是删除指定数据库中的所有表。可以手动删，如果表数量很多，可以使用Shell脚本for循环来执行删除。

# Ref
[mysql删除所有表不删除数据库方法](http://blog.5ibc.net/p/20280.html)  

