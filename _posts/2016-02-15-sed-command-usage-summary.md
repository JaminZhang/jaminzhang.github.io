---
layout: post
title: sed 命令用法总结
description: "sed 命令用法总结"
category: Linux
avatarimg:
tags: [Linux, sed]
duoshuo: true
---

# 实例 1

将一个文件的所有中特定行注释掉，比如下面例子将包含 test2 的行加上注释。

```bash
[root@VM_15_187_centos ~]# cat test.log
test
test2
test3
test2
[root@VM_15_187_centos ~]# sed -i "/test2/s/^/#/" test.log
[root@VM_15_187_centos ~]# cat test.log 
test
#test2
test3
#test2

```    


# Ref

[sed 如何注释掉匹配行](http://bbs.chinaunix.net/thread-958787-1-1.html)  
[SED 单行脚本快速参考](http://sed.sourceforge.net/sed1line_zh-CN.html)  
