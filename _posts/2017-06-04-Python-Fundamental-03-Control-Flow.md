---
layout: post
title: Python 基础 04-控制流
description: "Python 基础 04-控制流"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---


控制流

控制代码的执行顺序

For 循环就是一种控制流。

# if 语句

```python

if 条件一:
    语句块一
elif 条件二:
    语句块二
elif 条件三:
    语句块三
else:
    语句块四

```    

各个条件是互斥的。	
	
```python

if score > 90:
    is_best = True    # 是优等生
elif score > 80:
    is_better = True  # 良
elif score > 60:
    is_ok = True      # 及格
else:
    Failed = True     # 不及格

```    	
	
## continue 和 break 语句


```python

now = [1, 2, 3, 4, 5]
for item in now:
    if item == 2:
        continue    # 跳过后面三句    
    if item == 4:
        break       # 跳出 for 循环  
    print item
	
```    

## while 语句

```python

while 条件:
    # do something

```    

只要条件为 True 就一直执行
停止办法：

* 改变条件（while 内部），使得条件变为 False
* 使用 break 强制退出

```python

a = [1, 2, 3, 4, 5]
while len(a) > 0:
    if a[-1] == 4:
	    # continue  # 如果用 continue，则是死循环
        break
    else:
        print(a.pop())

```    

# Ref

[Python 代码可视化执行过程](https://python.freelycode.com/fcode/visualexe)  
