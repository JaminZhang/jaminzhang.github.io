---
layout: post
title: 学习创建 Nginx Rewrite Rules
description: "学习创建 Nginx Rewrite Rules"
category: Nginx
avatarimg:
tags: [Linux, Nginx]
duoshuo: true
---


# 引言

某业务需要添加 nginx rewrite rules，之前只是偶尔看过，现在有必要系统学习下。记录如下。  
学习材料来自于 nginx.com 的技术博客文章。  
[Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)  

# 创建 Nginx Rewrite Rules
（PS：有点懒，详细内容说明，直接去看原文吧。。。）

## 1 比较 return, rewrite, try_files 指令

### 1.1 return 指令

### 1.2 rewrite 指令

### 1.3 try_files 指令

## 2 示例：标准化域名

### 2.1 将旧域名重定向到新域名

### 2.2 增加或移除 www 前缀

### 2.3 重定向所有的流量到正确的域名

## 3 示例：强制所有请求使用 SSL/TLS

## 4 示例：为 WordPress 网站启用友好的固定链接

## 5 示例：丢弃不支持的文件类型请求

## 6 示例：配置自定义的重编路由

# 学习实践过程中遇到的问题

## 1 示例有不能正确工作

1. 如下配置，我在实践中测试不出来，花了很长时间，本以为自己的问题，但在测试中始终不能成功。

<pre>
server {
    ...
    rewrite ^(/download/.*)/media/(.*)\..*$ $1/mp3/$2.mp3 last;
    rewrite ^(/download/.*)/audio/(.*)\..*$ $1/mp3/$2.ra  last;
    return  403;
    ...
}
</pre>

将上面的rewrite rules改写成如下，就能正常工作了。

<pre>
rewrite ^(/download/.*)/media/(.*)$ $1/mp3/$2.mp3 last;
rewrite ^(/download/.*)/audio/(.*)$ $1/mp3/$2.ra  last;
</pre>

2. 使用文章的配置增加 www 前缀，提示此网页包含重定向循环，解决方法是需要先判断 host 主机名 如下：

```bash
server_name  jaminzhang.me;
if ($host != 'www.jaminzhang.me') {
    return 301   $scheme://www.jaminzhang.me$request_uri;
    #rewrite ^(.*)$ $scheme://www.jaminzhang.me$1 permanent; # 不推荐 rewrite，文章说 rewrite 的效率要比 return 低
}
```    



## 2 nginx 配置文件不熟悉

下面示例配置中的 return 指令中的 www.new-name.com 新域名的配置必须要存在，一开始测试时我没有配置，提示“此网页包含重定向循环”，
（这个是 301 跳转，Ref 文章[Nginx控制域名301跳转出现"此网页包含重定向循环"]中使用 rewrite 指定解决的，其实上面的文章中说了不推荐 rewrite 来解决，
因为 rewrite 的效率要比 return 低。）
然后配置了一个配置文件，还是不生效，依旧提示“此网页包含重定向循环”，经排查发现在 nginx.conf 主配置文件中并没有 include www.new-name.com
对应的配置文件, 我还以为默认会 include nginx/conf.d目录下的所有 conf文件呢。于是加上 include 指令，就可以测试成功了。

<pre>
server {
    listen 80;
    listen 443 ssl;
    server_name www.old-name.com old-name.com;
    return 301 $scheme://www.new-name.com$request_uri;
}
</pre>

# Ref
[Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)  
[nginx配置location总结及rewrite规则写法](http://seanlook.com/2015/05/17/nginx-location-rewrite/)  
[用include指令实现nginx多虚拟主机配置](http://blog.haohtml.com/archives/6203)  
[Nginx 301重定向规则](https://timeting.com/30/nginx-301-redirect/)  
[Nginx控制域名301跳转出现"此网页包含重定向循环"](http://www.voidcn.com/blog/u014723529/article/p-2686699.html)  
[Nginx 301重定向域名](http://www.tqcto.com/article/internet/50988.html)  
