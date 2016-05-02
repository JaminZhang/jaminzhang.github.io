---
layout: post
title: SSH配置使用HTTP代理
description: "SSH配置使用HTTP代理"
category: Linux
avatarimg:
tags: [SSH, Crokscrew]
duoshuo: true
---

# 引言
之前一直在Windows下使用Xshell远程登录服务器的，通过SSH密钥认证方式登录，然后使用了HTTP的代理。  
代理配置在Xshell里面直接配置的。可是今天，我需要在一台Linux服务器上配置SSH通过HTTP代理连接到另一台服务器，
因为我要通过SSH协议访问公司内部的GitLab。


# 什么是Corkkscrew
> 
Corkscrew is a tool for tunneling SSH through HTTP proxies.  
Corkscrew has been tested against several proxies requiring HTTP authentication.  
Several flaws exist as only basic authentication is currently supported.   
Digest authentication may be supported in the future.  
NTLM authentication will most likely never be supported. 

Corkscrew是一个用于通过HTTP代理访问SSH的工具。它已经在一些需要HTTP认证的代理上测试过。  
但现在只支持basic认证。Digest认证可能在将来支持。NTLM认证最可能永远不支持。

# 安装Corkscrew
去官网下载最新源码包，然后根据README中提到的安装方法来安装，
经典的安装步骤：配置、编译、安装

# 配置SSH使用Corkscrew
Crokscrew的README中写得很清楚了
在~/.ssh/config中添加以下一行配置：

```bash
ProxyCommand /usr/local/bin/corkscrew <proxyhost> <proxyport> %h %p [authfile]
```    

如果HTTP代理需要认证的用户名和密码，在~/.ssh下创建一个文件(如~/.ssh/myauth，这个文件对应上面的[authfile])放置用户名和密码，格式为： 用户名:密码  
然后为了安全将其权限设置为600

# Ref
[Corkscrew](http://agroman.net/corkscrew/)  
[Ssh在linux下使用http/https代理](http://duffqiu.github.io/blog/2015/02/26/ssh-proxy-in-linux/)  
[ssh通过代理连接服务器](https://www.52os.net/articles/ssh-over-proxies.html)  
[用ssh突破公司http代理](http://wp.fungo.me/linux/tunneling-ssh-over-http-proxy.html)  
[SSH的HTTP代理设置](https://cxwangyi.wordpress.com/2011/07/04/ssh%E7%9A%84http%E4%BB%A3%E7%90%86%E8%AE%BE%E7%BD%AE/)  




