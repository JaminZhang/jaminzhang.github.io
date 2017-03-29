---
layout: post
title: SSH 配置使用 HTTP 代理
description: "SSH 配置使用 HTTP 代理"
category: Linux
avatarimg:
tags: [SSH, Crokscrew, HTTP, Proxy]
duoshuo: true
---

# 引言

之前一直在 Windows 下使用 Xshell 远程登录服务器的，通过 SSH 密钥认证方式登录，然后使用了 HTTP 的代理。  
代理配置是在 Xshell 里面配置的。可是今天，我需要在一台 Linux 服务器上配置 SSH 通过 HTTP 代理连接到另一台服务器，  
因为我要通过 SSH 协议访问公司内部的 GitLab。


# 什么是 Corkkscrew

<pre>

Corkscrew is a tool for tunneling SSH through HTTP proxies.  
Corkscrew has been tested against several proxies requiring HTTP authentication.  
Several flaws exist as only basic authentication is currently supported.   
Digest authentication may be supported in the future.  
NTLM authentication will most likely never be supported. 

</pre>

Corkscrew 是一个用于通过 HTTP 代理访问 SSH 的工具。它已经在一些需要 HTTP 认证的代理上测试过。  
但现在只支持 basic 认证。Digest 认证可能在将来支持。NTLM 认证最可能永远不支持。

# 安装 Corkscrew

去官网下载最新源码包，然后根据 README 中提到的安装方法来安装，
经典的安装步骤：配置、编译、安装

# 配置 SSH 使用 Corkscrew

Crokscrew 的 README 中写得很清楚了
在`~/.ssh/config`中添加以下一行配置：

```bash
ProxyCommand /usr/local/bin/corkscrew <proxyhost> <proxyport> %h %p [authfile]
```    

如果 HTTP 代理需要认证的用户名和密码，在`~/.ssh`下创建一个文件(如`~/.ssh/myauth`，这个文件对应上面的[authfile])放置用户名和密码，
格式为： 用户名:密码  
然后为了安全将其权限设置为 600

# Ref
[Corkscrew](http://agroman.net/corkscrew/)  
[SSH 在 Linux下使用 HTTP/HTTPS 代理](http://duffqiu.github.io/blog/2015/02/26/ssh-proxy-in-linux/)  
[SSH 通过代理连接服务器](https://www.52os.net/articles/ssh-over-proxies.html)  
[用 SSH 突破公司 HTTP 代理](http://wp.fungo.me/linux/tunneling-ssh-over-http-proxy.html)  
[SSH 的 HTTP 代理设置](https://cxwangyi.wordpress.com/2011/07/04/ssh%E7%9A%84http%E4%BB%A3%E7%90%86%E8%AE%BE%E7%BD%AE/)  




