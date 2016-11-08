---
layout: post
title: 云计算与 KVM 虚拟化简介
description: "云计算与 KVM 虚拟化简介"
category: Cloud-Computing
avatarimg:
tags: [Cloud-Computing, KVM, XEN, VMWare, Hyper-V, IDC]
duoshuo: true
---


云计算与 KVM 虚拟化简介

# 引言
现在云计算已经成为主流。我们来重新学习回顾下。  

# 传统数据中心

## 1 传统的物理机部署流程方案

服务器选型及采购 -> IDC 选择及上架 -> 操作系统选择及安装 -> 应用规划及部署 -> 域名规划及注册 -> DNS 映射 -> 外网访问

**关于备案**

* 工信部备案
* 公安部备案
* ICP 备案(电子商务网站 –> ICP 证经营性 ICP 备案)
* 游戏公司文化部(文网文)备案

在备案没有成功之前网站是不能上线访问的，论坛 BBS 有 BBS 公告备案是备案的前置审批，没有的话备案不成功，还要在公安局系统备案，另外域名接入到一个地方比如机房还要做接入备案，备案在个人名下的备案不能直接转公司，个人注销后网站属于未备案状态随时可能会被封，域名备案一般可以找代理，因为过程比较复杂。

## 2 传统数据中心面临的问题

* 服务器资源利用率低下，CPU、内存等不能共享
* 资源分配不合理
* 初始化成本高
* 自动化能力差

# 云计算

## 1 云计算定义

* 云计算是一种交付模式
* 云计算必须通过网络使用
* 支持弹性横向扩展、按需付费和快速扩展
* 无需关心基础设置，服务器硬件、存储、机房安全、硬件监控、底层数据安全等无需考虑

## 2 云计算的概念与分类

云计算的概念最早是由 Google 前首席执行官埃里克•施密特（Eric Schmidt）在 2006 年 8 月 9 日的搜索引擎大会上首次提出的一种构想，而“云计算”就是这种构想的代名词，云计算以虚拟化为基础，以网络为中心，为用户提供安全、快速、便捷的数据存储和网络计算服务，包括所需要的硬件、平台、软件及服务等资源，而提供资源的网络就被称为“云”。

* 公有云：像 AWS、阿里云以及 Azure 都属于公有云，每个人都可以付费使用，不需要自己关心底层硬件，但是数据安全需要考虑。
* 私有云：在自己公司内部或 IDC 自建 OpenStack 等环境。
* 混合云：临时需求使用公有云，但是主要业务放在自己的私有云，即自己的私有云的部分业务和公有云有交集，这部分称为混合云

## 3 云计算的分层

