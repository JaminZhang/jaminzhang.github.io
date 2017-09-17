---
layout: post
title: Python 基础 02-数值计算
description: "Python 基础 02-数值计算"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---


Python 基础 02-数值计算

用 Python 做数值计算非常直观。

# 基础四则运算

* 加法：1 + 2
* 减法：9 - 7
* 乘法：23 * 45
* 除法：7 / 8
* 乘幂：2 ** 3
* 取整除：89 // 5

PS: "1 + 2" 和 "1+2" 等效，为了代码阅读美观，一般采用前一种形式。

## Python 2 和 Python 3 的差异

* 在 Python2 中: 7 / 2 == 3 , 即整数除以整数，得到的还是整数。这和 C 语言是一致的，是计算机的思维方式。
* 在 Python3 中: 7 / 2 == 3.5 , 即整数除以整数，得到的是浮点数。这和人类的思维是一致的。


# 真假判断

* 大于：1 > 2
* 小于：9 < 7
* 大于等于：23 >= 45
* 小于等于：7 <= 8
* 等于：2 == 3
* 不等于：True != False

# 逻辑运算

* not 条件：真假值反转，对应汉语中的“非”
* 条件 A and 条件 B：A,B 均为真才真，对应汉语中的“而且”
* 条件 A or 条件 B：A,B 中一个为即为真，对应汉语中的“或者”

# 运算顺序

可以通过括号改为运算顺序

# 运算表达式简写

* a = a + 1 等价于 a += 1
* a = a - 1 等价于 a -= 1


# Ref
[Python 运算符](http://www.runoob.com/python/python-operators.html)
