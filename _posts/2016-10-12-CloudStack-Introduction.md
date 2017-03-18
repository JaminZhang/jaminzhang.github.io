---
layout: post
title: CloudStack 简介
description: "CloudStack 简介"
category: Cloud-Computing
avatarimg:
tags: [Cloud-Computing, IAAS, CloudStack]
duoshuo: true
---

CloudStack 简介

# 1 云计算介绍

##  云计算的出现

基本上，云计算只是一种把 IT 资源当作服务来提供的手段。  
几乎所有 IT 资源都可以作为云服务来提供：应用程序、计算能力、存储容量、联网、编程工具，以至于通信服务和协作工具。  

云计算最早为 Google、Amazon 等其他扩建基础设施的大型互联网服务提供商所采用。  
于是产生一种架构：大规模扩展、水平分布的系统资源，抽象为虚拟 IT 服务，并作为持续配置、合用的资源进行管理。  

就最终用户而言，云计算意味着没有硬件购置成本、没有需要管理的软件许可证或升级、不需要雇佣新的员工或咨询人员、不需要租赁设施、没有任何种类的基建投资，
而且还没有隐性成本。只是一种用仪表测量出来的、根据使用情况支付的订购费或固定的订购费。只是用您所需的量，而且只按使用量付费。  

云计算体系结构图如下：  
![Cloud-Computing-Architecture](http://jaminzhang.github.io/images/Cloud-Computing/Cloud-Computing-Architecture.png)  

## 基础设施即服务：IAAS

把基础设施当作服务 (IaaS) 处于最低层级，而且是一种作为标准化服务在网上提供基本存储和计算能力的手段。
服务器、存储系统、交换机、路由器和其他系统协作 (例如，通过虚拟化技术) 处理特定类型的工作负载 — 从批处理到峰值负载期间的服务器/存储扩大。  

最著名的商业示例是 Amazon Web 服务 (AWS)，其 EC2 和 S3 服务分别提供基本计算和存储服务。国内代表阿里云、腾讯云、百度云、金山云等。  

## IAAS 虚拟化的好处

* 资源利用率更高 — 在虚拟化之前，企业数据中心的服务器和存储利用率一般平均不到 50% (事实上，通常利用率为 10% 到 15%)。通过虚拟化，可以把工作负载封装一并转移到空闲或使用不足的系统，这就意味着可以整合现有系统，因而可以延迟或避免购买更多服务器容量。
* 资源整合 — 虚拟化使得整合多个 IT 资源成为可能。除服务器和存储整合之外，虚拟化提供一个整合系统架构、应用程序基础设施、数据和数据库、接口、网络、桌面系统甚至业务流程，因而可以节约成本和提高效率。
* 节省电能/成本 — 运行企业级数据中心所需的电能不再无限制地使用，而成本呈螺旋式上升趋势。在服务器硬件上每花一美元，就会在电费上增加一美元 (包括服务器运行和散热方面的成本)。利用虚拟化进行整合使得降低总能耗和节约大量资金成为可能。
* 节约空间 — 服务器膨胀仍然是多数企业数据中心面临的一个严重问题，可扩大数据中心并不总是一个良好的选择，因为每增大一平方米空间，就会平均增加很多成本。虚拟化通过把多个虚拟系统整合到较少物理系统上，可以缓解空间压力。
* 灾难恢复 (Disaster recovery) /业务连续 (Business Continuity) — 虚拟化可提高总体服务级利用率，并提供灾难恢复解决方案新选项。

# 2 CloudStack 是什么

<pre>

What is Apache CloudStack?

Apache CloudStack is an open source Infrastructure-as-a-Service platform that 
manages and orchestrates pools of storage, network, and computer resources 
to build a public or private IaaS compute cloud.

With CloudStack you can:

* Set up an on-demand elastic cloud computing service.
* Allow end-users to provision resources

</pre>

CloudStack 是 Citrix 公司在 IaaS  市场上的主打产品，它提供了对云计算资源的灵活部署与管理能力，2013 年 Citrix 将其源代码贡献给 Apache 后，CloudStack 成为一个开源项目，CloudStack 是一个 IaaS 级的服务，IaaS 提供了对资源的自动化管理能力。
例如用界面、脚本甚至 Web Service API 实现对大量硬件、大量虚拟机的生命周期管理。  
IaaS 产品面对的是大规模、可伸缩的云环境，这是与用手工管理有限资源的方式完全不同的一类系统。

CloudStack 前身为 cloud.com 的商业化产品，它在 2011 年被 Citrix 以超过二亿美金价格收购，随后又被捐献给 Apache 基金会。
这项产品开源的举措，引起了市场对 IaaS 发展路线的一些争议，例如它与另外一个开源产品 OpenStack 的竞争与合作关系。
OpenStack 是由 Rackspace 和 NASA 主导开发的一个 IaaS，它拥有更大的用户群，包括 HP，IBM，Dell 和 Red Hat 等大公司，
下面列出了 CloudStack 与 OpenStack 的一些对比。

|对比项| CloudStack | OpenStack |
|------|------------|-----------|
|License|Apache 2.0 授权协议，可免费用于商业模式|Apache 2.0 授权协议，可免费用于商业模式|
|支持的 Hypervisors|KVM，XEN，Oracle VM，vSphere 和 Bare Metal|KVM，XEN，（有限支持 Hyper-V，ESX，PowerVM）|
|支持的 Networking Model|OpenFlow，VLAN 和 Flat networks|VLAN，Flat，Flat DHCP|
|支持的 Storage|NFS，Cluster LVM，Rados Block Device(Ceph)，Local Storage|iSCSI，Ceph，NFS，Local Storage 和 Swift（对象存储）|
|客户群|包括诺基亚，Zynga，日本电报电话公司，塔塔，阿尔卡特|包括了 NASA，Rackspace，HP，红帽，Piston|
|开发语言|Java 为主|Python 为主|
|兼容亚马逊 EC2 API|是|是|

# 3 CloudStack 介绍

* CloudStack 是一个开源的具有高可用性及扩展性的云计算平台。
* CloudStack 是一个开源的云操作系统，它可以帮助用户利用自己的硬件提供类似于 Amazon EC2 那样的公共云服务。  
* CloudStack 可以通过组织和协调用户的虚拟化资源，构建一个和谐的环境。
* Cloudstack 支持管理大部分主流的 hypervisors，如 KVM，XenServer，VMware，Oracle VM，Xen 等。

![CloudStack-Hypervisors](http://jaminzhang.github.io/images/CloudStack/CloudStack-Hypervisors.png)  

Cloudstack 部署架构图如下：  
![CloudStack-Architecture-and-Concepts](http://jaminzhang.github.io/images/CloudStack/CloudStack-Architecture-and-Concepts.png)  
![region-overview](http://docs.cloudstack.apache.org/en/latest/_images/region-overview.png)

CloudStack 相关概念及术语如下：

## Zone

Zone 对应于现实中的一个数据中心，它是 CloudStack 中最大的一个单元。  
即从包含关系上来说，一个 Zone 包含多个 Pod，一个 Pod 包含多个 Cluster，一个 Cluster 包含多个 Host。

## 提供点（Pods）

一个提供点通常代表一个机架，机柜里面的主机在同一个子网，每个区域中必须包含一个或多个提供点，提供点中包含主机和主存储服务器，  
CloudStack 的内部管理通信配置一个预留 IP 地址范围。预留的 IP 范围对云中的每个区域来说必须唯一。

## 集群（Clusters）

Cluster 是多个主机组成的一个集群。  
同一个 Cluster 中的主机有相同的硬件，相同的 Hypervisor，和共用同样的存储。  
同一个 Cluster 中的虚拟机，可以实现无中断服务地从一个主机迁移到另外一个上。  
集群由一个或多个宿主机和一个或多个主要存储服务器构成。  
集群的大小取决于下层虚拟机软件。大多数情况下基本无建议。  
当使用 VMware 时，每个 VMware 集群都被 vCenter 服务器管理。  
管理员必须在本产品中登记 vCenter。每个 Zone 下可以有多个 vCenter 服务器。每个 vCenter 服务器可能管理多个 VMware 集群。

## 主机（Hosts）

Host 就是运行的虚拟机（VM）主机。  

宿主机就是个独立的计算机。宿主机运行来宾虚拟机并提供其相应的计算资源。  
每个宿主机都装有虚拟机软件来运行来宾虚拟机。  
比如一个开启了 kvm 支持的服务器，一个思杰 XenServer 服务器，或者一个 ESXi 服务器都可以作为宿主机。  
宿主机在 CloudStack 部署中属于最小的组织单元。  
宿主机包含于集群中，集群又属于提供点，而区域中包含提供点（就是在逻辑概念上 Zone>Pod>Cluster>Host ），  
新增的宿主机可以随时添加以提供更多资源给来宾虚拟机，CloudStack 自动探测宿主机的 CPU 数量和内存资源。  
宿主机对终端用户不可见。终端用户不能决定他们的虚拟机被分配到哪台宿主机。  

## CloudStack 中存在两种存储

* Primary Storage：一级存储与 Cluster 关联，它为该 Cluster 中的主机的全部虚拟机提供磁盘卷。一个 Cluster 至少有一个一级存储，且在部署时位置要临近主机以提供高性能。
* Secondary Storage：二级存储与 Zone 关联，它存储模板文件，ISO 镜像和磁盘卷快照。


# Ref
[What is Apache CloudStack?](http://docs.cloudstack.apache.org/en/latest/concepts.html)  
[云计算之一:CloudStack安装及基础环境配置](https://www.studylinux.net/?p=2753)  
