---
layout: post
title: Shell中的比较条件测试操作符
description: "Shell中的比较条件测试操作符"
category: Shell
avatarimg:
tags: [Linux, Shell]
duoshuo: true
---

# 引言
今天一个要写一个Shell脚本，其中要判断2个字符串是否相等，当时在这里犹豫了下，应该是使用=或!=（用于字符串比较），和eq/ne（用于算术比较）搞混了，这里有必要记录下。
学习就是不断地重复，不断地加深理解。

# Shell脚本中的比较条件测试操作符
<pre>

Arithmetic Comparison	 	
-eq	Equal to	 			
-ne	Not equal to	 		
-lt	Less than	 			
-le	Less than or equal to	
-gt	Greater than	 		
-ge	Greater than or equal to

String Comparison	 
=	Equal to
==	Equal to
!=	Not equal to
\<	Less than (ASCII) *
\>	Greater than (ASCII) *
* If within a double-bracket [[ ... ]] test construct, then no escape \ is needed.
 
-z	String is empty
-n	String is not empty

Arithmetic Comparison	within double parentheses (( ... ))	 	 	 
>	Greater than	 	 	 
>=	Greater than or equal to	 	 	 
<	Less than	 	 	 
<=	Less than or equal to	 	 	 

</pre>


# Ref
[ABS Table B-2. TEST Operators: Binary Comparison](http://www.tldp.org/LDP/abs/html/refcards.html)  
[Shell 字符串比较](http://linglong2110.iteye.com/blog/1058021)    
