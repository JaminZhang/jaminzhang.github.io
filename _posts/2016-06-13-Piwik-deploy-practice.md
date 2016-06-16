---
layout: post
title: Piwik 部署实践
description: "Piwik 部署实践"
category: Monitoring
avatarimg: 
tags: [Monitoring, Web, Piwik]
duoshuo: true
---

# 1 Piwik 简介

Piwik 是开源网站分析软件，功能媲美GA。  
更多介绍见官网[what-is-piwik](https://piwik.org/what-is-piwik/)  


相对于GA，Piwik 具有以下独特优势：

1. 无抽样和延迟问题，无流量限制，因为它是本地托管服务，只受限于你的服务器性能。
2. 支持基于用户查看访问日志，在某些特定场景会非常有用，比如排查购物车流程或者监控恶意点击。
3. 可以对历史数据进行重新处理计算，因为它是基于用户的原始访问日志进行数据存储。
4. GA 的大多数实用功能基本都已经有了，比如电子商务跟踪、自定义变量跟踪、事件跟踪、目标跟踪、广告系列跟踪、高级细分等。
5. 不单单是分析网站浏览，服务器日志也可以跟踪，分析服务器日志是 SEO 大牛们经常使用的一个方法。
6. 可以通过插件和自定义主题来满足自己的个性化需求，对于有技术基础的公司是一个不错的入门选择。
7. 它是免费的！


# 2 Piwik 安装部署

## 2.1 yum 安装 LAMP 环境

>
yum install httpd httpd-manual php php-pdo php-mysql php-gd php-curl php-cli php-xml php-mbstring php-ldap php-xmlrpc php-pear mod_ssl mod_perl mysql-connector-odbc mariadb-server mariadb-devel

## 2.2 部署配置 Apache Piwik 站点目录

```bash
cd /var/www/html/
wget http://builds.piwik.org/piwik.zip
unzip piwik.zip
chown -R apache.apache /var/www/html/piwik
chmod 0755 /var/www/html/piwik/tmp/
mv piwik/* .

systemctl start httpd
```    

## 2.3 创建 Piwik 数据库及用户

```bash
systemctl start mariadb

MariaDB [(none)]> create database piwik;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> grant all on piwik.* to piwik@localhost identified by 'piwik';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```    

## 2.4 通过 Web 界面安装 Piwik

访问 Piwik 的 URL(我的如下)  
http://192.168.56.11/

具体图文步骤官网上有[Installing Piwik](https://piwik.org/docs/installation/)  

## 2.5 配置网站和添加 JavaScript 跟踪代码

这里我添加自己的博客 http://jaminzhang.github.io/

将 Piwik 生成的 JavaScript 跟踪代码添加到博客的模板页（不同网站系统根据实际情况配置）

```javascript
<!-- Piwik -->
<script type="text/javascript">
  var _paq = _paq || [];
  _paq.push(["setDomains", ["*.jaminzhang.github.io"]]);
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u="//192.168.56.11/";
    _paq.push(['setTrackerUrl', u+'piwik.php']);
    _paq.push(['setSiteId', 1]);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
  })();
</script>
<noscript><p><img src="//192.168.56.11/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript>
<!-- End Piwik Code -->
```    

## 2.6 Piwik Web 界面

截图如下：
![Piwik Dashboard](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Piwik-01.png)  

## 2.7 Piwik 深入配置使用

由专业的数据分析人员进行配置使用


# 报错 

安装过程中提示 tracker status 500

查看 httpd err_log，如下：

```bash
[Tue Jun 14 17:10:03.859201 2016] [:error] [pid 15967] [client 192.168.56.1:49170] PHP Fatal error:  Uncaught exception 'Exception' with message 'The configuration file {/var/www/html/config/config.ini.php} has not been found or could not be read.' in /var/www/html/core/Application/Kernel/EnvironmentValidator.php:63\nStack trace:\n#0 /var/www/html/core/Application/Kernel/EnvironmentValidator.php(44): Piwik\\Application\\Kernel\\EnvironmentValidator->checkConfigFileExists('/var/www/html/c...', false)\n#1 /var/www/html/core/Application/Environment.php(185): Piwik\\Application\\Kernel\\EnvironmentValidator->validate()\n#2 /var/www/html/core/Application/Environment.php(94): Piwik\\Application\\Environment->validateEnvironment()\n#3 /var/www/html/piwik.php(56): Piwik\\Application\\Environment->init()\n#4 {main}\n  thrown in /var/www/html/core/Application/Kernel/EnvironmentValidator.php on line 63
```   

从上面的日志看到：/var/www/html/config/config.ini.php 不存在  
这时我们可以忽略这个错误，当我们完成安装过程后，这个配置文件会自动生成的。


# Ref
[piwik安装部署最佳实践](http://www.xuliangwei.com/xubusi/522.html)  
[what-is-piwik](https://piwik.org/what-is-piwik/)   
[Installing Piwik](https://piwik.org/docs/installation/)  
[piwik tracker status 500 installation error](http://stackoverflow.com/questions/33870884/piwik-tracker-status-500-installation-error)  
