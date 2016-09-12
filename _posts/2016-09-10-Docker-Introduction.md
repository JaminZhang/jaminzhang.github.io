---
layout: post
title: Docker 简介
description: "Docker 简介"
category: Docker
avatarimg:
tags: [Docker, Image, Container, Repository]
duoshuo: true
---

Docker 简介

# 什么是 Docker

<pre>
Docker 是一个开源项目，诞生于 2013 年初，最初是 dotCloud 公司内部的一个业余项目。它基于 Google 公司推出的 Go 语言实现。 
项目后来加入了 Linux 基金会，遵从了 Apache 2.0 协议，项目代码在 GitHub 上进行维护。

Docker 自开源后受到广泛的关注和讨论，以至于 dotCloud 公司后来都改名为 Docker Inc。
Redhat 已经在其 RHEL6.5 中集中支持 Docker；Google 也在其 PaaS 产品中广泛应用。

Docker 项目的目标是实现轻量级的操作系统虚拟化解决方案。 Docker 的基础是 Linux 容器（LXC）等技术。

在 LXC 的基础上 Docker 进行了进一步的封装，让用户不需要去关心容器的管理，使得操作更为简便。
用户操作 Docker 的容器就像操作一个快速轻量级的虚拟机一样简单。
</pre>

下面的图片比较了 Docker 和传统虚拟化方式的不同之处，可见容器是在操作系统层面上实现虚拟化，直接复用本地主机的操作系统，
而传统方式则是在硬件层面实现。  

![virtualization](https://yeasy.gitbooks.io/docker_practice/content/_images/virtualization.png)  
![docker](https://yeasy.gitbooks.io/docker_practice/content/_images/docker.png)  

# 为什么要使用 Docker？

<pre>
作为一种新兴的虚拟化方式，Docker 跟传统的虚拟化方式相比具有众多的优势。

首先，Docker 容器的启动可以在秒级实现，这相比传统的虚拟机方式要快得多。 
其次，Docker 对系统资源的利用率很高，一台主机上可以同时运行数千个 Docker 容器。

容器除了运行其中应用外，基本不消耗额外的系统资源，使得应用的性能很高，同时系统的开销尽量小。
传统虚拟机方式运行 10 个不同的应用就要起 10 个虚拟机，而 Docker 只需要启动 10 个隔离的应用即可。
</pre>

具体说来，Docker 在如下几个方面具有较大的优势。

## 更快速的交付和部署

<pre>
对开发和运维（devop）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。

开发者可以使用一个标准的镜像来构建一套开发容器，开发完成之后，运维人员可以直接使用这个容器来部署代码。 
Docker 可以快速创建容器，快速迭代应用程序，并让整个过程全程可见，使团队中的其他成员更容易理解应用程序是如何创建和工作的。 
Docker 容器很轻很快！容器的启动时间是秒级的，大量地节约开发、测试、部署的时间。
</pre>

## 更高效的虚拟化

>
Docker 容器的运行不需要额外的 hypervisor 支持，它是内核级的虚拟化，因此可以实现更高的性能和效率。

## 更轻松的迁移和扩展

>
Docker 容器几乎可以在任意的平台上运行，包括物理机、虚拟机、公有云、私有云、个人电脑、服务器等。 
这种兼容性可以让用户把一个应用程序从一个平台直接迁移到另外一个。

## 更简单的管理

>
使用 Docker，只需要小小的修改，就可以替代以往大量的更新工作。所有的修改都以增量的方式被分发和更新，从而实现自动化并且高效的管理。

## 对比传统虚拟机总结

|特性|容器|虚拟机|
|----|----|------|
|启动|秒级|分钟级|
|硬盘使用|一般为 MB|一般为 MB|
|性能|接近原生|弱于|
|系统支持量|单机支持上千个容器|一般几十个|

# 基本概念

Docker 包括三个基本概念

* 镜像（Image）
* 容器（Container）
* 仓库（Repository）

## 镜像

<pre>
Docker 镜像（Image）就是一个只读的模板。

例如：一个镜像可以包含一个完整的 ubuntu 操作系统环境，里面仅安装了 Apache 或用户需要的其它应用程序。

镜像可以用来创建 Docker 容器。

Docker 提供了一个很简单的机制来创建镜像或者更新现有的镜像，用户甚至可以直接从其他人那里下载一个已经做好的镜像来直接使用。
</pre>

## 容器

<pre>
Docker 利用容器（Container）来运行应用。

容器是从镜像创建的运行实例。它可以被启动、开始、停止、删除。每个容器都是相互隔离的、保证安全的平台。

可以把容器看做是一个简易版的 Linux 环境（包括root用户权限、进程空间、用户空间和网络空间等）和运行在其中的应用程序。

*注：镜像是只读的，容器在启动的时候创建一层可写层作为最上层。
</pre>

## 仓库

<pre>
仓库（Repository）是集中存放镜像文件的场所。有时候会把仓库和仓库注册服务器（Registry）混为一谈，并不严格区分。
实际上，仓库注册服务器上往往存放着多个仓库，每个仓库中又包含了多个镜像，每个镜像有不同的标签（tag）。

仓库分为公开仓库（Public）和私有仓库（Private）两种形式。

最大的公开仓库是 Docker Hub，存放了数量庞大的镜像供用户下载。

国内的公开仓库包括 时速云 、网易云 等，可以提供大陆用户更稳定快速的访问。

当然，用户也可以在本地网络内创建一个私有仓库（参考本文“私有仓库”部分）。

当用户创建了自己的镜像之后就可以使用 push 命令将它上传到公有或者私有仓库，
这样下次在另外一台机器上使用这个镜像时候，只需要从仓库上 pull 下来就可以了。

*注：Docker 仓库的概念跟 Git 类似，注册服务器可以理解为 GitHub 这样的托管服务。
</pre>

# Ref
[WHAT IS DOCKER?](https://www.docker.com/what-docker)  
[什么是 Docker](https://yeasy.gitbooks.io/docker_practice/content/introduction/what.html)  
[为什么要使用 Docker？](https://yeasy.gitbooks.io/docker_practice/content/introduction/why.html)  
[Understand the architecture](https://docs.docker.com/v1.11/engine/understanding-docker/)
