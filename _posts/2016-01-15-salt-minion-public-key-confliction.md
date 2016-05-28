---
layout: post
title: salt minion pulic key冲突
description: "salt minion pulic key冲突"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 引言
一些业务的机器重装系统了，我们是用saltstack进行批量命令执行的，然后发现这些重装的机器上的salt minion无法和salt master认证。

# 原因及解决方法
因为salt master上已经存在了这些机器重装之前的pubic key，可以通过 salt-key -L命令查找出来（salt mininon的public key默认存放路径为/etc/salt/pki/master/minions/）。机器重装之后salt minion会生成新的public key，就与之前的key冲突了。  

于是解决方法就是删除之前的key。
使用salt-key -d KEY-File 可以删除单个key。但我这有一批机器，每次需要回答yes确认。  
通过man，可以使用-y选项回答所有yes。
<pre>
       -y, --yes
              Answer 'Yes' to all questions presented, defaults to False
</pre>

但这里还是遇到个问题，半天才解决，-y和-d选项是有顺序的，-y必须在-d前面，我测试是这种情况，不知是否是bug(版本：salt-key 2015.5.5 (Lithium))。

最后使用一个for循环命令批量删除之前的老key。
<pre>
for ip in `cat /root/groups/20160115new.txt`; do salt-key -y -d $ip ; done
</pre>



