---
layout: post
title: SaltStack中的gitfs初步了解
description: "SaltStack中的gitfs初步了解"
category: SaltStack
avatarimg:
tags: [SaltStack, gitfs]
duoshuo: true
---

# 引言
之前谈到公司内部GitLab，我们也用它来管理维护业务相关运维脚本。  
这里有个问题就是，GitLab上的更新脚本后是怎么样传送到salt master，然后再分发给需要相关脚本的salt minion。
这里就用到了salt的gitfs。下面来了解一下。

# salt gitfs简介
>
The gitfs backend allows Salt to serve files from git repositories. It can be enabled by adding git to the fileserver_backend list, 
and configuring one or more repositories in gitfs_remotes.
Branches and tags become Salt fileserver environments.

> 
Salt支持Gitfs, 可以将State Tree放入Git远程仓库中, 进行版本控制, 易于管理  
当提交更新至远程Git仓库后, 需要手动在Master执行如下操作:  
salt-run fileserver.update  
或者等待一段时间,由Master的maintenance进程进行更新(默认更新间隔为60s, 可以通过master配置文件 loop_interval 选项进行调整).

>
gitfs使用git作为文件服务的源,这样一来,在开发环境中可以很方便的把修改同步到测试环境,  
同时在生产环境中也可以对sls这些比较重要的配置文件进行方便天然的版本管理。

下面简要列出gitfs在salt master配置文件中配置样例（之后会写一篇简要配置salt gitfs的文章）

```bash
[root@localhost ~]# grep -A 3 --color=auto fileserver_backend /etc/salt/master
#fileserver_backend:
#  - roots
#
gitfs_provider: pygit2
--
fileserver_backend:
  - git
  - roots
#
--
# fileserver_backend.
#
#fileserver_followsymlinks: False
#
[root@localhost ~]# grep -A 3 --color=auto gitfs_remotes /etc/salt/master
gitfs_remotes:
   - ssh://git@gitlab.xxx.cc:59878/gameopscript/gameopscript.git:
     - privkey: /root/.ssh/gameop/id_rsa
     - pubkey: /root/.ssh/gameop/id_rsa.pub
```    

# Ref
[GIT FILESERVER BACKEND WALKTHROUGH](https://docs.saltstack.com/en/latest/topics/tutorials/gitfs.html)  
[在SALTSTACK中启用GITFS](http://www.cnphp6.com/archives/25526)  
[Salt自动化之自动更新Gitfs](http://pengyao.org/salt-auto-gitfs-update.html)    
