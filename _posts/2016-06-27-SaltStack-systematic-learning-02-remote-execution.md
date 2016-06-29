---
layout: post
title: SaltStack 系统性学习 02 - 远程执行
description: "SaltStack 系统性学习 02 - 远程执行"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# Salt 远程执行

Salt 命令执行使用一个通用的结构，如下图：

![salt-cmd-syntax](https://docs.saltstack.com/en/getstarted/images/cmd-syntax.png)


使用 sys.doc 查询模块相关信息  

```bash
[root@linux-node1 ~]# salt '*' sys.doc sys.doc
sys.doc:

    Return the docstrings for all modules. Optionally, specify a module or a
    function to narrow the selection.

    The strings are aggregated into a single document on the master for easy
    reading.

    Multiple modules/functions can be specified.

    CLI Example:

        salt '*' sys.doc
        salt '*' sys.doc sys
        salt '*' sys.doc sys.doc
        salt '*' sys.doc network.traceroute user.info

    Modules can be specified as globs.

    New in version 2015.5.0

        salt '*' sys.doc 'sys.*'
        salt '*' sys.doc 'sys.list_*'
    
```    


## 运行 Shell 命令

使用 cmd.run

cmd.run 直接好用，但 Salt 远程执行更强大的是执行函数，这样不用写复杂的脚本来实现功能，而且返回的结果是格式化的，便于进一步处理。下面列举一些 执行函数。


## 检测 Minion 运行状态

使用 test.ping 
> 
Used to make sure the minion is up and responding. Not an ICMP ping.

## 显示磁盘用量

使用 disk.usage

## 安装一个软件包

使用 pkg.install

## 列出网络接口

使用 network.interfaces

更多执行模块请看 [EXECUTION MODULES](https://docs.saltstack.com/en/latest/ref/modules/all/index.html)  


# Ref
[EXECUTE COMMANDS](https://docs.saltstack.com/en/getstarted/fundamentals/remotex.html)  
