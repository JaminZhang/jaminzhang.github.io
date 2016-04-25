---
layout: post
title: JSON学习
description: "JSON学习"
category: Programming
avatarimg:
tags: [JSON, XML]
duoshuo: true
---

# 引言
之前写了一篇获取外网IP的文章，当中提到了使用各大厂商提供的API接口来获取外网IP。
通常接口返回的数据格式是JSON。那么什么是JSON？为什么要用JSON呢？

# 什么是JSON
> 
JSON(JavaScript Object Notation) 是一种轻量级的数据交换格式。 易于人阅读和编写。同时也易于机器解析和生成。 它基于JavaScript Programming Language, Standard ECMA-262 3rd Edition - December 1999的一个子集。 JSON采用完全独立于语言的文本格式，但是也使用了类似于C语言家族的习惯（包括C, C++, C#, Java, JavaScript, Perl, Python等）。 这些特性使JSON成为理想的数据交换语言。

<pre>
JSON stands for JavaScript Object Notation
JSON is a lightweight data-interchange format
JSON is language independent *
JSON is "self-describing" and easy to understand
</pre>

# JSON与XML的比较
## 相同点
<pre>
 Much Like XML Because
Both JSON and XML is "self describing" (human readable)
Both JSON and XML is hierarchical (values within values)
Both JSON and XML can be parsed and used by lots of programming languages
Both JSON and XML can be fetched with an XMLHttpRequest
</pre>

## 不同点
<pre>
Much Unlike XML Because
JSON doesn't use end tag
JSON is shorter
JSON is quicker to read and write
JSON can use arrays
The biggest difference is:

 XML has to be parsed with an XML parser, JSON can be parsed by a standard JavaScript function.
</pre>

# 为什么使用JSON
<pre>

A common use of JSON is to read data from a web server, and display the data in a web page.

For AJAX applications, JSON is faster and easier than XML:

Using XML

Fetch an XML document
Use the XML DOM to loop through the document
Extract values and store in variables


Using JSON

Fetch a JSON string
JSON.Parse the JSON string

</pre>

# Ref
[介绍 JSON](http://www.json.org/json-zh.html)  
[JSON Tutorial](http://www.w3schools.com/json/)  
[使用Bash Shell处理JSON文件](https://wsgzao.github.io/post/bash-json/)  


