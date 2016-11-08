---
layout: post
title: OpenStack 简介
description: "OpenStack 简介"
category: Cloud-Computing
avatarimg:
tags: [Cloud-Computing, IAAS, OpenStack]
duoshuo: true
---

OpenStack 简介

# 1 OpenStack 介绍

<pre>

OpenStack is a cloud operating system that controls large pools of compute, storage, 
and networking resources throughout a datacenter, 
all managed through a dashboard that gives administrators control 
while empowering their users to provision resources through a web interface.

</pre>

![openstack-software-diagram](http://www.openstack.org/themes/openstack/images/software/openstack-software-diagram.png)  

OpenStack 是（Infrastructure As A Service，基础设施即服务）IAAS 架构的实现，  
OpenStack 是一个由 NASA（美国国家航空航天局）和 Rackspace 合作研发并发起的，以 Apache 许可证授权的自由软件和开放源代码项目。  
OpenStack 是一个开源的云计算管理平台项目，由几个主要的组件组合起来完成具体工作。  
OpenStack 支持几乎所有类型的云环境，项目目标是提供实施简单、可大规模扩展、丰富、标准统一的云计算管理平台。  
OpenStack 通过各种互补的服务提供了基础设施即服务（IAAS）的解决方案，每个服务提供 API 以进行集成。  
OpenStack 是一个旨在为公共及私有云的建设与管理提供软件的开源项目。  
它的社区拥有超过 130 家企业及 1350 位开发者，这些机构与个人都将 OpenStack 作为基础设施即服务（IAAS）资源的通用前端。  
OpenStack 项目的首要任务是简化云的部署过程并为其带来良好的可扩展性。
OpenStack 云计算平台帮助服务商和企业内部实现类似于 Amazon EC2 和 S3 的云基础架构服务(Infrastructure as a Service, IaaS)。  
OpenStack 包含两个主要模块：Nova 和 Swift，前者是 NASA 开发的虚拟服务器部署和业务计算模块；后者是 Rackspace 开发的分布式云存储模块，两者可以一起用，也可以分开单独用。  
OpenStack 除了有 Rackspace 和 NASA 的大力支持外，还有包括 Dell、Citrix、Cisco、Canonical 等重量级公司的贡献和支持，发展速度非常快。

# 2 历史版本信息

OpenStack 的核心组件是计算、网络和存储，是为了简化资源的管理和分配，把资源划分为三个比较大的资源池，对外通过 API 进行交互，OpenStack 类似于一个开源的 AWS，有很多功能和 API 和 AWS 是相同的，因为 AWS 底层也是使用的 KVM 虚拟化，当前最新的是 N 版，每半年更新一次新版本，已经从 A-N，从 G 版以后国内的使用用户越来越多，以下是历史版本更新时间：

![OpenStack-Release-History](http://jaminzhang.github.io/images/OpenStack/OpenStack-Release-History.png)

# 3 各组件功能

|服务名称| 项目名称 | 详细描述 |
|------|------------|----------|
| dashboard | Horizon | 基于 OpenStack API 接口使用 Django 开发的 Web 管理服务 |
| compute | Nova | 通过虚拟化技术提供虚拟机计算资源池 |
| networking | 	Neutron | 实现了虚拟机的网络资源管理，即虚拟机网络 |
|| **storage 存储** ||
| object storage | Swift | 对象存储，适用于一次写入多次读取。如图片/ISO 镜像 |
| block storage | Cinder | 块存储，提供存储资源池，保存虚拟机的磁盘镜像等信息 |
|| **shared service 共享服务** ||
| identity service | Keystone | 提供账户登录安全认证 |
| image servicre | Glance | 提供虚拟机镜像的注册和存储管理 |
| telemetry | Ceilometer | 提供监控和数据采集、计量服务 |
|| **higher-level-service 高层服务** ||
| orchestraorchestration | Heat | 自动化组件的部署 |
| database service | Trove | 提供数据库应用服务 |

OpenStack 通过 Nova 调用 KVM/XEN/VMware 等虚拟机化技术创建虚拟机，即 OpenStack 是一个管理平台框架，  
支持众多的虚拟化管理，Cinder 存储支持 GlusterFS、iSCSI、MFS 等存储技术给虚拟机使用，  
即 OpenStack 不会绑定某一个应用，而是兼容众多的相关技术，因此火的一塌糊涂！  


# Ref

[OpenStack Wikipedia](https://en.wikipedia.org/wiki/OpenStack)
[OpenStack Installation Guide for Red Hat Enterprise Linux and CentOS](http://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/index.html)    
[Openstack之一:环境准备及基础服务](https://www.studylinux.net/?p=2881)  
