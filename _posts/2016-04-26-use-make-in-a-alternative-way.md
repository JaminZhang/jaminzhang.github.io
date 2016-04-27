---
layout: post
title: make的另类使用
description: "make的另类使用"
category: Linux
avatarimg:
tags: [make]
duoshuo: true
---

# 引言
看了《时间管理-给系统管理员》中关于make的使用，眼前一亮，原来make还可以这么用！  
一提到make，我想对于大多数运维或者开发来说，不应该就是编译软件的程序吗？  
下面我们来看看make的另类用法。

# make简介
make让你设置各种牵涉到需要执行命令以更新文件（如果有变化）的关系。
这在man中提到：
> 
In fact, make is not limited to programs.  You can use it to describe any task where some files must  be  updated
automatically from others whenever the others change.

make会读取名为Makefile的配置文件。在此文件中，你将找到一些规则，而这些规则会指示make如何做事。
每份规则看起来就像这样：

``` bash
whole: partA partB partC
    command that create whole
```    

这份规则的开头是要创建的文件，然后是冒号，接着是列出构建主文件所需的其他文件。此例中，规则是关于whole以及替whole和partA/partB/partC
建立起关系。如果partA/partB/partC被更新，我们就必须（重新）执行产生whole的命令。

# 例子1
下面是一个实例：

``` bash
whole.txt: partA.txt partB.txt
	cat partA.txt partB.txt > whole.txt	
	@echo Done updating whole.txt 
```    

这段代码是说如果partA.txt或partB.txt有了改变，就使用cat命令重新产生whole.txt。然后，此规则会输出“Done updating whole.txt”以公告其成功。


# 例子2
``` bash
foo.o: foo.c defs.h # foo 模块
	cc -c -g foo.c
```    

<pre>
看到这个例子，各位应该不是很陌生了，前面也已说过，foo.o 是我们的目标，foo.c 和
defs.h 是目标所依赖的源文件，而只有一个命令cc -c -g foo.c（以Tab 键开头）。

这个规则告诉我们两件事：
1. 文件的依赖关系，foo.o 依赖于foo.c 和defs.h 的文件，如果foo.c 和defs.h 的
文件日期要比foo.o 文件日期要新，或是foo.o 不存在，那么依赖关系发生。
2. 生成或更新foo.o 文件，就是那个cc 命令。它说明了如何生成foo.o 这个文件。
（当然，foo.c 文件include 了defs.h 文件）
</pre>

# Ref
[《时间管理：给系统管理员》 第十三章 自动化 make简介 P183] (http://item.jd.com/10042434.html)  
[跟我一起写Makefile (PDF重制版)](http://seisman.info/how-to-write-makefile.html)  


