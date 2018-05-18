---
layout: post
title: MacBook Pro 2017 不支持 32GB 内存的原因
description: "MacBook Pro 2017 不支持 32GB 内存的原因"
category: Mac
avatarimg:
tags: [Mac, MacBook Pro, DRAM, LPDDR3, LPDDR4]
duoshuo: true
---

# 引言
我现在的笔记本电脑已经用了好几年的时间了，需要更新换代了。  
首选是最新款 MacBook Pro 15"，但有一个原因阻碍了马上购买，就是它不支持 32GB 内存。
自认为 Pro 用户的我，还是想等待 32GB 内存版本。  
那为什么它不支持 32GB 内存呢？网上有很多文章分析了，深入分析可以得出好些原因，我附在 Ref 中。  
我把最可能的本质原因简要总结一下，如下。

# 原因

## 1.用于笔记本电脑的 LPDDR3 单颗容量现在最大只有 32Gb(4GB)
## 2. Intel Core 系列 CPU 现在还不支持 LPDDR4 内存

MacBook Pro 2017 上配置板载内存是 4 颗 32Gb(4GB) 的 LPDDR3 内存芯片，
现在 LPDDR3 单颗容量最大为 48Gb(8GB)，三星家出的，但它是用于智能手机的，不能用于笔记本电脑，  
现在能用于笔记本电脑的 LPDDR3 单颗容量最大只有 32Gb(4GB)，4 颗上限就是 16GB。
要实现 32GB，只能采用 8 颗粒的方案，可以在背面多放 4 颗 DRAM，这需要更改现有的 PCB 布局，但苹果并没有这么做。
另外，如果使用 LPDDR4 内存呢，现在能量产的 LPDDR4 内存可以达到单颗粒 64Gb(封装方式支持问题暂不考虑)，
但 Intel Kaby Lake CPU 并不支持 LPDDR4 内存。  

## 个人期望

苹果现在把 MacBook Pro 重点放在轻薄上，更改笔记本内部布局，增加更多 DRAM 的可能性并不大。  
用于笔记本电脑的 LPDDR3 单颗容量现在最大只有 32Gb(4GB)，增加到 64Gb 的可能性也不大。  
所以现在大概只能期望更换 LPDDR4 内存才能达到 32GB 内存目标，进一步，这个只能期望 Intel 的 CPU 能够支持 LPDDR4 内存。  
关于 Intel CPU 什么时候能支持 LPDDR4 内存又是一个不可预期的问题（估计从下一个 10nm Cannon Lake 系列开始，Intel 给出的时间是在 2017 年底）。  

**总结：** MacBook Pro 什么时候能支持 32GB 内存很大程度上依赖 Intel CPU 什么时候能支持 LPDDR4 内存。  
所以这段时间也一直在关注 Intel CPU 的一些新闻。


# Ref
[如何看待苹果 2017 款 MacBook Pro 仍然使用 LPDDR3 内存？](https://www.zhihu.com/question/60794758)  
[Samsung Mobile DRAM](http://www.samsung.com/semiconductor/products/dram/mobile-dram/)  
[Hynix DRAM](https://www.skhynix.com/products.do?ct1=36&ct2=41&lang=eng)  
[Micron DRAM](https://www.micron.com/products/dram)    
