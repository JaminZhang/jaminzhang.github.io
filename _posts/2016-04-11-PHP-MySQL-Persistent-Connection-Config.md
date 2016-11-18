---
layout: post
title: PHP 的 MySQL 持久连接配置
description: "PHP 的 MySQL 持久连接配置"
category: Web
avatarimg:
tags: [Web, PHP, MySQL, PDO]
duoshuo: true
---

# PHP 数据库持久连接

<pre>

持久的数据库连接是指在脚本结束运行时不关闭的连接。
当收到一个持久连接的请求时，PHP 将检查是否已经存在一个（前面已经开启的）相同的持久连接。
如果存在，将直接使用这个连接；如果不存在，则建立一个新的连接。
所谓“相同”的连接是指用相同的用户名和密码到相同主机的连接。

对 Web 服务器的工作和分布负载没有完全理解的读者可能会错误地理解持久连接的作用。
特别的，持久连接不会在相同的连接上提供建立“用户会话”的能力，也不提供有效建立事务的能力。
实际上，从严格意义上来讲，持久连接不会提供任何非持久连接无法提供的特殊功能。

如果持久连接并没有任何附加的功能，那么使用它有什么好处？

答案非常简单——效率。
当 Web Server 创建到 SQL 服务器的连接耗费(Overhead)较高（如耗时较久，消耗临时内存较多）时，持久连接将更加高效。
Overhead 高低取决于很多因素。例如，数据库的种类，数据库服务和 Web 服务是否在同一台服务器上，SQL 服务器负载状况等。
当 Overhead 较高，每次创建数据库连接成本较高时，持久连接将显著的提高效率。
它使得每个子进程在其生命周期中只做一次连接操作，而非每次在处理一个页面时都要向 SQL 服务器提出连接请求。
这也就是说，每个子进程将对服务器建立各自独立的持久连接。
例如，如果有 20 个不同的子进程运行某脚本建立了持久的 SQL 服务器持久连接，
那么实际上向该 SQL 服务器建立了 20 个不同的持久连接，每个进程占有一个。

以下是一点重要的总结。持久连接与常规的非持久连接应该是可以互相替换的。
即将持久连接替换为非持久连接时，你的脚本的行为不应该发生改变。使用持久连接只应该改变脚本的效率，不应该改变其行为！
</pre>

# 使用 mysql_pconnect 持久连接到 MySQL

使用 mysql_pconnect 打开一个到 MySQL 服务器的持久连接。  
注意，此种连接仅能用于模块版本的 PHP。 即用于 Apache + php_module 模式，不支持 Nginx + PHP-FPM 模式。

# 配置使用 PDO 方式 持久连接到 MySQL

```php
<?php
$dbh = new PDO('mysql:host=localhost;dbname=test', $user, $pass, array(
    PDO::ATTR_PERSISTENT => true
));
?>
```    
<pre>
如果想使用持久连接，必须在传递给 PDO 构造函数的驱动选项数组中设置 PDO::ATTR_PERSISTENT 。
如果是在对象初始化之后用 PDO::setAttribute() 设置此属性，则驱动程序将不会使用持久连接。

如果使用 PDO ODBC 驱动且 ODBC 库支持 ODBC 连接池（有unixODBC 和 Windows 两种做法；可能会有更多），
建议不要使用持久的 PDO 连接，而是把连接缓存留给 ODBC 连接池层处理。 
ODBC 连接池在进程中与其他模块共享；如果要求 PDO 缓存连接，则此连接绝不会被返回到 ODBC 连接池，导致创建额外的连接来服务其他模块。
</pre>


# Ref
[数据库持久连接](http://php.net/manual/zh/features.persistent-connections.php)  
[PHP MySQL 持久连接（mysql_pconnect）](https://iyaozhen.com/php-mysql_pconnect-discuss.html)  
[mysql_pconnect](http://php.net/manual/zh/function.mysql-pconnect.php)  
[PHP连接Mysql常用API(mysql,mysqli,pdo)区别与联系](http://dengxi.blog.51cto.com/4804263/1748965)  
