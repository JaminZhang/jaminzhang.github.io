---
layout: post
title: CentOS Kickstart 安装操作系统
description: "CentOS Kickstart 安装操作系统"
category: Linux
avatarimg:
tags: [Linux, Kickstart]
duoshuo: true
---

# 引言

最近重新接触安装操作系统，所以重新复习一下 Kickstart 安装系统。

# 什么是 Kickstart 安装

首先复习什么是 Kickstart 安装，红帽官网解释如下：


<pre>

Kickstart installations offer a means to automate the installation process, either partially or fully. 
Kickstart files contain answers to all questions normally asked by the installation program, 
such as what time zone you want the system to use, how the drives should be partitioned, 
or which packages should be installed. 
Providing a prepared Kickstart file when the installation begins therefore 
allows you to perform the installation automatically, without need for any intervention from the user. 
This is especially useful when deploying Red Hat Enterprise Linux on a large number of systems at once.

</pre>

第一句话就是重点。Kickstart 是自动化安装系统一种方式。
下面的中文用另一种表述说明 Kickstart 作用：

<pre>

通常，我们在安装操作系统的过程中，需要大量的和服务器交互操作，为了减少这个交互过程，kickstart 就诞生了。
使用这种 Kickstart，只需事先定义好一个 Kickstart 自动应答配置文件 ks.cfg（通常存放在安装服务器上），
并让安装程序知道该配置文件的位置，在安装过程中安装程序就可以自己从该文件中读取安装配置，
这样就避免了在安装过程中多次的人机交互，从而实现无人值守的自动化安装。

</pre>

# 怎样准备一个 Kickstart 安装

流程如下（具体操作参见红帽官网，这里就不写了）

## 1.创建一个 Kickstart 文件

## 2.验证 Kickstart 文件    

## 3.使 Kickstart 文件可用  

## 4.使安装源可用  

## 5.开始安装 Kickstart 安装  



# Kickstart 无人值守安装系统

上面说到的 Kickstart 安装只是将系统安装程序启动后的过程的应答自动化了，但还不够自动化。
一般我们会将 Kickstart 结合 PXE 网卡启动实现真正的无人值守网络安装。

下面给出一个概括的流程（具体操作参见 Ref 中他人写的较好文档）：

## 1.安装配置 DHCP 服务

给 PXE 客户端分配 IP/网关/DNS/TFTP服务器IP/PXE文件等网络配置信息

## 2.安装配置 TFTP 服务

提供 PXE 客户端启动所需的 `pxelinux.0、pxelinux.cfg/default、vmlinuz、initrd.img` 等启动文件

## 3.安装配置 HTTP 服务

提供 PXE 客户端加载 Linux 安装内核后，读取的 Kickstart 配置文件 ks.cfg，还有也同时作为 HTTP 安装源

## 4.准备 ks.cfg 文件

参见“怎样准备一个 Kickstart 安装”

## 5.配置 PXE 启动
在`pxelinux.cfg/default`文件中指定 ks.cfg 文件位置

## 6.无人值守自动安装

开机 PXE 启动，进行无人值守自动安装

# Ref
[KICKSTART 无人值守安装](http://www.zyops.com/autoinstall-kickstart)  
[红帽企业版 Linux 7 安装指南 第 23 章 KICKSTART 安装](https://access.redhat.com/documentation/zh-CN/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/chap-kickstart-installations.html)  
[CHAPTER 23. KICKSTART INSTALLATIONS](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/chap-kickstart-installations.html)  
[基于 Kickstart 自动化安装 CentOS 实践](https://wsgzao.github.io/post/kickstart/)  


