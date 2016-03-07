---
layout: post
title: 学习创建Nginx Rewrite Rules
description: "学习创建Nginx Rewrite Rules"
category: Linux
avatarimg:
tags: [Linux, Nginx]
duoshuo: true
---


# 引言
某业务需要添加nginx rewrite rules，之前只是偶尔看过，现在有必要系统学习下。记录如下。
学习材料来自于nginx.com的技术博客文章。[Creating NGINX Rewrite Rules](https://www.nginx.com/blog/creating-nginx-rewrite-rules/)  

# 创建Nginx Rewrite Rules-目录
（PS：有点懒，详细内容说明，直接去看原文吧。。。）
## 1 比较return, rewrite, try_files指令
### 1.1 return指令
### 1.2 rewrite指令
### 1.3 try_files指令
## 2 示例：标准化域名
### 2.1 将旧域名重定向到新域名
### 2.2 增加或移除www前缀
### 2.3 重定向所有的流量到正确的域名
## 3 示例：强制所有请求使用SSL/TLS
## 4 示例：为WordPress网站启用友好的固定链接
## 5 示例：丢弃不支持的文件类型请求
## 6 示例：配置自定义的重编路由

# 学习实践过程中遇到的问题
## 1 示例有不能正确工作
如下配置，我在实践中测试不出来，花了很长时间，本以为自己的问题，但在测试中始终不能成功。
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

## 2 nginx配置文件不熟悉
下面示例配置中的return指令中的www.new-name.com新域名的配置必须要存在，一开始测试时我没有配置，提示“此网页包含重定向循环”，
（这个是301跳转，Ref文章[Nginx控制域名301跳转出现"此网页包含重定向循环"]中使用rewrite指定解决的，其实上面的文章中说了不推荐rewrite来解决，
因为rewrite的效率要比return低。）
然后配置了一个配置文件，还是不生效，依旧提示“此网页包含重定向循环”，经排查发现在nginx.conf主配置文件中并没有include www.new-name.com
对应的配置文件, 还以为默认会include nginx/conf.d目录下的所有conf文件呢。。。于是加上include指令，就可以测试成功了。
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
[Nginx控制域名301跳转出现"此网页包含重定向循环"](http://tqcto.com/article/recommend/61.html)  