![Cloud-Computing-Layer](http://jaminzhang.github.io/images/Cloud-Computing/Cloud-Computing-Layer.jpg)  


## 4 虚拟化技术

云计算是一种模式，虚拟化是利用相应的技术方法在一台物理机器上将其按照不同的需求划分成多个相同或者不同的虚拟操作系统，并且各个虚拟系统可以同时运行，互不干扰，其中任何一个虚拟系统的损坏都不影响同一物理服务器上的其他虚拟系统。

## 5 虚拟化的前生与今世

<pre>
1964 年，IBM 推出了专为 System/360 Mainframe 量身订造的操作系统 CP-40，首次实现了虚拟内存和虚拟机。

1967 年，第一个管理程序(hypervisor)诞生，5 年之后，IBM 发布用于创建灵活大型主机的虚拟机(VM)技术，
该技术可根据动态的需求快速而有效地使用各种资源。从此，虚拟化这一词汇正式被引入了 IT 的现实世界。

20 世纪 90 年代 Windows 的广泛使用以及 Linux 作为服务器系统的出现奠定了 x86 服务器的行业标准地位。

1998年 VMware 公司在美国成立，1999 年 VMware 发布了它的第一款产品 VMware Workstation、 2001 年发布 VMware GSX Server 和 VMware ESX Server，
宣布进入服务器虚拟化市场，

2003 年 VMware 推出了 VMware Virtual Center， 2004 年推出了 64 位支持版本，同年被 EMC 收购，2013 年收入 52.1 亿美元。 

2007 年 8 月 21 日，思杰宣布 5 亿美元收购 XenSource 公司，并推出服务器虚拟化 XenServer、桌面虚拟化 XenDesktop 和应用虚拟化 XenApp，2013 年收入 29 亿美元。

2008 年 3 月 13 日微软在北京发布 Windows Server 2008，内置虚拟化技术 hyper-v。

2008 年 9 月，红帽以 1.07 亿美元的价格收购 KVM 的母公司 Qumranet，并推出企业级虚拟化解决方案 RHEV，2013年收入超过 13 亿美元。
</pre>

## 6 目前全球主要的虚拟化厂商

此图表数据比较老了。  
![Virtualization-Company](http://jaminzhang.github.io/images/Cloud-Computing/Virtualization-Company.png)  

## 7 各虚拟化软件对比

1、VMware 是目前市场上服务器虚拟化占有率最高的厂商，原因是其起步早、并且优先于其他厂商推出 x86 虚拟化产品、产品功能相对完善从而优先占据市场，但是其代码不公开，并且严重依赖 Windows 服务器系统，也就是厂商绑定，一旦用了 VMware 就得购买微软的系统，购买了微软的系统就处处受微软的限制，另外 VMware 的授权费用较高（每颗 CPU 授权 78000 元，两颗起售）。

2、微软针对 Windows Server 2008 标准版、企业版与数据中心版，各推出内建 Hyper-V 的虚拟化环境，需要购买 Windows Server 2008、Hyper-Vmanager 与 CPU 授权等，其总体花费较高，而且稳定性不高，目前使用市场较小。

3、思杰看到 VMware 在虚拟化领域的成果之后在 2007 年收购 XenSource 公司（Xen 虚拟化），随后推出针对服务器虚拟化的 XenServer、桌面虚拟化 XenDesktop 以及针对应用虚拟化的 XenApp，但是思杰的虚拟化方案成本比较高，配置和管理非常复杂，Xen Desktop 也严重依赖微软的 Windows Server 系统，也就是要先购买微软的服务器授权，然后在 Windows Server 上安装 Xendesktop，因此产生了较高的费用而且稳定性也不是很好。

4、 红帽的虚拟化基于 KVM，而 KVM（Kernel-based Virtual Machine )是红帽在 2008 年收购而来，其代码完全开源，工作原理是将模块 kvm.ko 加载到 kernel 里运行，从而获得最高效的虚拟能力，红帽成立于 1995 年是全球最大的 Linux 开源技术厂家, KVM 是基于虚拟化扩展（Intel  VT 或 AMD-V）的 x86 硬件，是 Linux 完全原生的全虚拟化解决方案，主要是通过准虚拟网络驱动程序的形式用于 Linux 和 Windows   客户机系统的，KVM 支持广泛的客户机操作系统，比如 Linux、BSD、Solaris、Windows XP、Windows 7、Windows 8、Ubuntu 等大多数操作系统，目前 KVM 已经是各大 Linux 发行版本所支持的虚拟化产品。


# 虚拟化技术之 KVM

KVM 是虚拟化技术的一种。

<pre>
Kernel Virtual Machine

KVM (for Kernel-based Virtual Machine) is a full virtualization solution for Linux on x86 hardware containing virtualization extensions (Intel VT or AMD-V). 

It consists of a loadable kernel module, kvm.ko, that provides the core virtualization infrastructure and a processor specific module, kvm-intel.ko or kvm-amd.ko.

Using KVM, one can run multiple virtual machines running unmodified Linux or Windows images. 
Each virtual machine has private virtualized hardware: a network card, disk, graphics adapter, etc.

KVM is open source software. The kernel component of KVM is included in mainline Linux, as of 2.6.20. 
The userspace component of KVM is included in mainline QEMU, as of 1.3.

Blogs from people active in KVM-related virtualization development are syndicated at http://planet.virt-tools.org/
</pre>

qemu 是软件虚拟化，即使用软完全模拟出一个具备 CPU/内存和硬盘等设备的服务器，
KVM 是全虚拟化，XEN 是半虚拟化，KVM 在部分设备也支持半虚拟化。


# Ref
[KVM](http://www.linux-kvm.org/page/Main_Page)  
[虚拟化之KVM](https://www.studylinux.net/?p=2678)  
[深度实践KVM](https://book.douban.com/subject/26606473/)  
[云主机和物理机PK|谁将蓝瘦香菇？](http://mp.weixin.qq.com/s?__biz=MzAwMDM2NzUxMg==&mid=2247485451&idx=1&sn=8c5748dcc3a06e9d8c6ef852560e33f0&chksm=9aeb46fcad9ccfea027ce69851a66479deca3e123ef0185f4cde818f4a3ffb7fef04871f4a1c&mpshare=1&scene=23&srcid=1108s6cL2TTR9knlsypS5tkr#rd)  
