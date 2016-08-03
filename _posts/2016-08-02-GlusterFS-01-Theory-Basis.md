---
layout: post
title: GlusterFS 01 理论基础
description: "GlusterFS 01 理论基础"
category: GlusterFS
avatarimg:
tags: [FileSystem, GlusterFS, NFS]
duoshuo: true
---

# 1 理论基础

## 1.1 分布式文件系统出现

计算机通过文件系统管理、存储数据，而现在数据信息爆炸的时代中人们可以获取的数据成指数倍的增长，单纯通过增加硬盘个数来扩展计算机文件系统的存储容量的方式，已经不能满足目前的需求。  

分布式文件系统可以有效解决数据的存储和管理难题，将固定于某个地点的某个文件系统，扩展到任意多个地点、多个文件系统，众多的节点组成一个文件系统网络。每个节点可以分布在不同的地点，通过网络进行节点间的通信和数据传输。人们在使用分布式文件系统时，无需关心数据是存储在哪个节点上、或者是从哪个节点获取的，只需要像使用本地文件系统一样管理和存储文件系统中的数据。

## 1.2 典型代表 NFS

NFS(Network File System) 即网络文件系统，它允许从网络中的计算机之间通过 TCP/IP 网络共享资源。在 NFS 的应用中，本地 NFS 的客户端应用可以透明地读写位于远端 NFS 服务器上的文件，就像访问本地文件一样。NFS 的优点如下：

### 1.2.1 节约使用磁盘空间
客户端经常使用的数据可以集中存放在一台机器上，并使用 NFS 发布，那么网络内的所有计算机可以通过网络访问，不必单独存储。

### 1.2.2 节约硬件资源
NFS 还可以共享软驱，CD-ROM 等存储设备，减少整个网络上的可移动设备数量。

### 1.2.3 用户主目录设定
对于特殊用户，如管理员等，为了管理的需要，可能会经常登录到网络中所有的计算机，若每个客户端，均保存这个用户的主目录很繁琐，而且不能保证数据的一致性。实际上，经过 NFS 服务的设定，然后在客户端指定这个用户的主目录位置，并自动挂载，就可以在任何计算机上使用用户主目录的文件。

## 1.3 NFS 面临的问题

* 存储空间不足，需要更大容量的存储
* 直接用 NFS 挂载存储，有一定的风险，存在单点故障
* 某些场景不能满足要求，大量的访问下磁盘 IO 是瓶颈

## 1.4 GlusterFS 概述

<pre>
A STORAGE PLATFORM FOR PHYSICAL, VIRTUAL, AND CLOUD ENVIRONMENTS

Red Hat® Gluster Storage is an open, software-defined scale-out storage platform. 
Use it to easily manage unstructured data for physical, virtual, and cloud environments. 
Red Hat Gluster Storage combines both file and object storage with a scale-out architecture, designed to cost-effectively store and 
manage petabyte-scale data growth. It delivers a continuous storage fabric across physical, virtual, and cloud resources, 
which lets you transform your big, semi-structured, and unstructured data from a burden to an asset.
</pre>


GlusterFS 是 Scale-Out 存储解决方案 Gluster 的核心，它是一个开源的分布式文件系统，具有强大的横向扩展能力，通过扩展能够支持数 PB 存储容量和处理数千客户端。 GlusterFS 借助 TCP/IP 或 InfiniBand RDMA 网络将物理分布的存储资源聚集在一起，使用单一全局命名空间来管理数据。GlusterFS 基于可堆叠的用户空间设计，可为各种不同的数据负载提供优异的性能。  

GlusterFS 支持运行在任何 IP 网络上的标准应用程序的标准客户端，用户可以在全局统一的命名空间中使用 NFS/CIFS 等标准协议来访问应用数据。GlusterFS 使得用户可摆脱原有的独立、高成本的封闭存储系统，能够利用普通廉价的存储设备来部署可集中管理、横向扩展、虚拟化的存储池，存储容量可扩展至 TB/PB 级。  

目前 GlusterFS 已被 Red Hat 收购，它的官网是：http://www.gluster.org/

## 1.5 GlusterFS 在企业中的应用场景

理论和实践上分析，GlusterFS 目前主要适用于大文件存储场景，对于小文件尤其是海量小文件，存储效率和访问性能都表现不佳。海量小文件 LOSF 问题是工业界和学术界公认的难题，GlusterFS 作为通用的分布式文件系统，并没有对小文件作额外的优化措施，性能不好也是可以理解的。

<pre>
STORE VARIOUS KINDS OF UNSTRUCTURED DATA:

* Rich media content like videos, images and audio files
* Backup-images and Nearline archives
* Big data — Log files, RFID data, and other machine-generated data
* Virtual machine images
</pre>

* Media - 文档、图片、音频、视频
* Shared storage - 云存储、虚拟化存储、HPC(高性能计算)
* Big data - 日志文件、RFID(射频识别)数据

>
文件大小大于 1MB 适合 GlusterFS，如果更小可以选用其他文件系统，如 FastFS 等，或者配置 CDN。

# Ref
[GlusterFS](http://www.gluster.org/)  
[RED HAT GLUSTER STORAGE](https://engage.redhat.com/gluster-storage-platform-s-201604060217?sc_cid=701600000011oBEAAY)  
