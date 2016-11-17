---
layout: post
title: Web 服务器 PHP 配置
description: " Web 服务器 PHP 配置"
category: Web
avatarimg:
tags: [Web, PHP, Apache, Nginx]
duoshuo: true
---

# 引言

这个我想很多人都配置过，根据前面的一些 CGI/FastCGI/SAPI 等概念的理解，这里我重新根据 PHP 官网重新记录说明下要点配置。

# Apache 2.x 配置 PHP

要点配置：  
httpd.conf 文件以调用 PHP 模块  
`LoadModule php5_module modules/libphp5.so`

# Nginx 配置 PHP

要点配置：  

PHP 安装时要启用 PHP-FPM 模块，编译安装时的参数：`--enable-fpm`  

配置 Nginx 使其支持 PHP 应用：  

`vim /usr/local/nginx/conf/nginx.conf`  
修改默认的 location 块，使其支持 .php 文件：  

```bash
location / {
    root   html;
    index  index.php index.html index.htm;
}
```    

下一步配置来保证对于 .php 文件的请求将被传送到后端的 PHP-FPM 模块， 取消默认的 PHP 配置块的注释，并修改为下面的内容：

```bash
location ~* \.php$ {
    fastcgi_index   index.php;
    fastcgi_pass    127.0.0.1:9000;
    include         fastcgi_params;
    fastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;
    fastcgi_param   SCRIPT_NAME        $fastcgi_script_name;
}
```    


# Ref
[Unix 系统下的 Apache 2.x ](http://php.net/manual/zh/install.unix.apache2.php)  
[Unix 系统下的 Nginx 1.4.x](http://php.net/manual/zh/install.unix.nginx.php)  
