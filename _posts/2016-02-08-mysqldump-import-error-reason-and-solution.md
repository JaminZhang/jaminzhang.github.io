---
layout: post
title: mysqldump导入表出错原因及解决方法
description: "mysqldump导入表出错原因及解决方法"
category: MySQL
avatarimg:
tags: [Database,MySQL,mysqldump]
duoshuo: true
---

# 引言
之前说过mysqldump导出数据库表给研发，但研发反馈导入表出错了。  
提示如下：
> 
Unknown command '\"'

# 分析
使用mysqldump导出数据表时没有指定默认字符集，根据mysqldump的配置，如果没有指定字符集，就会使用默认的UTF8。
<pre>
--default-character-set=charset_name
Use charset_name as the default character set. See Section 10.5, “Character Set Configuration”. If no character set is specified, mysqldump uses utf8.
</pre>

根据我的测试，能正常导入，（导出表的sql时没有指定字符集，但导出后的sql中建表语句中有指定字符集，再另外的数据库导入时也没有指定字符集，并没有报错，从这个现象来看，导出特定表时不需要指定字符集？），但研发那边反映将字符集改成latin1可以正常导入。(PS：这里研发说的暂时无法解释。)

# 可能原因及解决方法
这个有些时候是由于导出端和导入端的字符集不同导致的。
解决方案：在导出的时候添加默认字符集。  在导入的时候添加相同字符集。


# Ref 
[MySQL :: MySQL 5.7 Reference Manual :: 10.5 Character Set Configuration](http://dev.mysql.com/doc/refman/5.7/en/charset-configuration.html)  
[mysql导入提示Unknown command '\"' 错误即mysqldump说明](http://chenchao40322.blog.51cto.com/2181131/407699)  
[修改及查看mysql数据库的字符集 - donqiang - 博客园](http://www.cnblogs.com/donqiang/articles/2057972.html)   
