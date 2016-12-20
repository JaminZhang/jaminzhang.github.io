---
layout: post
title: Shell 实现找出两个目录下的同名文件
description: "Shell 实现找出两个目录下的同名文件"
category: Shell
avatarimg:
tags: [Linux, Shell, Bash, find]
duoshuo: true
---


Shell 实现找出两个目录下的同名文件


# 引言

Shell 实现找出两个目录下的同名文件

这是一个面试问的关于 Shell 的问题，自己没碰到过这种情况，
比较考验自己的一个逻辑思考的能力。自己当时有点懵，没思路，没想出来。
回来后，在服务器上边测试边思考，思路感觉比较容易出来。下面是测试实现过程。  

# Shell 实现找出两个目录下的同名文件思路

```bash
# 首先我们来创建一些 2 个目录，里面的目录结构及相关文件如下所示：
[root@VM_15_187_centos ~]# tree dir1
dir1
|-- 00
|   `-- test.txt
|-- test00.txt
`-- test01.txt

1 directory, 3 files
[root@VM_15_187_centos ~]# tree dir2
dir2
|-- 01
|   `-- test.txt
|-- test00.txt
`-- test02.txt

1 directory, 3 files

# 从上面的测试目录可以看到， test.txt test00.txt 两个文件是两个目录下的同名文件

# 有实际例子，思路就容易出来：
# 1. 使用 for 循环 和 find 结合 awk 命令列出 dir1 目录下的所有文件名
# 2. 对一个文件名，再传递给 find 命令查找 dir2 目录下是否有这个文件名，如果有，就列出来

# 如下一行命令就可以实现：
[root@VM_15_187_centos ~]#  for file in `find dir1 -type f | awk -F"/" '{print $NF}'`; do find dir2 -type f -iname "$file" | awk -F"/" '{print $NF}' ; done
test.txt
test00.txt

```    
