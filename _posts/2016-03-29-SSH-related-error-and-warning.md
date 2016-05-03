---
layout: post
title: SSH相关错误与提示
description: "SSH相关错误与提示"
category: Linux
avatarimg:
tags: [SSH, Crokscrew]
duoshuo: true
---

# 引言
之前配置通过SSH协议连接公司内部GitLab，遇到几个SSH相关的错误与提示，现在记录下来。  

# 错误1：ssh_exchange_identification: read: Connection reset by peer
出现如上提示，ssh交换认证信息阶段，连接被重置，服务器在接受公钥文件后拒绝了登录。  
为了查看更详细的连接信息，使用ssh -vv的选项再次连接，输出如下：

```bash
[root@iZ25p102vo3Z ~]# ssh -vv gitlab.xxx.cc -p 59878
OpenSSH_6.4, OpenSSL 1.0.1e-fips 11 Feb 2013
debug1: Reading configuration data /root/.ssh/config
debug1: /root/.ssh/config line 4: Applying options for gitlab.xxx.cc
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 51: Applying options for *
debug2: ssh_connect: needpriv 0
debug1: Connecting to gitlab.xxx.cc [xx.xx.xx.xx] port 59878.
debug1: Connection established.
debug1: permanently_set_uid: 0/0
debug1: identity file /root/.ssh/id_rsa type 1
debug1: identity file /root/.ssh/id_rsa-cert type -1
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_6.4
ssh_exchange_identification: read: Connection reset by peer
```    

第一反应就是服务器配置了/etc/hosts.allow和/etc/hosts.deny，我们连接服务器都需要通过代理连接。
于是配置SSH使用HTTP代理来登录服务器。

# 提示2：PTY allocation request failed on channel 0

```bash
[root@iZ25p102vo3Z .ssh]# ssh git@gitlab.xxx.cc -p 59878
Enter passphrase for key '/root/.ssh/id_rsa':
PTY allocation request failed on channel 0
Welcome to GitLab, jamin!
Connection to gitlab.xxx.cc closed.
```    

分析一下以上输出，PTY allocation request failed on channel 0, PTY是伪终端，提示伪终端请求分配失败。
然后连接成功后输出欢迎信息，最后连接又被关闭了。

下面是对上面输出信息的解释分析，说得比较好。
>
The “PTY allocation request failed” warning is innocuous when using command-line ssh to login to a service that does not provide normal interactive access. 
Git-over-SSH does not need a tty and GitHub’s SSH service is configured to refuse to allocate one for incoming connections. 
You can tell ssh not to ask for a tty with ssh -T git@github.com.

“PTY allocation request failed”这个警告无伤大雅，它会出现是当使用命令行SSH登录了一个不提供正常交互式访问的服务。  
基于SSH的Git不需要一个tty, GitHub（GitLab也应该一样）的SSH服务被配置成拒绝分配一个tty给入站连接。  
你可以告诉SSH不要请求一个tty，使用ssh -T的选项。


# Ref
[What to do about “PTY allocation request failed on channel 0”](http://stackoverflow.com/questions/3844393/what-to-do-about-pty-allocation-request-failed-on-channel-0)  
[TTY](https://en.wikipedia.org/wiki/TTY)  
[Pseudoterminal](https://en.wikipedia.org/wiki/Pseudoterminal)  




