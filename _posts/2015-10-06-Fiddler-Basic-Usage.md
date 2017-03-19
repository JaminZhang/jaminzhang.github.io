---
layout: post
title: Fiddler 工具基本使用
description: "Fiddler 工具基本使用"
category: HTTP
avatarimg:
tags: [HTTP, Fiddler]
duoshuo: true
---

# 1 Fiddler 工具简介

## 1.1 工作环境

[Fiddler 官网](http://www.telerik.com/fiddler)

主要功能（详见官网）：

Web Debugging  
Performance Testing  
HTTP/HTTPS Traffic Recording  
Web Session Manipulation  
Security Testing  
Customizing Fiddler  

## 1.2 工作原理

Fiddler 作为客户端和服务器之间的代理服务器。

Fiddler 的 2 种代理模式

流模式（streaming）：可实时把服务器数据返回给客户端。优点：更接近于浏览器本身真实的行为。  
缓冲模式（buffering）：HTTP 请求的所有数据在服务器端都准备好之后，才把数据返回给客户端。优点：可以控制最后的服务器响应。

## 1.3 常见使用场景

1. 开发环境 hosts 配置
通常情况下，配置 hosts 文件需要修改系统文件，很不方便；在多个开发环境下切换很低效。Fiddler 提供了相对高效的 hosts 配置方法。

2. 前后端接口调试
通常情况下，调试前后端接口需要真实的环境、一大堆假数据、写 JavaScript 代码。Fiddler 只需要一个 UI 界面进行配置即可。

3. 线上 bugfix
Fiddler 可将发布文件代理到本地，快速定位线上 bug。

4. 性能分析和优化
Fiddler 会提供请求的实际图，清晰明了网站需要优化的地方。

# 2 Fiddler 界面操作介绍

## 2.1 工具条常用功能

备注按钮(Set Comments)  
回放按钮（Replay）快捷键 R  
清空监控面板按钮（Remove）  
调试 Debug 按钮（Go）结合状态栏断点图标指示  
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
MSDN 搜索框  

## 2.2 状态栏操作

控制台：help 命令  
Capturing 按钮：控制 Fiddler 是否进行捕获工作  
过滤会话来源  
记录当前展示的会话数量  
显示选中的会话 URL  

## 2.3 监控面板的使用

监控面板是 Fiddler 的最核心的功能之一，显示 HTTP 的会话。

Result: HTTP 状态码  
Protocol: 协议  
Host: 主机  
ServerIP: 服务器 IP  
URL  

监控面板右侧 Tabs

分为上下 2 部分，上部分为 HTTP 请求相关信息，下部分为 HTT P响应相关信息。

数据统计（Statics): RTT 往返时间 Show Chart  
对请求进行解包（Inspectors）:  
Heraders
文件代理（AutoResponder）: 线上 bug 文件本地测试  
前后端接口联调（Composer）: 和服务器接口进行调试 
日志（Log）  
网站性能分析的时间线（Timeline）  

# 3 Fiddler 常用功能

## 3.1 文件、文件夹代理和 HOSTS 配置

AutoResponder
Tools->HOSTS

## 3.2 请求模拟、前后端接口调试

Composer->GET/POST

## 3.3 网络限速

FiddlerScript

# 4 Fiddler 插件介绍

[Fiddler 插件](http://www.telerik.com/fiddler/add-ons)

## 4.1 代码格式化插件

JavaScript Formatter
Traffic Differ

## 4.2 HTTP 代理插件

Willow 还有限速功能

# Ref

[Fiddler 官网](http://www.telerik.com/fiddler)  
[Fiddler 工具使用 imooc.com](http://www.imooc.com/learn/37) 
[强大的 HTTP 监控工具 Fidder 简单介绍](http://www.jianshu.com/p/cfc5ca7a8457)

