---
layout: post
title: awk 命令用法总结
description: "awk 命令用法总结"
category: Linux
avatarimg:
tags: [Linux, bc, awk]
duoshuo: true
---

# 实例 1

保留圆周率小数点前 4 位 

```bash

[root@VM_15_187_centos ~]# echo "scale=10; a(1)*4" | bc -l | awk '{printf ("%.4f\n", $1)}'
3.1416

```    


# Ref
[使用 awk 进行数字计算，保留指定位小数](http://radish.blog.51cto.com/5944322/1736900)  
[利用 AWK 的数值计算功能提升工作效率](https://www.ibm.com/developerworks/cn/linux/l-cn-awkinwork/)  
[我使用过的 Linux 命令之 bc - 浮点计算器、进制转换](http://codingstandards.iteye.com/blog/793734)  
[bc 命令](https://www.ibm.com/support/knowledgecenter/zh/ssw_aix_72/com.ibm.aix.cmds1/bc.htm)  
[echo "scale=100; a(1)*4" | bc -l 输出圆周率](http://www.bbsmax.com/A/Gkz1RDArJR/)  
