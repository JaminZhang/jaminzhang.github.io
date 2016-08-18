---
layout: post
title: Jenkins 插件
description: "Jenkins 插件"
category: CI/CD
avatarimg:
tags: [CI/CD, Jenkins, Plugins]
duoshuo: true
---


# Jenkins 前身

Jenkins 前身是 Hudson。更名原因：

>  
Hudson团队发表正式声明：整个团队将要摆脱Oracle服务器并将项目正式更名为Jenkins。  
看起来没什么问题，但实际上这是被逼无奈的结果，  
因为项目维护者不希望由于做了某些Oracle不喜欢的事情而导致Oracle操控整个项目。


# Jenkins 插件安装方法

Jenkins 是一个平台，真正实现功能的是插件。  
丰富的插件支持使我们可以方便地打通版本库、测试构建环境、线上环境的所有环节。  并且丰富友好的通知使用者和开发、管理人员。

## 通过 Web 界面进行安装

### 安装最新版本

首页->左侧 Manage Jenkins->Manage Plugins->Availabe->右上角 Filter
通过关键词过滤相关插件后选择进行安装。

### 安装指定版本

点击插件 wiki 页面上的下载链接，选择下载一个老版本的插件。  
首页->左侧 Manage Jenkins->Manage Plugins->Advanced->Upload Plugin，从这里上传安装。

# 手动安装

保存下载好的 *.hpi/*.jpi 文件到 Jenkins 插件目录 `/var/lib/jenkins/plugins`。  
然后需要重启 Jenkins。

# Ref
[Plugins](https://wiki.jenkins-ci.org/display/JENKINS/Plugins)  
[Jenkins－持续集成平台(安装篇)](http://www.imooc.com/article/11895)  
[Jenkins Gitlab持续集成打包平台搭建](http://skyseraph.com/2016/07/18/Tools/Jenkins%20Gitlab%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90%E6%89%93%E5%8C%85%E5%B9%B3%E5%8F%B0%E6%90%AD%E5%BB%BA/)  
[集成 Jenkins 和 TestNG 实现自助式自动化测试平台](http://www.ibm.com/developerworks/cn/opensource/os-autotesting-jenkins-testing/)    
