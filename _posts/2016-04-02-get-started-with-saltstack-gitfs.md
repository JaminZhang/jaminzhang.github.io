---
layout: post
title: SaltStack 中的 gitfs 初步了解
description: "SaltStack 中的 gitfs初步了解"
category: SaltStack
avatarimg:
tags: [SaltStack, gitfs]
duoshuo: true
---

# 引言
之前谈到公司内部 GitLab，我们也用它来管理维护业务相关运维脚本。  
这里有个问题就是，GitLab 上的更新脚本后是怎么样传送到 Salt Master，然后再分发给需要相关脚本的 Salt Minion。
这里就用到了 Salt 的 gitfs。下面来了解一下。

# Salt gitfs 简介

<pre>

The gitfs backend allows Salt to serve files from git repositories. 
It can be enabled by adding git to the fileserver_backend list, 
and configuring one or more repositories in gitfs_remotes.
Branches and tags become Salt fileserver environments.

 
Salt 支持 gitfs, 可以将 State Tree 放入 Git 远程仓库中, 进行版本控制, 易于管理  
当提交更新至远程 Git 仓库后, 需要手动在 Master 执行如下操作:  
salt-run fileserver.update  
或者等待一段时间,由 Master 的 maintenance 进程进行更新
(默认更新间隔为 60s, 可以通过 Master 配置文件 loop_interval 选项进行调整).

gitfs 使用 git 作为文件服务的源,这样一来,在开发环境中可以很方便的把修改同步到测试环境,  
同时在生产环境中也可以对 SLS 这些比较重要的配置文件进行方便天然的版本管理。

</pre>

下面简要列出 gitfs 在 Salt Master 配置文件中配置样例（之后会写一篇简要配置 Salt gitfs 的文章）

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
