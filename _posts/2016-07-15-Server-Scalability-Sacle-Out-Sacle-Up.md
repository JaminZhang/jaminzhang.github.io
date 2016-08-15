---
layout: post
title: 服务器扩展性 Sacle Out 和 Sacle Up
description: "服务器扩展性 Sacle Out 和 Sacle Up"
category: Architecture
avatarimg:
tags: [Scalability, Sacle Out, Sacle Up]
duoshuo: true
---

# 引言

之前说 C10K 问题时谈到过的服务器的扩展 Sacle Out/Sacle Up。  
下面来了解下它们的区别。

<pre>
Scale Out 按字面意思是超过尺寸范围，而 Scale Up 则是按比例增高。
Scale Up 靠增加处理器来提升运算能力，Scale Out 增加独立服务器来增加运算能力。

对于服务器体系来说必须要考虑的一点就是可扩展性（Scalability）。
除非业务永不增长，否则随着使用人数不断增多，服务器就一定会很快达到性能和并发极限。
解决这个问题，通常只有两个办法：即代表分布式计算的 Scale Out 和以主机或机箱式为主的 Scale Up。

Scale  Out(向外扩展)：就是指企业可以根据需求增加不同的服务器应用，依靠多部服务器协同运算，
借负载平衡及容错等功能来提高运算能力及可靠度。

Scale Up(向上扩展)：指企业后端大型服务器以增加处理器等运算资源进行升级以获得对应用性能的要求。  


更大更强的服务器同时也是更昂贵的，往往成本会大于部署大量相对便宜的服务器来实现性能的提升。
而且服务器性能所能提高的程度也有一定的上限（分布式 的部署相对来说性能提高的上限更高些）。
所以一种呼声是应该使用向外扩展（Scale Out）来实现可扩展性，同时可以让使用者得以保留通过增加服务器以提升系统能力的后路。

不言而喻，通常情况下我们需要 Scale up 扩展单个服务器的性能，来满足业务的需求，但一旦遇到服务器性能的上限，
那么就需要 Scale out 来进一步满足要求。
</pre>

另一种解释说明：  
<pre>
Scale Out（也就是Scale horizontally）横向扩展，向外扩展
Scale Up（也就是Scale vertically）纵向扩展，向上扩展
无论是Scale Out，Scale Up，Scale In，实际上就是一种架构的概念，这些概念用在存储上可以，用在数据库上，网络上一样可以。
简单比喻下Scale out和Scale up，帮助我们理解：
Scale Out，比如：我们向原有的web、邮件系统添加一个新机器。
Scale Up，比如：我们向原有的机器添加CPU、内存。
</pre>

# Ref
[服务器扩展性Scale Out和Scale up的区别](http://www.kakezu.com/tech/2010/04/14/scale-outscale-up.html)  
[Scale up or Scale out？数据中心的头号问题](http://storhome.baijia.baidu.com/article/372370)    
[什么是Scale Up和Scale Out？](http://www.chinastor.com/a/jishu/scale.html)  
[Scale OUT还是Scale UP？](http://samyu.blog.51cto.com/344284/169764)  
[Scale Out将是未来的企业架构](http://www.csdn.net/article/1970-01-01/309324)    
