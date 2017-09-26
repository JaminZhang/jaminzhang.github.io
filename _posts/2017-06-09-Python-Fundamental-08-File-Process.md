---
layout: post
title: Python 基础 09-文件处理
description: "Python 基础 09-文件处理"
category: Python
avatarimg:
tags: [Python]
duoshuo: true
---


# 写入文件

```python

poem = '''\
Programming is fun,
When the work is done.
If you wanna make your work also fun:
    Use Python!
'''

f = open('poem.txt', 'w')           # 打开文件的方式：r/w/a，open 方法返回值是一个文件描述符，赋值给 f
                                    # 文件描述符可以理解成一个表示文件的对象
f.write(poem)                       # write text to file
f.close()                           # close the file，打开文件后一定要关闭，如果不关闭，会占用系统的文件描述符资源

```    

# 读取文件

```python

f = open('poem.txt')                # 默认为 r 模式
while True:
    line = f.readline()
    if len(line) == 0:              # 空行表示读取结束
        break
    print(line, end = "")           # print 内容后面默认会增加一个 \n，这里 end 禁止结尾增加 \n，改为增加 ""
f.close()                           # close the file

```    


# 使用 with 语句后 Python 自动关闭文件

使用 with 语句后，不用使用 close 方法关闭文件了。

```python

poem = '''\
Programming is fun,
When the work is done.
If you wanna make your work also fun:
    Use Python!
'''

# 写入文件

with open('poem.txt', 'w') as f:
    f.write(poem)
    
    
# 读取文件

with open('poem.txt') as f:
    while True:
        line = f.readline()
        if len(line) == 0:      
            break
        print(line, end = "")

```    


