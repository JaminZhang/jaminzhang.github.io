---
layout: post
title: Python 基础 10-异常处理
description: "Python 基础 10-异常处理"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---

# 异常处理

1. 编写错误的代码会导致异常
2. 为了让我们了解发生了什么，Python 会抛出一个异常对象。
3. 异常对象也有类型，它的类型也有父类型，最终继承于基类 Exception。

![Python-Exception-Class](http://jaminzhang.github.io/images/Python/Python-Exception-Class.png)  

# try except else 语句

```python

try:
    一段可能出错的代码             # 一般容易出错的场景：网络请求、读写写入、处理与外部系统的交互
except ValueError as e:           # 把 ValueError 类型的异常对象赋值给变量 e
    print(e)                      # 处理这个异常，当使用 print 打印 e 这个异常对象时，e 这个变量变成字符串，包含描述信息
except Exception:
    处理其余所有的异常
else:
    没有异常时的处理代码

```    

except 捕获异常的语句可以有任意多个，同 else 语句一起是互斥的。


# try finally 语句

```python

try:
    一段可能出错的代码
finally:
    最后一定会执行的代码，         # 无论前面代码是否出错，最后一定会执行的代码，
    例如 f.close()                # 常用场景是关闭网络、关闭文件等
    

```    

# 抛出异常 rasie 语句

`rasie e`

捕获到异常时，如果不想处理，想让更外层代码知道（因为代码是通过函数一层层调用的），
可以使用 rasie 语句来抛出异常到外层。

```python

try:
    int("a")
except ValueError as e:
    print(e)
    raise(e)

```    
