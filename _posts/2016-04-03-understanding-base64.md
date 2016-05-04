---
layout: post
title: 理解Base64编码原理
description: "理解Base64编码原理"
category: HTTP
avatarimg:
tags: [Base64]
duoshuo: true
---

# 引言
经常看到提到Base64编码的文章或资料，都没怎么去看具体是怎么个编码算法。
这两天看《HTTP权威指南》，讲到HTTP的基本认证是用的Base64编码，于是就把Base64编码原理看了下，还是比较简单的。


# 1.Base-64编码保证了二进制数据的安全
>
Base-64 编码可以将任意一组字节转换成较长的常见文本字符序列，从而可以合法
地作为首部字段值。Base-64 编码将用户输入或二进制数据，打包成一种安全格式，
将其作为HTTP 首部字段的值发送出去，而无须担心其中包含会破坏HTTP 分析程
序的冒号、换行符或二进制值。

>
Base-64 编码是作为MIME 多媒体电子邮件标准的一部分开发的，这样MIME 就可
以在不同的合法电子邮件网关之间传输富文本和任意的二进制数据了。1Base-64 编
码与将二进制数据文本化表示的uuencode 和BinHex 标准在本质上很类似，但空间
效率更高。MIME RFC 2045 的第6.8 节详细介绍了Base-64 算法。

# 2.8位到6位
>
Base-64 编码将一个8 位字节序列拆散为6 位的片段，并为每个6 位的片段分配一
个字符，这个字符是Base-64 字母表中的64 个字符之一。这64 个输出字符都是很
常见的，可以安全地放在HTTP 首部字段中。这64 个字符中包含大小写字母、数
字、+ 和/，还使用了特殊字符=。表E-1 显示了Base-64 的字母表。
注意，由于Base-64 编码用了8 位字符来表示信息中的6 个位，所以Base-64 编码
字符串大约比原始值扩大了33%。

![Base64字母表](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Base64-table.png)

>
图E-1 是一个简单的Base-64 编码实例。在这里，三个字符组成的输入值“Ow!”是Base-64 编码的，  
得到的是4 个字符的Base-64 编码值“T3ch”。它是按以下方式工作的。  
（1）字符串“Ow!”被拆分成3 个8 位的字节（0x4F、0x77、0x21）。  
（2）这3 个字节构成了一个24 位的二进制值010011110111011100100001。  
（3）这些位被划分为一些6 位的序列010011、110111、01110、100001。  
（4） 每个6 位值都表示了从0 ～ 63 之间的一个数字，对应Base-64 字母表中64 个字符之一。  
得到的Base-64 编码字符串是个4 字符的字符串“T3ch”，然后就可以通过线路将这个字符串作为“安全的”8 位字符传送出去，因为只用了一些
移植性最好的字符（字母、数字等）。  

![Base64编码实例](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Base64-example.png)

# 3.Base-64填充
>
Base-64 编码收到一个8 位字节序列，将这个二进制序列流划分成6 位的块。二进
制序列有时不能正好平均地分成6 位的块，在这种情况下，就在序列末尾填充零位，
使二进制序列的长度成为24 的倍数（6 和8 的最小公倍数）。  

>
对已填充的二进制串进行编码时，任何完全填充（不包含原始数据中的位）的6 位
组都由特殊的第65 个符号“=”表示。如果6 位组是部分填充的，就将填充位设置
为0。

>
表E-2 显示了一些填充实例。初始输入字符串“a:a”为3 字节（24 位）。24 是6 和
8 的倍数，因此无需填充，得到的Base-64 编码字符串为“YTph”。

![Base64填充实例](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/Base64-fill-example.png)

>
然而，再增加一个字符，输入字符串会变成32 位长。而6 和8 的下一个公倍数是
48，因此要添加16 位的填充码。填充的前4 位是与数据位混合在一起的。得到的
6 位组01xxxx，会被当作010000、十进制中的16，或者Base-64 编码的Q 来处理。
剩下的两个6 位组都是填充码，用“=”表示。

# Ref
《HTTP权威指南》 附录E Base-64编码  
[Base64笔记](http://www.ruanyifeng.com/blog/2008/06/base64.html)  
[Base64编码/解码器 在线解码](http://www1.tc711.com/tool/BASE64.htm)  
[ASCII Wikipedia](https://en.wikipedia.org/wiki/ASCII)  

