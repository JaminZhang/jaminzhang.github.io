---
layout: post
title: Logstash 性能排障指南
description: "Logstash 性能排障指南"
category: ELK
avatarimg:
tags: [ELK, Troubleshooting, Production, Logstash, JVM]
duoshuo: true
---

Logstash 性能排障指南(官网文档翻译了一下)


你可以使用本文的排障指南来快速诊断和解决 Logstash 性能问题。  
关于 Pipeline 内部的高级知识在理解这个排障指南时是不需要的。  
但是，Pipeline 文档推荐阅读，如果你想了解超出本指南的更多内容。  

你可能忍不住跳过一些东西和改变像 `pipeline.workers (-w) `的设置作为第一次的尝试去提高性能。   
以我们的经验，改变这个设置使得性能问题排障更加困难，因为你增加了涉及到其中的变量数量。  
取而代之的是，每一次做一个改变并测量结果。从这个列表的最后开始排障是一定会陷入困惑情形的。  

# 性能检查列表

## 1. 检查 input 源和 output 目的地的性能

* Logstash 只能最快到和它所连接的服务的速度。Logstash 消费和产生数据的速度只能达到它的 input 输入数据和 output 输出数据到目的地的速度。

## 2. 检查系统性能统计信息

* CPU

1. 注意，不管 CPU 是否被重度使用，在 Linux/Unix 上，你可以运行 `top -H` 去查看按照线程分隔好的进程统计信息，当然也有总的 CPU 统计信息。
2. 如果 CPU 使用率很高，先跳转到关于检查 JVM heap 的部分，然后再阅读关于调整 Logstash worker 设置的部分。

* Memory

1. 必须意识到 Logstash 运行在 Java VM 上的事实。这意味着 Logstash 将总是使用你分配给它的最大数量的内存。
2. 寻找其他使用大内存的应用，这可能引起 Logstash 使用磁盘上的 swap 分区。如果应用使用的总内存超过了物理内存，这种情况会发生。

* I/O Utilization

1. 监控磁盘 I/O 检查磁盘的繁忙（饱和）程度

  * 如果你使用 Logstash 会使你的存储繁忙的插件（比始 file output），这时磁盘会很繁忙
  * 如果你遇到许多错误导致 Logstash 生成了大的的错误日志，这时磁盘也会很繁忙
  * 在 Linux 上，你可以使用 iostat, dstat, 或者一些类似的工具去监控磁盘 I/O
  
2. 监控网络 I/O 检查网络的繁忙（饱和）程度

  * 如果你使用会进行很多网络操作的 inputs/outputs，这时网络会很繁忙
  * 在 Linux 上，你可以使用一个工具像 dstat 或者 iftop 去监控你的网络

## 3. 检查 JVM heap 堆内存

* 常常 CPU 使用率会飞涨，如果 heap 堆内存大小设置的太小，导致 JVM 经常垃圾回收。
* 检查这个问题的一个快速方式是双倍加大 heap 堆内存的大小，然后看性能是否提高。不要增加堆内存大小超过物理内存。留下至少 1GB 空闲用于操作系统或其他进程。
* 你可以通过使用 Java 自带的 jmap 命令行工具或者 VisualVM 来对 JVM 堆内存做更精确的测量。

## 4. 调整 Logstash worker 设置

* 开始时，使用 -w 选项按比例加大 pipeline workers 数量。这会增加 filters 和 outputs 可用的线程数量。加大这个参数到 CPU 核心数的倍数是安全的，如果有需要的话，因为线程会使 I/O 空闲。
* 默认每一个 output 只能在一个 pipeline worker 线程活跃。你可以通过改变每一个 output 配置块的 workers 设置来增加 output 在多个 worker 线程中活跃。不要设置这个值大于 pipeline workers 总数。
* 你也可以调整输出的批处理大小。对于很多 outputs, 比如 Elasticsearch, 这个设置对应于 I/O 操作的大小。在 Elasticsearch 输出的例子中，这个设置对应于批处理大小。

# Ref
[Performance Troubleshooting Guide](https://www.elastic.co/guide/en/logstash/current/performance-troubleshooting.html)  


