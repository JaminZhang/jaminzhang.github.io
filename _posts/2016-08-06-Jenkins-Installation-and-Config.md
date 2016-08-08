---
layout: post
title: Jenkins 安装部署
description: "Jenkins 安装部署"
category: CI/CD
avatarimg:
tags: [Jenkins, CI/CD]
duoshuo: true
---

## 安装 JDK

Jenkins 是 Java 编写的，所以需要先安装 JDK，这里采用 yum 安装，如果对版本有需求，可以直接在 Oracle 官网下载 JDK。  

本文在 CentOS 7 下安装。

>
yum install java-1.8.0 -y


## 安装 Jenkins

```bash
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat/jenkins.io.key
yum install jenkins -y
systemctl start jenkins
```    

## 访问 Jenkins

使用浏览器访问 http://192.168.56.11:8080/ （主机名修改成你自己的）
等待自动刷新一会儿，提示解锁 Jenkins，查看 `/var/lib/jenkins/secrets/initialAdminPassword` 中的初始密码

>
[root@linux-node1 ~]# cat /var/lib/jenkins/secrets/initialAdminPassword  
8d80e09b60984fefa68c5d4551a0719f

## 安装 Jenkins 插件

选择默认即可，会安装通用的社区插件，剩下的可以在使用的时候再进行安装

>
由于网络原因，有一些插件会安装失败。需要重试多次安装。

## 设置 admin 用户和密码

## 登录 Jenkins

## 遇到的问题

解锁 Jenkins 后，一直在加载，非常久后还是在加载。  
在浏览器中查看加载状态，并没有看到报错。
查看 jenkins 服务状态，查看日志文件 ` /var/log/jenkins/jenkins.log`，也没有看到什么报错。
更换浏览器后，上述一直加载现象依旧。  
尝试重启 jenkins 服务后看下，然后就没有一直加载了，可以到插件选择页面。真是奇怪，原因不明。  




# Ref
[Installing Jenkins on Red Hat distributions](https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Red+Hat+distributions)  
[RedHat Linux RPM packages for Jenkins](http://pkg.jenkins.io/redhat/)  
[持续集成之Jenkins安装部署](https://www.unixhot.com/article/55)    
