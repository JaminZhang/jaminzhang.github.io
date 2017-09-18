---
layout: post
title: Python 基础 03-列表与 For 循环
description: "Python 基础 03-列表与 For 循环"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---

列表：一排

* [1, 2, 3]
* ["a", "b", "c"]
* [True, 1, "a"]

列表中的元素可以是相同的数据类型或不同的数据类型。

# 列表取值

a = [1, "a", 3, 6, "google"]

* a[0] -> 1
* a[1] -> "a"
* a[-1] -> "google"


给列表中的元素赋值，会改变列表元素的值，列表也会跟着改变。

## 列表分片

a[1:4] -> ["a", 3, 6]

前闭后开的区间 [1, 4)，分片不包含最后标识的列表元素。

## 列表添加删除值

a = [1, "a", 3, 6, "google"]

* insert 方法：在列表任意位置添加值 a.insert(0, "fir") 第一个参数为要添加位置的标识
* append 方法：在列表最后位置添加值 a.append("ch")
* del 方法：删除列表任意位置的值 del a[2] 参数为要删除的列表元素位置标识
* pop 方法：弹出列表中的最后一个元素

```python

>>> a = [1, "a", 3, 6, "google"]
>>> a.insert(0, True)		# 添加列表元素
>>> a
[True, 1, 'a', 3, 6, 'google']
>>> a.append("123")			# 在列表最后位置添加值
>>> a
[True, 1, 'a', 3, 6, 'google', '123']

```    


# 列表遍历

## 使用 for 循环

```python

>>> a
[True, 1, 'a', 3, 6, 'google', '123']
>>> for item in a:
...     print(item)
...     print("..")
... 
True
..
1
..
a
..
3
..
6
..
google
..
123
..
	
```    


Python 文件中 Python 代码的写法是标准的写法，
而 Python 命令行会将输入的每个语句的结果输出。
