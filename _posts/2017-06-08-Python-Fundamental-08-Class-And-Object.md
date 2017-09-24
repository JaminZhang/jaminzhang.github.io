---
layout: post
title: Python 基础 08-类和对象
description: "Python 基础 08-类和对象"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---


# 类和对象(实例)

之前我们学习了函数和模块等组织代码的方式，但随着代码的增多，函数和模块还是不够用。  
根据有项研究，如果代码超过 10000 行，如果只用函数和模块来组织代码，那么程序员将很难掌控代码。
所以在大型项目中，为了更好地组织代码，会使用类和对象。

类和对象之间的关系非常相似于概念和实体的关系。  

![Python-Class-Object](http://jaminzhang.github.io/images/Python/Python-Class-Object.png)  


# 创建类

```python

class Cat(object):                      # 定义概念 猫：       PS: 注意使用 class 关键词，Python 3 中不需要"(object)"
    leg_cnt = 4                         # 腿数 = 4        PS: 可以做为类属性
    def __init__(self, cat_name):       # 定义 创建过程（实体，猫名）：   PS: 实例的创建过程，类的实例化，第一个参数 self 是必须的，  
                                        # self 可以理解为类实例化时的已经存在的初始实体对象，很多属性还没有被设置
        self.name = cat_name            # 实体.名字 = 猫名  PS: 给实体设置 name 属性，同时将传入的参数 cat_name 赋值给它
                                        # name 这个变量是附属于 self 实例的（self.name），不能够直接使用 name 变量
    
    def change_name(self, cat_name):    # 定义 改名字（实体，猫名）:  PS: 类里面的函数就叫类的方法，第一个参数是 self，类的方法实际上定义类这个概念能做什么
        self.name = cat_name            # 实体.名字 = 猫名
    
    def climb(self):                    # 定义 爬树(实体):
        print("cat %s climb a tree" %   # 输出 （猫爬了树）
        self.name)

```    
        
# 创建并使用实例

```python

tom = Cat("Tom")                # 类的实例化，Cat 实例化后赋值给 tom 这个变量，tom 是一只真正的猫，它的名字叫"Tom"
tom.chang_name("ATom")          # tom 改名字为 "ATom"
tom.climb()                     # tom 去爬树
tom.leg_cnt == 4                # True tom 的腿数是 4

```    

# 类的继承

继承的类叫做子类。

```python

class PersianCat(Cat):              # 定义概念 波斯猫（继承猫）：
    def __init(self, cat_name):     # 定义 创建过程（实体，猫名）：
        super(PersianCat, self).__init__(cat_name)  # 执行猫的创建过程（猫名），Python 3 中"PersianCat, self"可不写
    
    def jump(self):                 # 定义 跳(实体)：
        print("try jump")           # 打印 ("try jump")

jack = PersianCat("jack")           # jack 是一只真实的波斯猫
jack.jump()                         # jack 跳    
jack.climb()                        # jack 爬树
        
```    

# Ref
[Python 面向对象](http://www.runoob.com/python/python-object.html)  
[Python 笔记——类定义](http://blog.csdn.net/wklken/article/details/6313265)     
