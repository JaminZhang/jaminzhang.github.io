---
layout: post
title: SonarQube 代码分析与 Jenkins 结合
description: "SonarQube 代码分析与 Jenkins 结合"
category: CI/CD
avatarimg:
tags: [CI/CD, Jenkins, SonarQube]
duoshuo: true
---


# 1. Jenkins 上安装配置 SonarQube Plugin 插件

首先安装 SonarQube Plugin 插件(会有几个依赖插件)。然后做如下配置：  

## 1.1 将 Jenkins 关联 Sonar

定位到 ` "Manage Jenkins"->"Configure System"->"SonarQube servers"->  
"SonarQube installations"->"Add SonarQube" ` 配置如下然后保存：  

```bash

Name: Sonar
Server URL: http://192.168.56.11:9000/
Server version: 5.3 or higher

```    

## 1.2 配置 SonarQube Scanner

定位到 ` "Manage Jenkins"->"Global Tool Configuration"->"SonarQube Scanner"->  
"SonarQube Scanner installations"->"Add SonarQube Scanner" `配置如下然后保存：  

```bash

Name: Sonar Scanner
不选择 Install automatically
SONAR_RUNNER_HOME: /usr/local/sonar-scanner 
# SonarQuber Scanner 和 Jekins 是在同一台服务器上 ，SonarQube Server 不需要

```    

# 2. 配置 Jekins 项目的构建

选择之前配置的 auto-deploy 项目，在 Build 下配置如下后保存：

选择 `Execute SonarQube Scanner` 

Analysis properties 配置如下:  

```bash

sonar.projectKey=demo
sonar.projectName=demo
sonar.projectVersion=1.0
sonar.sources=./
sonar.language=php
sonar.sourceEncoding=UTF-8

```    

这里的 Analysis properties 有 2 种方法：  

1. 让研发在项目根目录放置包含以上内容的 SonarQube Scanner 配置文件 
2. 如上，在项目构建上手动配置


# 3. 测试 Jenkins 项目构建

选择 “auto-deploy” 项目，点击 “Build Now” 立即构建。  

查看 Output 是否构建成功。（Output 是实时显示的。）

Jekins 项目主页上有 Sonar 快捷方式，可以点击查看代码扫描的具体结果。

可以在 SonarQuber 首页添加配置一些 widgets：  

* Integration Tests Coverage 集成测试覆盖率  
* Documentation & Comments 文档和注释  


# 4. 配置 Jekins 项目构建后操作

可配置邮件通知，当构建失败时发送邮件通知。

邮件通知需要先配置好，如下：

## 配置系统管理员邮箱地址  

定位到 `"Manage Jenkins"->"Configure System"->"Jenkins Location"  
System Admin e-mail address: 779432xxx@qq.com `(以 QQ 邮箱演示)

## 配置 E-mail Notification

然后再定位到`"Manage Jenkins"->"Configure System"->"E-mail Notification"`，配置如下图示：

![Jenkins-Email-Notification](http://jaminzhang.github.io/images/CI-CD/Jenkins-Email-Notification.png)  

将 SonarQube 服务关闭，然后构建项目，由于 SonarQube 服务无法访问所以肯定会导致项目构建失败从而触发邮件通知。

最后，我们把 auto-deploy 项目改名成 demo-sonar。


# 遇到的问题

4 次构建失败，而且 Jekins 进程也自动关掉了，初步判断是测试的虚拟机内存不足原因。

