---
layout: post
title: 构建 CentOS RPM 包
description: "构建 CentOS RPM 包"
category: Linux
avatarimg:
tags: [Linux, RPM, FPM, Yum]
duoshuo: true
---


# 引言

之前说过 Murder 安装方式，提到打包成 rpm 并放到 yum 的方式。所以下面来说说这种方法。  

# 构建 rpm 包

构建 rpm 包一般有 2 种方法：

01. 使用 rpmbuild 指定 spec 文件构建 RPM 包  
02. 使用命令行打包工具 FPM

我大概看了下第一种方法，太复杂了，Murder 实际上就一些 py 文件，
我只是想把这些 py 文件打包成 rpm，所以选择使用 FPM 来打包。  

我想设置 Murder 的 rpm 安装好后的目录为`/usr/local/murder`，于是首先将 Murder 相关 py 文件放到这个目录下。  
然后开始打包，命令如下：

```bash
fpm -s dir -t rpm -n murder -v 0.1.3 /usr/local/murder/
```    

具体命令选项请 man。

生成 rpm 包后，就可以放在公司内部的 yum 源上。



# 遇到的问题

需要`gem install fpm`，安装报错如下：

<pre>

ERROR:  Could not find a valid gem 'fpm' (>= 0), here is why:
          Unable to download data from https://rubygems.org/ - Errno::ECONNRESET: Connection reset by peer - SSL_connect (https://rubygems.org/latest_specs.4.8.gz)

</pre>

国内网络原因连接不到国外的 gem 源，解决方法是使用淘宝的 gem 源：

<pre>

gem sources -l
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
gem sources -l

</pre>


# Ref
《网站运维技术与实践》7.4 搭建私有软件仓库  
[用 fpm 便捷地打 RPM 包](http://blog.csdn.net/willas/article/details/10329225)  
[GitHub FPM](https://github.com/jordansissel/fpm)  
[基于官方 rpm 快速创建自定义 rpm](https://mritd.me/2016/09/13/%E5%9F%BA%E4%BA%8E%E5%AE%98%E6%96%B9-rpm-%E5%BF%AB%E9%80%9F%E5%88%9B%E5%BB%BA%E8%87%AA%E5%AE%9A%E4%B9%89-rpm/)  

