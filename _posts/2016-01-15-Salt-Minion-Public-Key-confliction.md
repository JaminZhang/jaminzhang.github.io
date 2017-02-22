---
layout: post
title: Salt Minion Pulic Key 冲突
description: "Salt Minion Pulic Key 冲突"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 引言

一些业务的机器重装系统了，我们是用 SaltStack 进行批量命令执行的，然后发现这些重装的机器上的 Salt Minion 无法和 Salt Master 认证。

# 原因及解决方法

因为 Salt Master 上已经存在了这些机器重装之前的 Pubic Key，可以通过 salt-key -L 命令查找出来（Salt Minion 的 Public Key 默认存放路径为/etc/salt/pki/master/minions/）。  
机器重装之后 Salt Minion 会生成新的 Public Key，就与之前的 Public Key 冲突了。  

解决方法就是删除之前的 Public Key。  
使用 salt-key -d KEY-File 可以删除单个 key。但我这有一批机器，每次需要回答 yes 确认。   
通过 man，可以使用 -y 选项回答所有 yes。

<pre>
       -y, --yes
              Answer 'Yes' to all questions presented, defaults to False
</pre>

但这里还是遇到个问题，半天才解决，-y 和 -d 选项是有顺序的，-y 必须在 -d 前面，我测试是这种情况，不知是否是 bug (版本：salt-key 2015.5.5 (Lithium))。

最后使用一个 for 循环命令批量删除之前的老 key。

<pre>
for ip in `cat /root/groups/20160115new.txt`; do salt-key -y -d $ip ; done
</pre>



