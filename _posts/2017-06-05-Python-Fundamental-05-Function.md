---
layout: post
title: Python 基础 05-函数
description: "Python 基础 05-函数"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---

2017-06-04-Python-Fundamental-05-Function.md

# 函数

* 给一段语句起个名字，以方便日后反复调用。

生活举例：
计算机就像你的仆人，代码就是你对仆人的命令。  
函数是多个命令组合在一起的复杂命令。

## 一个例子

对仆人：

擦桌子  -\  
擦地    -打扫房间  
倒垃圾  -/  

对计算机：

```python

def clean_room():
    clean_table()
    clean_floor()
    clean_trash()

```    

# 形式参数

* 给函数传入一些参数。

```python

def clean_room(room_name):
    clean_table(room_name)
    clean_floor(room_name)
    clean_trash(room_name)

clean_room("主卧")
	
```    

# 位置参数

* 有多个形式参数，依据位置来赋值给参数。

```python

def clean_room(room_name, level):
    # clean code
	
clean_room("主卧", 2)

```    

# 关键字参数

* 明确给一个参数赋值。

```python

def clean_room(room_name, level):
    # clean code
	
clean_room(level = 2, room_name = "主卧")

```    

# 默认参数

* 对一个参数设置默认值。


```python

def clean_room(room_name, level = 2):
    # clean code
	
clean_room(room_name = "主卧")

```    

# 返回值

```python

def clean_room(room_name, level = 2):
    # clean code
    finished = True
    return finished
	
success = clean_room(room_name = "主卧")

```    

* return 语句结束，函数也结束  
* 如果没有 return 语句，默认返回 None

## 多返回值

* 用逗号分分隔多个返回值
* 接收时也要用多个变量来接收返回值

```python

def clean_room(room_name, level = 2):
    # clean code
    finished = False
    error_msg = "清洁剂没有了"  # error_msg, finished 是局部变量，只能函数内部使用
    return finished, error_msg
	
success, msg = clean_room(room_name = "主卧")

```    

# 文档字符串

```python

def clean_room(room_name, level = 2):
    '''这个函数用来清理房间
    '''
    # clean code  一般注释
    finished = False
    error_msg = "清洁剂没有了"
    return finished, error_msg

```    

# 可变个参数

Python 部落搜索 args

[*args 和 **kwargs 在 Python 中的作用](https://python.freelycode.com/contribution/detail/427)  
