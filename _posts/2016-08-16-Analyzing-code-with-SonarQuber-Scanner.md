---
layout: post
title: 使用 SonarQube Scanner 进行代码分析
description: "使用 SonarQube Scanner 进行代码分析"
category: CI/CD
avatarimg:
tags: [Sonar]
duoshuo: true
---


使用 Sonar 进行代码分析


# 引言
之前已经安装了 Sonar，现在我们来演示使用 Sonar 进行代码分析。

# 安装中文语言包插件

如果不想使用英文界面，而是使用中文界面，可以安装中文语言包。  

首页->Administration->System->Update Center->Available
搜索 Chinese 后，选择“Chinese Pack” 后，Install 即可，需要重启生效。


# 使用 Sonar 进行代码分析

分析一个编程语言的代码，首先要在 SonarQube 上安装这个编程语言的分析插件。  
然后使用 SonarQube Scanner 进行代码分析。

## 1. 安装编程语言插件

默认安装中没有 PHP 的语言插件，现在我们来安装一下。  
首页->Administration->System->Update Center->Available
搜索 php 后，选择“PHP” 后，Install 即可，需要重启生效。

>
SonarQube 插件目录：/usr/local/sonarqube/extensions/plugins


## 2. 安装配置 SonarQube Scanner

```bash
# 下载并解压 SonarQube Scanner 软件包
[root@linux-node1 ~]# cd /usr/local/src/
[root@linux-node1 src]# wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.6.1.zip
[root@linux-node1 src]# unzip sonar-scanner-2.6.1.zip -d /usr/local/
[root@linux-node1 src]# ln -s /usr/local/sonar-scanner-2.6.1/ /usr/local/sonar-scanner

# 修改 sonar-scanner.properties 文件，配置如下参数：
#----- Default SonarQube server
sonar.host.url=http://localhost:9000
#----- Default source code encoding
sonar.sourceEncoding=UTF-8
#----- Global database settings (not used for SonarQube 5.2+)
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar@pw
#----- MySQL
sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&amp;characterEncoding=utf8

# 检查安装
[root@linux-node1 src]# /usr/local/sonar-scanner/bin/sonar-scanner -h

```    

## 3. 下载官方提供的样例项目代码进行代码分析测试

下载地址：https://github.com/SonarSource/sonar-examples

```bash
wget https://github.com/SonarSource/sonar-examples/archive/master.zip -O sonar-examples.zip

# 配置样例项目 sonar-project.properites 配置文件（这里我们使用默认不做修改）
[root@linux-node1 src]# unzip sonar-examples-master.zip 
[root@linux-node1 src]# cd sonar-examples-master/projects/languages/php/php-sonar-runner

# 执行代码分析
[root@linux-node1 php-sonar-runner]# /usr/local/sonar-scanner/bin/sonar-scanner -D sonar-project.properties 

```    
代码分析完成后效果如图所示：

![SonarQube-Scanner-PHP-Result](http://jaminzhang.github.io/images/CI-CD/SonarQube-Scanner-PHP-Demo.png)  

根据分析结果来改进代码。


# Ref
[Analyzing with SonarQube Scanner](http://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner)  
