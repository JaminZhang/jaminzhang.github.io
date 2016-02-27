---
layout: post
title: 使用sed将一个文件的内容到追加到另一个文件的首部
description: "使用sed将一个文件的内容到追加到另一个文件的首部"
category: Linux
avatarimg:
tags: [sed]
duoshuo: true
---

# 引言
今天运营反映后台无数据，经过问题分析及定位，最终判断是服务器IP没有加到后台日志服务器的IP白名单，新开的几台服务器是新网段。。。

# 使用sed追加文件内容到文件首部
服务器上的日志数据是通过syslog传送到远端syslog server，只会传递当天的数据，所以需要把昨天的数据文件的内容追加到今天的数据文件中。  
但今天的这个数据日志文件是一直实时变化的，文件结尾一直会有新的日志记录追加，而且这个文件已经有数万行记录了。  
所以用cat yesterday.log today.log > today.log.new 这种方式不可行。  
于是想到使用sed来实现，查找好久的sed用法，还是不能完美地实现将昨天的日志文件内容追加到今天的日志文件的首部。  
只能将昨天的日志文件内容追加到今天的日志文件的首部，从第1行后开始，而不是完全从第1行开始。

<pre>
sed -i '1r ./yesterday.log' today.log    #表示将yesterday.log文件中的内容添加到today文件中，且从第一行往后开始添加
</pre>


# Ref
man sed  
[三大文本处理工具grep、sed及awk的简单介绍](http://lq2419.blog.51cto.com/1365130/1238880)  
