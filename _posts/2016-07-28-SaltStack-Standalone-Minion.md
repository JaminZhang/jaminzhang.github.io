---
layout: post
title: SaltStack - 独立的 Minion （无 Master 架构）
description: "SaltStack - 独立的 Minion （无 Master 架构）"
category: SaltStack
avatarimg:
tags: [SaltStack, Masterless]
duoshuo: true
---


Masterless 架构（无 Master 的架构）

# 单独的 Minion

由于 Salt minoin 包含如此大量的功能，独立运行 minion 也会很有用。  
一个独立的 minion 可以做许多事情：

* 在一个系统上使用 salt-call 命令，不需要连接到 master
* 无 Master 的状态，运行状态，文件完全来自己 minion 本地

注意：
当运行 Salt 在 masterless 模式时，不要运行 salt-minion 进程。

## Minion 配置


## Masterless Minion 配置步骤

### 1. 关闭 Salt Minion 进程

>
systemctl stop salt-minion

### 2. 修改 Salt Minion 配置文件

salt-call 命令会使用 minion 的配置文件

修改 /etc/salt/minion 相关参数如下：

>
file_client: local

根据实际情况修改 file_roots、pillar_roots 参数


### 3. 编写 SLS

### 4. 执行 salt-call

> 
salt-call --local state.highstate
或  
salt-call state.apply --local

# Ref
[STANDALONE MINION](https://docs.saltstack.com/en/latest/topics/tutorials/standalone_minion.html)  
