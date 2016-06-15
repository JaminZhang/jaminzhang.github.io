---
layout: post
title: 构建CentOS RPM包
description: "构建CentOS RPM包"
category: Linux
avatarimg:
tags: [RPM, FPM, YUM]
duoshuo: true
---


# 引言
之前说过Murder安装方式，提到打包成rpm并放到yum的方式。所以下面来说说这种方法。  

# 构建rpm包
构建rpm包一般有2种方法：

01. 使用rpmbuild指定spec文件构建RPM包  
02. 使用命令行打包工具FPM

我大概看了下第一种方法，太复杂了，Murder实际上就一些py文件，我只是想把这些py文件打包成rpm，  
所以选择使用FPM来打包。  

我想设置murder的rpm安装好后的目录为/usr/local/murder，于是首先将murder相关py文件放到这个目录下。  
然后开始打包，命令如下：
>
fpm -s dir -t rpm -n murder -v 0.1.3 /usr/local/murder/

具体命令选项请man。

生成rpm包后，就可以放在公司内部的yum源上。


# 遇到的问题
需要从gem install fpm，安装报错如下：
<pre>
ERROR:  Could not find a valid gem 'fpm' (>= 0), here is why:
          Unable to download data from https://rubygems.org/ - Errno::ECONNRESET: Connection reset by peer - SSL_connect (https://rubygems.org/latest_specs.4.8.gz)
</pre>
国内网络原因连接不到国外的gem源，解决方法是使用淘宝的gem源：
<pre>
gem sources -l
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
gem sources -l
</pre>


# Ref
《网站运维技术与实践》7.4 搭建私有软件仓库  
[用fpm便捷地打RPM包](http://blog.csdn.net/willas/article/details/10329225)  
[GitHub FPM](https://github.com/jordansissel/fpm)  

