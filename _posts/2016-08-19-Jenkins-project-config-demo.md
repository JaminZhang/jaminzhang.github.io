---
layout: post
title: Jenkins 项目配置演示
description: "Jenkins 项目配置演示"
category: CI/CD
avatarimg:
tags: [CI/CD, Jenkins, GitLab, Build]
duoshuo: true
---


# Jekins Web 界面

`Manage Jenkins`下是 Jekins 的相关配置，下面列出几个要重点熟悉的配置项目

## Configure System

## Configure Credentials

本文要进行拉取 GitLab 仓库的项目演示，需要先添加 SSH 私钥方式的认证。

`首页左侧"Credentials"->中间"(global)"->左侧“Add Credentials”`，然后配置如下：

```bash

Kind: SSH Username with private key
Username: root (本文使用 root 用户)
Private Key: Enter directly(私钥为 Jekins 服务器上 root 用户私钥)
Description: GitLab Demo

```    

此处 root 用户对应的公钥需要配置到 GitLab 上的 Deploy Keys


## Manage Plugins

本文要进行拉取 GitLab 仓库的项目演示，需要先安装好 Git 和 GitLab 相关插件。
GitLab 相关可用插件全部安装下：

* Gitlab Authentication plugin
* GitLab Plugin
* GitLab Logo Plugin
* Gitlab Merge Request Builder
* Gitlab Hook Plugin

Git 相关插件之前已经安装好了。

# 创建新任务演示

1. 首页中间“create new jobs”->
2. "Enter an item name 填写 auto-deploy、然后选择 Freestyle project"->
3. "General 下面 Description: CI测试，其他默认”->
4. "Source Code Management 下面：选择 Git, 
   Repository URL 填写 GitLab 仓库的 git 方式 URL：git@192.168.56.12:web/web-demo.git, 
   Credentials 填写对应的认证方式，
   Repository browser 选择 gitlab，填写 GitLab 仓库的 http 方式的 URL: http://192.168.56.12/web/web-demo.git ，
   Version 填写 GitLab 的版本：8.10"

完成以上配置，点击 Save，保存项目配置。

# 项目构建演示

定位到刚才创建的项目“auto-deploy” -> 点击网页左侧“Build Now” 开始构建。  
构建完成后（蓝色圆球表示构建成功），可以在 “Build History” 中点击刚才的构建记录，进行去后查看具体的“Console Output”。
