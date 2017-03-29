---
layout: post
title: SSH 中的 GSSAPI 相关选项
description: "SSH 配置中的 GSSAPI 相关选项"
category: Linux
avatarimg:
tags: [Linux, SSH, GSSAPI, Kerberos, TroubleShooting]
duoshuo: true
---

# 引言

昨天看了一个脚本中关于配置 SSH 的部分，遇到 GSSAPI 相关配置，这个之前没怎么见过。
于是查了下，解释如下：

<pre>

GSSAPI：Generic Security Services Application Program Interface，GSSAPI 本身是一套 API，由 IETF 标准化。
其最主要也是著名的实现是基于 Kerberos 的。一般说到 GSSAPI 都暗指 Kerberos 实现。
GSSAPI 是一套通用网络安全系统接口。该接口是对各种不同的客户端服务器安全机制的封装，以消除安全接口的不同，降低编程难度。

</pre>

上面说的 GSSAPI 相关具体配置是什么？主要是 GSSAPIAuthentication，这个默认值为 yes。  
网上搜索 GSSAPI 的关键字，就会出现一大堆 SSH 登录慢的网页中有说到修改这个 GSSAPIAuthentication 为 no，可以加快 SSH 登录。

为何呢？   
SSH 默认开启了 GSSAPIAuthentication 认证，  
一般 SSH 依次进行的认证方法的是 publickey, gssapi-keyex, gssapi-with-mic, password，
这个你可以`ssh -v`开启 debug 模式在连接日志看到。    
一般用户只使用 password 认证方式，但前面 3 个认证过程系统还是会尝试，这就浪费时间了，也就造成 SSH 登录慢。  
关于 GSSAPI 相关的认证，消耗的时间比较多，具体可以查看 SSH 连接日志。  
GSSAPI 主要是基于 Kerberos 的，因此要解决这个问题也就变成要系统配置有 Kerberos，
一般用户是没有配置 Kerberos的，反正我是没见过这种方式 SSH 登录的。
所以那就直接把 SSH 服务端的 GSSAPIAuthentication 直接关掉吧，客户端也可以关掉。

# Ref  
[sshd_config 中文手册](http://www.jinbuguo.com/openssh/sshd_config.html)  
[SSH 远程登录 Linux 非常慢的解决方法](http://blog.useasp.net/archive/2014/05/19/solved-the-problem-of-ssh-client-such-as-putty-remote-login-linux-very-slowly.aspx)   
[SSH 登录慢的问题](http://m.oschina.net/blog/137432)
