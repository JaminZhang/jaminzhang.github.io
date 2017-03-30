---
layout: post
title: Jenkins 配置 Job 关联、Pipeline、GitLab Webhook
description: "Jenkins 配置 Job 关联、Pipeline、GitLab Webhook"
category: CI/CD
avatarimg:
tags: [CI/CD, Jenkins, Pipeline, GitLab, Webhook]
duoshuo: true
---

# 引言

上一篇文章是将 SonarQube 与 Jenkins 结合，实现了从 Git 仓库获取代码并进行代码测试，
本文将在上一篇的基础上实现将构建测试通过后的代码部署至测试环境。


# 创建及配置代码部署项目

## 1. 新建一个项目叫 demo-deploy 用于代码部署

Name: demo-deploy  
描述：代码部署  


## 2. 进行构建配置

这里我们是通过执行 Shell 部署脚本来实现代码部署。
所以我们先要配置好 jenkins 用户可以远程到发布机执行部署脚本。  
基于我们之前的文章，发布机是 192.168.56.11，我们需要做 root 用户免密钥登陆到发布机，
在这之前还需要 jenkins 用户的 sudo ssh 权限。

### 2.1 配置 jenkins 用户 sudo 权限

```bash

vim  /etc/sudoers
#Defaults    requiretty # 注释掉，不需要tty
jenkins ALL=(ALL)       NOPASSWD: /usr/bin/ssh

```    

### 2.2 配置 Jenkins 服务器上 root 用户到发布机的免密钥登陆

配置完成后，我们先命令行上测试是否可以正确拉取 Git 仓库代码。

```bash

[root@linux-node1 ~]# ssh www@192.168.56.11 './deploy_all.sh deploy'
Already up-to-date.
code_build
HTTP/1.1 200 OK
add to cluster
HTTP/1.1 200 OK
add to cluster

```    

### 2.3 配置 Jenkins 构建调用部署脚本

选择   `Execute shell`  
`Command: sudo ssh www@192.168.56.11 './deploy_all.sh deploy'`  


### 2.4 进行构建测试

点击 `Build Now`，然后查看 Output 确认部署结果  


# 关联项目及 Pipeline 配置

## 1. 关联项目

上面我们配置好了 2 个项目，  

* demo-sonar 项目用于拉取 Git 仓库代码并进行构建、代码分析。
* demo-deploy 项目用于部署代码。

现在我们可以关联这 2 个项目，当 demo-sonar 通过时，继续执行 demo-deploy。  
但需要先安装好 `Parameterized Trigger Plugin` 插件来实现关联。安装好后，进行如下配置关联：  

选择 demo-sonar 项目，定位到`"Post-build Actions"->"Trigger parameterized build on other projects"`，  
配置如下后保存：

```bash

Projects to build:　demo-deploy
Trigger when build is: Stable
Trigger build without parammeters : 勾选

``` 

配置好后，我们可以开始构建 demo-sonar 项目，然后查看是否触发 demo-deploy 项目。  

## 2. 配置 Pipeline

关联不同的项目后可形成 Pipeline，需要安装 `Build pipeline plugin` 插件实现 Pipeline。

我们现在新建一个 Pipeline，命名为 demo-pipeline，添加时注意选择“Build Pipeline View”。    
添加完成后，我们就可以运行及查看这个 Pipeline 了。


# 使用 Webhooks 实现自动部署

上面我们配置的都需要网页手动点击构建才能触发部署脚本，如何实现当研发 git push 到代码仓库时就触发自动构建、测试及部署呢？     
(这里是部署到测试环境，实际生产部署还是需要运维手动控制部署)   
这里我们可以使用 GitLab Webhooks 来实现。  

## 1 Jekins 配置

### 1.1 安装相关插件

* Build Authorization Token Root Plugin
* GitLab Hook Plugin

### 1.2 生成一个 Token

```bash

openssl rand -hex 12
80df1bb5d0e4e25cd9248a6b

```    

### 1.3 配置构建触发器

选择 demo-sonar 项目，定位到 “Build Triggers”，然后如下配置后保存：

```bash

勾选 “Trigger builds remotely (e.g., from scripts)”
Authentication Token: 填写刚才生成的 Token 80df1bb5d0e4e25cd9248a6b
勾选 “Build when a change is pushed to GitLab.”

```    

## 2 GitLab 配置

### 2.1 配置 Git 项目 Webhook URL 和 Trigger

定位到对应 Git 项目的 Webhooks 配置页面，然后做如下配置：

URL:http://192.168.56.11:8080/buildByToken/build?job=demo-sonar&token=80df1bb5d0e4e25cd9248a6b  
Trigger: 根据需要选择，这里我们使用默认的 Push events

添加好后，进行 Webhooks 测试，点击网页最下方测试按钮。

## 3 正式测试

现在我们向 GitLab 上的项目进行 git push，然后检查是否成功触发自动构建、测试及部署。

访问 Web 界面验证代码是否为最新。

# Ref
[Build Token Root Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Build+Token+Root+Plugin)  


