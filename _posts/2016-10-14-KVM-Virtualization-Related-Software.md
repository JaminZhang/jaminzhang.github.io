---
layout: post
title: KVM 虚拟化相关软件包
description: "KVM 虚拟化相关软件包"
category: Cloud-Computing
avatarimg:
tags: [Cloud-Computing, KVM, QEMU, libvirt]
duoshuo: true
---

KVM 虚拟化相关软件包

# 引言

如果要在 Linux 服务器下安装基于 KVM 的虚拟机，需要安装哪些相关软件呢？
下来就来看看。本文不是完整的 KVM 安装配置文档，只是先看看 KVM 虚拟化的相关软件包。

# KVM 虚拟化相关软件包

`yum install qemu-kvm qemu-kvm-tools libvirt virt-manager`

一般安装上面 KVM 相关软件包和工具包，就可以安装在 Linux 上创建运行虚拟机了。
下面我们来分别看看上面这几个软件的简介，使用 yum 查询一下，如下：

```bash

qemu-kvm.x86_64 : Userspace component of KVM
qemu-kvm-tools.x86_64 : KVM debugging and diagnostics tools
libvirt.x86_64 : Library providing a simple virtualization API
virt-manager.x86_64 : Virtual Machine Manager

```    

当然 yum 安装上述几个软件包时，会有相关的依赖包也会被安装上，这里就不列出来了。

# Ref
[虚拟化之 KVM](https://www.studylinux.net/?p=2678)  
