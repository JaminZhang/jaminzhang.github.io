---
layout: post
title: PHP 优化总结
description: "PHP 优化总结"
category: Web
avatarimg:
tags: [Web, PHP, Optimization]
duoshuo: true
---

PHP 优化总结

# 引言
现在的业务虽然也使用 PHP，但 PHP 已经是做好内部的 RPM 包，直接通过内部 YUM 源安装使用的。  
所以关于 PHP 的优化之前有学习过，不过好久没有实际配置过，很多具体细节配置参数已经忘记了，现在查找相关资料，  
重新总结学习下。  

# PHP 相关优化

## php.ini 参数调优

生产环境下按需求关闭 PHP 日志或输出到文件中

### 1. 打开 PHP 的安全模式

PHP 的安全模式是个非常重要的 PHP 内嵌的安全机制，能够控制一些 PHP 的函数执行，比如 `system()` 调用系统命令函数

>
safe_mode = on

### 2. 用户组安全

>
safe_mode_gid = off # 防止 PHP 程序对脚本执行有权限

### 3. 关闭危险函数

如果打开了安全模式，那么函数禁止是可以不需要的，但是我们为了安全还是可以关闭的，特别是`phpinfo()`

>
disable_functions = system,passthru,exec,shell_exec,popen,phpinfo

如果要禁止任何文件和目录的操作，那么可以关闭很多文件操作

>
disable_functions = chdir,chroot,dir,getcwd,opendir,readdir,scandie,fopen,unlink,delete,copy,mkdir,rmdir,rename,file,file_getcontents,fputs,fwrite,chgrp,chmod,chown

### 4. 关闭 PHP 版本信息在 HTTP 头中的泄漏

>
expose_php = off

### 5. 关闭注册全局变量

在 PHP 中提交的变量，包括使用 POST 或者 GET 提交的变量，都将自动注册为全局变量，能够直接访问，这是对服务非常不安全的

>
register_globals = off # 推荐使用预定义的超全局变量：$_ENV,$_GET,$_POST,$_COOKIE,$_SERVER   
该指令受 variables_order 指令的影响，5.5 自动关闭了

### 6. 打开 magic_quotes_gpc 来防止 SQL 注入

SQL 注入是非常危险的问题，轻则网站后台被入侵，重则整个服务器沦陷

>
magic_quotes_gpc = off

这个默认是关闭的，如果它打开将自动把用户提交对 sql 的查询进行转换，比如把 ' 转换为 \' 这对防止 SQL 注入有重大作用，所以推荐设置为打开。

>
magic_quotes_gpc = on

SQL 注入防范：

* Apache 中的 mod_security 和 mod_evasive
* Nginx lua waf

### 7. 错误信息控制

一般 PHP 在没有连接到数据库或者其他情况下会提示错误，一般信息都会包含 PHP 脚本当前的路径信息或者查询的 SQL 语句信息，这类信息提供给黑客后是不安全的，建议关闭错误提示。

>
display_errors = off # 正式环境不要给用户报错

### 8. 错误日志

>
log_errors = on # 打开日志开关  
error_log = /application/logs/php_error.log # 设置路径

### 9. 禁止打开远程地址

记得 php include 那个安全漏洞吧！就是在一个 PHP 程序中的 include 了变量，那么入侵者就可以利用这个控制服务器在本地执行远程的一个 PHP 程序，例如 phpshell

>
allow_url_fopen = off

### 10. 设定防止 Nginx 文件解析错误漏洞

>
cgi.fix_path = 0

### 11. 调整 php session 会话共享信息存放位置

> 
session.save_handler = memcache  
session.save_path = "tcp://10.0.0.8:1211"  # 首先搭建好 memcached 环境  

## 2. PHP 资源限制参数优化

### 1. 设置每个脚本运行的最长时间

如果无法上传较大的文件或者后台备份数据经常超时时，此时需要调整如下设置

>
max_execution_time = 30  
每个脚本允许的最大执行时间，0 表示没有限制    
这个参数有助于阻止恶劣脚本无休止的占用服务器资源  

### 2. 每个脚本使用的最大内存

>
memory_limit = 128m

### 3. 每个脚本等待输入数据最长时间

>
max_input_time = 60;   # (-1 表示不限制)

### 4. 上传文件的最大许可

>
upload_mx_filesize = 2M;


## 3. 参数以外常见的 PHP 优化方法手段

### 1. PHP 引擎缓存加速优化

xCache、ZendOpcache、eAccelerator

http://www.lichengbing.cn/archivers/270.html


### 2. 用 tmpfs 作为缓存加速缓存的文件目录

tmpfs，基于内存的文件系统，加快转存暂存文件的速度

>
mount -t tmpfs tmpfs /dev/shm -o size=256m  
mount -t tmpfs tmpfs /dev/shm /tmp/eaccelerator # 上传图片缩略图临时处理目录和缓存目录
 
### 3. 防止 PHP 程序上传文件到图片附件目录


# Ref
[PHP引擎php.ini参数优化](http://lilongzi.blog.51cto.com/5519072/1840553)  
