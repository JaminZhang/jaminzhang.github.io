---
layout: post
title: SSH中的GSSAPI相关选项
description: "SSH配置中的GSSAPI相关选项"
category: Linux
avatarimg:
tags: [Linux, SSH, TroubleShooting]
duoshuo: true
---
昨天看了一个脚本中关于配置SSH的部分，遇到GSSAPI相关配置，这是个什么鬼？没见过。。。
于是查了下，解释如下：
> GSSAPI：Generic Security Services Application Program Interface，GSSAPI本身是一套API，由IETF标准化。其最主要也是著名的实现是基于Kerberos的。一般说到GSSAPI都暗指Kerberos实现。
> GSSAPI是一套通用网络安全系统接口。该接口是对各种不同的客户端服务器安全机制的封装，以消除安全接口的不同，降低编程难度。

上面说的GSSAPI相关具体配置是什么？主要是GSSAPIAuthentication，这个默认值为yes。  
网上搜索GSSAPI的关键字，就会出现一大堆SSH登录慢的网页中有说到修改这个GSSAPIAuthentication为no，可以加快SSH登录。

为何呢？  
SSH默认开启了GSSAPIAuthentication认证，一般SSH依次进行的认证方法的是publickey,gssapi-keyex,gssapi-with-mic,password，这个你可以ssh -v开启debug模式在连接日志看到。  
一般用户只使用password认证方式，但前面3个认证过程系统还是会尝试，这就浪费时间了，也就造成SSH登录慢。  
关于gssapi相关的认证，消耗的时间比较多，具体可以查看ssh连接日志，GSSAPI1主要是基于Kerberos的，因此要解决这个问题也就变得要系统配置有Kerberos，一般用户是没有配置Kerberos的，反正我是没见过这种方式登录SSH的。。。所以那就直接把SSH服务端的GSSAPIAuthentication直接关掉吧，客户端也可以关掉。

**References:**  
[sshd_config 中文手册](http://www.jinbuguo.com/openssh/sshd_config.html)  
[ssh远程登录Linux非常慢的解决方法](http://blog.useasp.net/archive/2014/05/19/solved-the-problem-of-ssh-client-such-as-putty-remote-login-linux-very-slowly.aspx)  
[SSH登录慢的问题](http://m.oschina.net/blog/137432)
