---
layout: post
title: Fiddler工具基本使用
description: "Fiddler工具基本使用"
category: HTTP
avatarimg:
tags: [HTTP, Fiddler]
duoshuo: true
---

# 1 Fiddler工具简介

## 1.1 工作环境

[Fiddler官网](http://www.telerik.com/fiddler)

主要功能（详见官网）：

Web Debugging  
Performance Testing  
HTTP/HTTPS Traffic Recording  
Web Session Manipulation  
Security Testing  
Customizing Fiddler  

## 1.2 工作原理

Fiddler作为客户端和服务器之间的代理服务器。

Fiddler的2种代理模式

流模式（streaming）：可实时把服务器数据返回给客户端。优点：更接近于浏览器本身真实的行为。  
缓冲模式（buffering）：HTTP请求的所有数据在服务器端都准备好之后，才把数据返回给客户端。优点：可以控制最后的服务器响应。

## 1.3 常见使用场景

1. 开发环境hosts配置
通常情况下，配置hosts文件需要修改系统文件，很不方便；在多个开发环境下切换很低效。Fiddler提供了相对高效的hosts配置方法。

2. 前后端接口调试
通常情况下，调试前后端接口需要真实的环境、一大堆假数据、写JavaScript代码。Fiddler只需要一个UI界面进行配置即可。

3. 线上bugfix
Fiddler可将发布文件代理到本地，快速定位线上bug。

4. 性能分析和优化
Fiddler会提供请求的实际图，清晰明了网站需要优化的地方。

# 2 Fiddler界面操作介绍

## 2.1 工具条常用功能

备注按钮(Set Comments)  
回放按钮（Replay）快捷键R  
清空监控面板按钮（Remove）  
调试Debug按钮（Go）结合状态栏断点图标指示  
模式切换按钮（Stream）默认为缓冲模式  
解码请求按钮（Decode）  
保持会话按钮（Keep sessions）  
过滤请求按钮（Any Process）  
查找按钮（Find）  
保存会话按钮（Save）  
保存截图按钮  
计时器按钮  
快速启动浏览器按钮（Browse）  
清除缓存按钮（Clear Cache）  
编码、解码按钮（TextWizard）  
分离面板按钮（Tearoff）  
MSDN搜索框  

## 2.2 状态栏操作

控制台：help命令  
Capturing按钮：控制Fiddler是否进行捕获工作  
过滤会话来源  
记录当前展示的会话数量  
显示选中的会话URL  

## 2.3 监控面板的使用

监控面板是Fiddler的最核心的功能之一，显示HTTP的会话。

Result:HTTP状态码  
Protocol:协议  
Host:主机  
ServerIP:服务器IP  
URL  

监控面板右侧Tabs

分为上下2部分，上部分为HTTP请求相关信息，下部分为HTTP响应相关信息。

数据统计（Statics): RTT往返时间 Show Chart  
对请求进行解包（Inspectors）:  
Heraders
文件代理（AutoResponder）: 线上bug文件本地测试  
前后端接口连调（Composer）: 和服务器接口进行调试  
日志（Log）  
网站性能分析的时间线（Timeline）  

# 3 Fiddler常用功能

## 3.1 文件、文件夹代理和HOSTS配置
AutoResponder
Tools->HOSTS

## 3.2 请求模拟、前后端接口调试

Composer->GET/POST

## 3.3 网络限速

FiddlerScript

# 4 Fiddler插件介绍

[Fiddler插件](http://www.telerik.com/fiddler/add-ons)

## 4.1 代码格式化插件

JavaScript Formatter
Traffic Differ

## 4.2 HTTP代理插件

Willow 还有限速功能

# References
[Fiddler官网](http://www.telerik.com/fiddler)  
[Fiddler工具使用 imooc.com](http://www.imooc.com/learn/37) 
[强大的Http监控工具Fidder简单介绍](http://www.jianshu.com/p/cfc5ca7a8457)

