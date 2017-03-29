---
layout: post
title: grep -o 选项实例分析
description: "grep -o 选项实例分析"
category: Linux
avatarimg:
tags: [Linux, grep]
duoshuo: true
---

# 引言

有一个脚本最近几天失效了，查了下，是里面用到了`grep -o`选项提取出数字的相关命令，应该 bash 和 grep 升级了版本引起的。

# `grep -o`不同 bash/grep 版本下的输出对比

## 新版本 bash/grep 下的输出

```bash

[root@iZ25p102vo3Z ~]# rpm -qa bash grep
bash-4.2.45-5.el7_0.4.x86_64
grep-2.20-2.el7.x86_64
[root@iZ25p102vo3Z ~]# echo 1536467 | grep -o [0-9]* # 输出为空
[root@iZ25p102vo3Z ~]# 

```    

## 旧版本 bash/grep 下的输出

```bash

[root@tracker-seeder ~]# rpm -qa bash grep
grep-2.6.3-4.el6.x86_64
bash-4.1.2-33.el6_7.1.x86_64
[root@tracker-seeder ~]# echo 1536467 | grep -o [0-9]* # 可以正常输出想要提取的数字
1536467

```    

# 原因分析

从上面 2 个例子可以看出，新版本 bash/grep 下， `grep -o [0-9]*` 失效了。
 
新版本下，单独执行`grep -o [0-9]*`时，输出为空
旧版本下，单独执行`grep -o [0-9]*`时，命令不能执行，回车后回行，还处在接收标准输入状态。

我们分析下新版本下可以执行`grep -o  [0-9]*`
`[0-9]*`是作为 -o 的参数还是文件？

```bash

[root@iZ25p102vo3Z ~]# ll [0-9]*      # [0-9] 和“*”都为 bash 中的通配符 匹配所有以数字开头的文件
-rw-r--r-- 1 root root 0 May  3 15:56 123
-rw-r--r-- 1 root root 0 May  3 15:57 456
[root@iZ25p102vo3Z ~]# grep -o [0-9]* # 此处 [0-9]* 匹配了上面的 123、456 两个文件，相当于 -o 的参数和最后的文件，所以可以执行
[root@iZ25p102vo3Z ~]# rm -f 456
[root@iZ25p102vo3Z ~]# grep -o [0-9]* # 此处 [0-9]* 匹配了上面的 123 文件，应该只匹配了 -o 的参数，缺少最后的文件参数，所以不可以执行


^C
[root@iZ25p102vo3Z ~]# rm -f 123
[root@iZ25p102vo3Z ~]# grep -o [0-9]* # 此处 [0-9]* 匹配为空，-o 的参数和最后的文件参数都缺少，所以不可以执行


^C
```    

所以说是 Shell 通配符引起的，会将`[0-9]*`解析成 0 到多个给 grep 的参数，为了避免上面出现的情况，  
解决方法是：使用 grep 时，PATTERN 最好使用双引号或单引号引起来。

# Ref
[bash 通配符](https://abcfy2.gitbooks.io/linux_basic/content/first_sense_for_linux/command_learning/wildcard.html)  
