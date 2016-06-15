---
layout: post
title: rpmbuild 构建定制 RPM 包
description: "rpmbuild 构建定制 RPM 包"
category: Linux
avatarimg:
tags: [RPM, rpmbuild]
duoshuo: true
---

# 引言
之前谈到在 CentOS 下定制 RPM 的方法，使用 rpmbuild 的方法比较复杂，但有时就需要这种方法，所以还是应该学会。  
这几天看了几天的资料，包括 Fedora 的官方文档，里面提到了各种打包规范及建议，我看得有点晕了，不知道怎么了，  
这几天想弄清楚打包 spec 文件的各个参数，但实在是太多了，实在纠结，这里先把看的相关文章记录在这里。  
这又让我想到的一个观点：好的架构不是设计出来的而是演进出来的。  
通过看官方文档，确实能够知道一个事物的方方面面，但我们又不能追求完美，非要完全看完官方文档，弄清各个参数，才开始实践使用。  
这种会耗费比较多的时间，我们要知道我们的需求，在了解掌握一些基础知识后，我们就应该着实践使用起来，当遇到问题和新的需求时，  
我们再去深入研究官方文档。要提高学习的“性价比”。首先是要把东西 Run 起来。


# Ref
[How to create an RPM package/zh-cn](https://fedoraproject.org/wiki/How_to_create_an_RPM_package/zh-cn)  
[How to create a GNU Hello RPM package/zh-cn](https://fedoraproject.org/wiki/How_to_create_a_GNU_Hello_RPM_package/zh-cn)  
[rpm打包](http://mattshma.github.io/2015/11/04/rpm%E6%89%93%E5%8C%85/)  
[Docker的价值和应用场景分析-封装部署-对比RPM+YUM](http://www.eit.name/blog/read.php?560)  


