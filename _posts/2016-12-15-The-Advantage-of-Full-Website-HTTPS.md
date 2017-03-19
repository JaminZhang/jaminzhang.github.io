---
layout: post
title: 全站 HTTPS 好处
description: "全站 HTTPS 好处"
category: HTTP
avatarimg:
tags: [Web, Website, HTTPS]
duoshuo: true
---

全站 HTTPS 好处

# 引言

全站 HTTPS 是近 2 年的热门话题，这几天有个面试问我使用全站 HTTPS 有哪些好处？  
由于近 2 年负责的业务主要不是 Web 业务，所以当时只回答一个笼统的答案，加强安全，然后防止流量劫持。  
恩，说明对 HTTPS 没有深入全面地了解，所以就查了相关资料，学习了下 HTTPS 相关内容。

# 为什么要使用全站 HTTPS

1. 数据的保密性（使用加密算法对通信数据进行加密，保护用户数据，不让他人知道通信数据）
2. 数据的完整性（传统的 HTTP 协议数据包很容易被篡改，比如在国内最常见的运营商恶意流量劫持，插入广告等，
使用 HTTPS 可以校验数据包的完整性，被篡改的数据包会拒收）
3. 身份验证 （HTTPS 可以确保数据包被正确的送到指定的接收方，而不是第三方）

关于 HTTPS 的原理及实践的深入可以参考 Ref 中的资料和相关书籍。


# Ref
[全站 https 时代的号角 : 大型网站的 https 实践系列](http://op.baidu.com/2015/04/https-index/)  
[全站 HTTPS 来了](https://segmentfault.com/a/1190000004199917)  
[淘宝全站 HTTPS 实践](http://velocity.oreilly.com.cn/2015/index.php?func=session&id=8)  
[为什么要全站 HTTPS](http://mp.weixin.qq.com/s?__biz=MjM5ODQ2MDIyMA==&mid=2650712733&idx=1&sn=681e7413eeff0d6189df9c0ef6190e46&chksm=bec064ce89b7edd8427d3eb9d578c314bc209603a5c3e9c0657d6908fc1baae91a9c7c64d9a9&mpshare=1&scene=23&srcid=1108FWOXmSN3tkJlm3K8JLLl#rd)  
[HTTPS 全站加密可能是大势所趋](http://mp.weixin.qq.com/s?__biz=MjM5ODIyMTE0MA==&mid=2650968831&idx=1&sn=a8eebffac714a8042dfa4859353e7357&chksm=bd3836c48a4fbfd2d2537a1fe1b37f370a798daa7da6c3925d938e0de1876bd9ef25b5e2ff5e&mpshare=1&scene=23&srcid=1215z8rrxXjLivB6IpLpxFWE#rd)  
[互联网全站 HTTPS 的时代已经到来](http://get.ftqq.com/1607.get)  
[全站 HTTPS，没那么简单](http://mp.weixin.qq.com/s?__biz=MzA3MDMwOTcwMg==&mid=2650004647&idx=1&sn=f7c6645a7e9f91a4dc834820f0bcaeff&chksm=8739be8eb04e3798b4189e6200ac7bd722bcbc6ca91d440b07b3963c3d11998e62d0d3bdbc55&scene=0#wechat_redirect)  
[启用全站 HTTPS 后不仅更安全而且更快 看淘宝是如何做到的](http://www.imooc.com/article/5217)  
