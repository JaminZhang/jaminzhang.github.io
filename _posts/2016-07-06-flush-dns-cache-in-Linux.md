---
layout: post
title: Linux 下清除 DNS 缓存
description: "Linux 下清除 DNS 缓存"
category: Linux
avatarimg:
tags: [Linux, DNS, Cache, Resolver]
duoshuo: true
---

# 引言
我们都知道在 Windows 下面可以运行 `ipconfig /flushdns` 来清除 DNS 缓存。  
那么在 Linux 下如何清除缓存呢？这个问题遇到好几次了都没确认，今天就来确认下。

# Linux 下清除 DNS 缓存

这里我明确下，Linux 系统并不是 DNS 服务器，上面也没有任何额外的 DNS 缓存软件（nscd/dnsmasq等）。  
所以并不是清除上面软件里面的 DNS 缓存。[这篇文章说的就是上面软件的 DNS 缓存清除方法](https://linux.cn/article-3341-1.html)。

其实我的问题应该是这样的：如何清除 Linux 系统层级的 DNS 缓存？  
查找了资料，结论是：Linux 并没有系统层级的 DNS 缓存！！！（我之前一直认为和 Windows 系统那样存在，难怪之前好几次没找到清除的方法）

以下来自 stackoverflow 的解答：

<pre>
On Linux (and probably most Unix), there is no OS-level DNS caching unless nscd is installed and running.
Even then, the DNS caching feature of nscd is disabled by default at least in Debian because it's broken.
The practical upshot is that your linux system very very probably does not do any OS-level DNS caching.

You can look around in the resolv subdirectory of the glibc source code, it's all there. 
That's not a specific answer, I realize, but it comes down to the fact that there's no code in there 
that implements a cache and in any case you can see if you trace it that it makes no use of any file or shared memory segment 
or other kind of location where this cache could potentially be stored.
</pre>

上面说了，如果你要亲自确认 Linux 是否有 OS-level 的 DNS Cache，那就去看 resolv 的源码。

另外，这篇文章 [Resolver Cache – Linux vs Windows](https://www.itdojo.com/resolver-cache-linux-vs-windows/)  通过实际抓包来演示了 Windows 和 Linux 系统间 OS-level 和 Application-level 的 DNS Cache 的特点。


# Ref
[如何在 Linux/Unix/Mac 下清除 DNS 查询缓存](https://linux.cn/article-3341-1.html)  
[DNS caching in linux](http://stackoverflow.com/questions/11020027/dns-caching-in-linux?newreg=e1a332c78aa043658b2eb74dd92044e5)  
[Resolver Cache – Linux vs Windows](https://www.itdojo.com/resolver-cache-linux-vs-windows/)  
