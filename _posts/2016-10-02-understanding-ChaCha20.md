---
layout: post
title: 了解 ChaCha20
description: "了解 ChaCha20"
category: Network
avatarimg:
tags: [ChaCha20, ShadowsSocks]
duoshuo: true
---



了解 ChaCha20

# 引言

ShadowsSocks 是一种使用 SOCKS 协议的代理服务器，在选择加密算法时，有一种新的加密算法 ChaCha20。
现在我们来了解一下这种加密算法和它的特点。

# 简介

<pre>
Salsa20 是一种流加密算法，由 Daniel J. Bernstein 提交到 eSTREAM。
它创建在基于 add-rotate-xor（ARX） 操作的伪随机函数之上——32位模加、异或（XOR）和循环移位操作。
Salsa20 映射一个 256 位密钥、一个 64 位 nonce 以及一个 64 位流位置到一个 512 位的输出（也存在一个128位密钥的版本）。
这使 Salsa20 具有了不同寻常的优势，用户可以在恒定时间内寻求输出流中的任何位置。
它可以在现代x86处理器中提供约每4–14次循环周期一字节的速度，并具有合理的硬件性能。
它没有注册专利，并且Bernstein还撰写了几篇对常见架构优化的公有领域实现。Salsa20已被提交到eSTREAM。
一个相关的密码算法 ChaCha，具有类似的特点，但有不同的循环移位函数，已在 2008 年由 Bernstein 发布。

ChaCha20
Google 选择了带有 Bernstein 的 Poly1305 消息认证码的 ChaCha20 作为一个 OpenSSL 中 RC4 的替代品，用以完成互联网的安全通信。
Google 最初实现了 https (TLS/SSL)流量在 Chrome 浏览器（Android手机版）与 Google 网站之间的通信。
不久之后，Google 在 TLS 中采用它，ChaCha20 和 Poly1305 算法也以 chacha20-poly1305@openssh.com 成为 OpenSSH 中的一个新密码包。
后来，通过编译时选项避免它依赖于 OpenSSL 也成为可能。
ChaCha20 也被用在 OpenBSD 和NetBSD 操作系统中的 arc4random 随机数生成器，替换已经脆弱的 RC4，在 DragonFly BSD 中内核的 CSPRNG 子程序中也是如此。
ChaCha20 已经在 RFC 7539 中标准化。它在 IKE 和 IPsec 中的使用已在 RFC 7634 中标准化。在 RFC7905 中，Chacha20-Poly1305 已经被加入 TLS 扩展标准。

</pre>

# ChaCha20-Poly1305 优势

Google 推出新的加密套件并在所有移动端的 Chrome 浏览器上优先使用原因：

* ChaCha20-Poly1305 避开了现有发现的所有安全漏洞和攻击；
* ChaCha20-Poly1305 针对移动端设备大量使用的ARM芯片做了优化，能够充分利用 ARM 向量指令，在移动设备上加解密速度更快、更省电；
* 更加节省带宽，Poly1305 的输出是 16 字节，而 HMAC-SHA1 是 20 字节，可以节省 16% 的 overhead 消耗。

# ShadowsSocks 使用 ChaCha20

<pre>
ShadowSocks现在主流的加密方式有两种：aes-256-cfb 和 rc4-md5 前者加密强度高（指的并不是安全性高而是更难被 GFW 检测出来）
但系统开销会更大一点，它是很多一键包默认的加密方式，
后者加密解密速度比前者快得多，但安全性不够，虽目前使用还算正常，但已经不能保证通信内容肯定不会被GFW检测出来了。

加密强度高会增加一些额外的系统开销，现在的电脑手机之类的设备性能已经很强了，增加的这个负担在日常使用中基本很难察觉。
所以如果你的 ss 只是在电脑或一些性能较强的手机平板之类设备上使用，我推荐使用 aes-256-cfb。

但如果是用在路由器上，因为很多路由器 CPU 速度都在 500MHz 以下，性能并不强，
使用 aes-256-cfb 多出来的那点性能开销在路由器上可能会构成一个影响性能的大问题，
所以，之前使用在路由器上的加密方式一般都选 rc4-md5。

因为在路由器等性能不强的设备上使用 aes 加密方式会影响性能，使用rc4-md5又加密强度不够，
所以人们创造了 Salsa20 这个加密算法，它比前辈rc加密算法速度更快而加密强度更高，
后来，Google 又在这个算法的基础上开发了 chacha20 这个更快加密更强的算法。
基本上，它现在算是性能不强的设备使用最佳的算法了。
</pre>



# Ref
[Salsa20](https://zh.wikipedia.org/wiki/Salsa20)  
[三种方法实现移动端HTTPS加速和省电](https://blog.wilddog.com/?p=749)  
[为shadowsocks开启chacha20加密](https://glorystar.me/archives/shadowsocks-chacha20.html)  
[Shadowsocks 使用的加密方式中，rc4-md5 与 aes-256-cfb 各自的优劣如何？](https://www.zhihu.com/question/28252105)
