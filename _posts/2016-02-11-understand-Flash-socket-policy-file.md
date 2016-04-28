---
layout: post
title:  了解Flash Socket策略文件
description: "了解Flash Socket策略文件"
category: Network
avatarimg:
tags: [TCP,Socket,Flash]
duoshuo: true
---

# 引言
接触到好几个游戏业务的服务器进程，都需要一个监听843端口的Flash相关进程。  
为什么需要呢？我花了时间查了下。

# 为什么需要socket策略文件？
> 
Why are socket policy files necessary?
Flash Player content is distributed throughout the web and is hosted by direct content providers and advertisers. 
It is widely used because it contains many features, providing a richer experience than raw HTML.
One of these features is the ability to create TCP sockets in order to exchange data with servers. 
From a network administrator's point of view, the idea that content from the Internet could make socket connections to 
internal hosts is scary. This is why Flash Player requires permission from the target host 
before it will allow content to make the network connection.


Flash内容的分发是通过web来的，并且它们被直接内容提供商和广告商托管。Flash被广泛应用，因为它包含许多特性，提供一种比原始HTML更丰富的
体验。这些特性中的其中一个就是有能力创建sockets以便于和服务器交换数据。从一个网络管理员的观点，来自互联网的内容可以创建socket连接到内部主机这个做法是可怕的。这就是为什么Flash Player需要来自目标主机的许可在它允许内容去创建网络连接之前。

>
Flash发起socket连接远程服务端时，首先会到对应服务端的843端口请求一个安全策略文件。否则Falsh无法建立与服务端的连接

# socket策略文件的改变
> 
Recent changes in socket policy files
Flash Player has required the presence of socket policy files since the introduction of the feature within Flash Player. 
Flash Player 9,0,124,0 introduces two major changes to socket policy files. 
The first change is that Flash Player will require socket policy files for all sockets. In prior versions of Flash Player, 
it was possible to connect to ports greater than 1024 if the SWF file was connecting to the same server from which it was hosted. 
The second change is the introduction of a centralized location for socket policy files that can host a socket master policy file.

> 
Adobe has filed with IANA, the Internet Assigned Numbers Authority, to reserve port 843 for the purposes of serving socket policy files. By introducing a centralized location for socket policy files, Flash Player enables a system administrator to define what ports are available through one master policy that overrides any other policy file on the host. 
If Flash Player 9,0,124,0 cannot retrieve a master policy file from port 843, then it requests a socket policy file on the port where it is trying to connect. However, if a policy file is available from a service on TCP port 843, then Flash Player considers that to be the authoritative set of permissions for that system.

socket策略文件的说明及Socket策略请求过程参考Ref中的相关文章，这里就不说明了。

# Ref
[Setting up a socket policy file server](http://www.adobe.com/cn/devnet/flashplayer/articles/socket_policy_files.html)  
[为flash建立socket安全策略文件服务器](http://blogread.cn/it/article/2984)  
[flash安全策略解决方案](http://www.111cn.net/flash_a/126/772ab48e892adc70ca41df26e9880f96.htm)  
[flash的socket连接安全策略](http://blog.csdn.net/kozazyh/article/details/5124550)  
[为Flash开启843端口](http://doc3.workerman.net/faq/843-port-for-flash-socket-policy-file.html)  

