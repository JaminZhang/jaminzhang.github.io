---
layout: post
title: 安装 Nginx 
description: "安装 Nginx"
category: Nginx
avatarimg:
tags: [Web, Nginx]
duoshuo: true
---

安装 Nginx

#  Linux 软件包安装方式

CentOS 6/7 系列操作系统下，可以通过设置 Nginx 的官方 yum 源，然后通过 yum 安装。

<pre>

To set up the yum repository for RHEL/CentOS, 
create the file named /etc/yum.repos.d/nginx.repo with the following contents:

[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/OS/OSRELEASE/$basearch/
gpgcheck=0
enabled=1


Replace “OS” with “rhel” or “centos”, depending on the distribution used, 
and “OSRELEASE” with “6” or “7”, for 6.x or 7.x versions, respectively.

</pre>



# Linux 源码编译安装方式

## 1. 准备先决条件

事先安装好启用特定 Nginx 模块所需要的软件库和工具

`
yum install gcc pcre pcre-devel zlib zlib-devel openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel gd-devel geoip geoip-devel -y
`

## 2. 下载、解压、配置、编译、安装 Nginx

```bash

wget http://nginx.org/download/nginx-1.12.0.tar.gz
tar zxvf nginx-1.12.0.tar.gz
cd nginx-1.12.0

./configure --prefix=/usr/local/nginx-1.12.0 \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module=dynamic \
--with-http_geoip_module=dynamic \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module 

make

make install 

ln -s /usr/local/nginx-1.12.0/ /usr/local/nginx

```    

# Ref
[Installing nginx](http://nginx.org/en/docs/install.html)  
[nginx: Linux packages](http://nginx.org/en/linux_packages.html)  
[Building nginx from Sources](http://nginx.org/en/docs/configure.html)  
