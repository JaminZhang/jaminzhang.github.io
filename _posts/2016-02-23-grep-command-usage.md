---
layout: post
title: grep 命令用法总结
description: "grep 命令用法总结"
category: Linux
avatarimg:
tags: [bash, grep, sed]
duoshuo: true
---

# 实例 1

删除某目录下所有文件含有 test 字符串的行

> 
grep -r -l "test"  * | xargs sed -i "/test/d"

上面使用 grep 递归搜索包含 test 字符串的文件名，然后传递给 sed 做删除操作
