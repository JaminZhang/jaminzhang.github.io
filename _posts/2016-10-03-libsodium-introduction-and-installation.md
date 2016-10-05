---
layout: post
title: libsodium 简介及安装
description: "libsodium 简介及安装"
category: Programming
avatarimg:
tags: [Library, libsodium]
duoshuo: true
---

# 引言
前文谈到要将 ShadowSocks 服务器的加密算法改成 ChaCha20，  
我在一台 CentOS 6.7 x86_64 系统下修改加密算法为 ChaCha20，启动时报错，提示 libsodium 没有安装，于是通过 yum 安装后，版本是 `0.4.5-3`，还是不行；  
需要安装比较新的版本，安装 `1.0.11` 的版本后可以正常启动运行。

# libsodium 简介

<pre>
The Sodium crypto library (libsodium)

Sodium is a new, easy-to-use software library for encryption, decryption, signatures, password hashing and more.
It is a portable, cross-compilable, installable, packageable fork of NaCl, with a compatible API, 
and an extended API to improve usability even further.

Its goal is to provide all of the core operations needed to build higher-level cryptographic tools.

Sodium supports a variety of compilers and operating systems, including Windows 
(with MingW or Visual Studio, x86 and x64), iOS and Android.

</pre>
Sodium 加密库

Sodium 是一个全新而且易用的加密库，用于加密、解密、签名和生成密码哈希等等。
它是一个可移植的、跨编译器支持、可安装的，基于 NaCI 开发，提供了一个兼容 API 和一个提高更高可用性的扩展 API。
它的目标是提供构建一个更高级的加密工具所需要的所有核心操作。
Sodium 支持各种各样的编译器和操作系统，包括 Windows( 如 MingW 或者 Visual Studio, x86 和 x64)，iOS 和 Android。

# libsodium 安装

```bash
wget -N --no-check-certificate https://download.libsodium.org/libsodium/releases/libsodium-1.0.11.tar.gz
tar xvf libsodium-1.0.11.tar.gz
cd libsodium-1.0.11
./configure
make && make check
make install
```    

# Ref
[The Sodium crypto library (libsodium)](https://download.libsodium.org/doc/)  
[Installation](https://download.libsodium.org/doc/installation/)  
[加密库 libsodium](https://www.oschina.net/p/libsodium)  
[为shadowsocks开启chacha20加密](https://glorystar.me/archives/shadowsocks-chacha20.html)  

